shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float blur_amount : hint_range(0.0, 0.01) = 0.005; // 模糊强度
uniform float blur_radius : hint_range(0.0, 1.0) = 0.5; // 模糊半径
uniform vec2 center = vec2(0.5, 0.5); // 模糊中心点
uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.5; // 晕影/颜色变化强度


void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 color = vec4(0.0);
    float samples = 16.0;

    // 计算距离中心的距离
    float dist = distance(uv, center);
    float blur = smoothstep(0.0, blur_radius, dist) * blur_amount;

    // 多重采样实现模糊
    for (float i = -samples / 2.0; i <= samples / 2.0; i += 1.0) {
        for (float j = -samples / 2.0; j <= samples / 2.0; j += 1.0) {
            vec2 offset = vec2(i, j) * blur / samples;
            color += texture(SCREEN_TEXTURE, uv + offset);
        }
    }
    color /= (samples * samples);

    // 添加晕影效果（降低亮度）
    float vignette = smoothstep(0.0, blur_radius, dist) * vignette_intensity;
    color.rgb *= (1.0 - vignette);

    // 根据距离中心混合颜色（基于 ColorRect 的颜色或 tint_color）
    vec4 base_color = COLOR; // ColorRect 的默认颜色（如果未设置，则为透明）
    vec4 final_color = mix(color, COLOR , vignette * vignette_intensity); // 边缘逐渐变为 tint_color

    COLOR = final_color;
}