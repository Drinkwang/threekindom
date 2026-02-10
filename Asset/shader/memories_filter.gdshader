shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;
uniform float intensity : hint_range(0.0, 1.0) = 1.0;  // 效果强度
uniform float desaturation_amount : hint_range(0.0, 1.0) = 0.6;  // 去饱和度
uniform float sepia_strength : hint_range(0.0, 1.0) = 0.8;  // 棕褐强度
uniform float vignette_strength : hint_range(0.0, 0.5) = 0.1;  // 晕影强度（降低范围，避免过度暗化）
uniform float blur_size : hint_range(0.0, 5.0) = 1.0;  // 模糊大小（轻微）

void fragment() {
    vec2 uv = SCREEN_UV;

    // 优化模糊：改为全屏均匀的4方向模糊（上下左右），性能友好且效果均匀
    vec2 blur_offset = blur_size * SCREEN_PIXEL_SIZE * intensity;
    vec4 color = texture(screen_texture, uv) * 0.4;
    color += texture(screen_texture, uv + vec2(blur_offset.x, 0.0)) * 0.15;  // 右
    color += texture(screen_texture, uv - vec2(blur_offset.x, 0.0)) * 0.15;  // 左
    color += texture(screen_texture, uv + vec2(0.0, blur_offset.y)) * 0.15;  // 上
    color += texture(screen_texture, uv - vec2(0.0, blur_offset.y)) * 0.15;  // 下

    // 去饱和度（核心：基于强度混合，保证全屏均匀）
    float luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 desat = mix(color.rgb, vec3(luminance), desaturation_amount * intensity);

    // 棕褐色调（Sepia）：修正混合逻辑，全屏均匀叠加
    vec3 sepia = vec3(
        dot(desat, vec3(0.393, 0.769, 0.189)),
        dot(desat, vec3(0.349, 0.686, 0.168)),
        dot(desat, vec3(0.272, 0.534, 0.131))
    );
    // 正确混合：去饱和后的颜色 + 棕褐色调，基于sepia_strength和intensity
    vec3 final_color = mix(desat, sepia, sepia_strength * intensity);

    // 优化晕影：降低强度+调整公式，让全屏暗化更均匀（而非椭圆黑边）
    vec2 vig_uv = (uv - 0.5) * vec2(SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x, 1.0); // 适配屏幕比例
    float vignette = 1.0 - (dot(vig_uv, vig_uv) * vignette_strength * intensity);
    vignette = clamp(vignette, 0.8, 1.0); // 限制晕影最小值，避免边缘过黑

    // 最终输出：全屏均匀的回忆滤镜效果
    COLOR = vec4(final_color * vignette, color.a);
}