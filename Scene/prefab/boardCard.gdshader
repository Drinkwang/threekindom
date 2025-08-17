shader_type canvas_item;

uniform sampler2D noise_texture; // 噪声纹理，用于随机烧毁效果
uniform float burn_progress : hint_range(0.0, 1.0) = 0.0; // 烧毁进度
uniform vec4 burn_color : source_color = vec4(1.0, 0.5, 0.0, 1.0); // 烧毁边缘颜色（橙色火焰）
uniform float burn_width : hint_range(0.0, 0.1) = 0.05; // 烧毁边缘宽度

void fragment() {
    // 获取噪声纹理的采样值
    float noise_value = texture(noise_texture, UV).r;
    // 计算烧毁阈值
    float threshold = burn_progress * 1.2; // 略微放大范围以确保完全消失
    // 根据噪声值和进度决定是否显示像素
    float burn_edge = smoothstep(threshold - burn_width, threshold, noise_value);
    // 卡牌原始纹理
    vec4 tex_color = texture(TEXTURE, UV);
    // 计算边缘火焰效果
    vec4 edge_color = burn_color * smoothstep(threshold - burn_width, threshold, noise_value - burn_width);
    // 混合颜色：如果像素被烧毁（noise_value < threshold），则透明；否则显示原纹理或边缘颜色
    COLOR = mix(vec4(0.0), tex_color, burn_edge);
    COLOR += edge_color * (1.0 - burn_edge); // 添加火焰边缘效果
}