shader_type canvas_item;

uniform sampler2D noise_texture; // 噪声纹理，用于随机烧毁效果
uniform float burn_progress : hint_range(0.0, 1.0) = 0.0; // 烧毁进度
uniform vec4 burn_color : source_color = vec4(1.0, 0.5, 0.0, 1.0); // 烧毁边缘颜色（橙色火焰）
uniform float burn_width : hint_range(0.0, 0.1) = 0.05; // 烧毁边缘宽度

// 技能使用时的闪光/闪烁效果参数
uniform float skill_glow = 1.0; // 是否启用闪光（通过强度控制显示）
uniform vec4 skill_glow_color : source_color = vec4(1.0, 0.95, 0.3, 1.0); // 金色闪光
uniform float skill_glow_strength : hint_range(0.0, 4.0) = 0.0; // 闪光强度（动画驱动）
uniform float skill_glow_frequency : hint_range(0.5, 10.0) = 6.0; // 闪烁频率

float rand(vec2 co) {
    return fract(sin(dot(co.xy , vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    // 卡牌原始纹理
    vec4 tex_color = texture(TEXTURE, UV);

    // 获取噪声纹理的采样值
    float noise_value = texture(noise_texture, UV).r;
    // 计算烧毁阈值
    float threshold = burn_progress * 1.2; // 略微放大范围以确保完全消失
    // 根据噪声值和进度决定是否显示像素
    float burn_edge = smoothstep(threshold - burn_width, threshold, noise_value);
    // 计算边缘火焰效果
    vec4 edge_color = burn_color * smoothstep(threshold - burn_width, threshold, noise_value - burn_width);
    // 混合颜色：如果像素被烧毁（noise_value < threshold），则透明；否则显示原纹理或边缘颜色
    COLOR = mix(vec4(0.0), tex_color, burn_edge);
    COLOR += edge_color * (1.0 - burn_edge); // 添加火焰边缘效果

    // 技能使用时的闪光与闪烁覆盖层
    float pulse = 0.5 + 0.5 * sin(TIME * skill_glow_frequency);
    // 细小的闪烁点（程序噪声实现）
    float sparkle = smoothstep(0.98 - 0.04 * pulse, 0.995, rand(UV * vec2(256.0, 192.0)));
    // 边缘柔光（靠近边框更亮）
    float edge_dist = min(min(UV.x, UV.y), min(1.0 - UV.x, 1.0 - UV.y));
    float border_glow = smoothstep(0.0, 0.18, 0.18 - edge_dist) * (0.6 + 0.4 * pulse);

    float glow = (sparkle * 0.7 + border_glow) * skill_glow_strength;
    COLOR.rgb += skill_glow_color.rgb * glow * skill_glow;
}