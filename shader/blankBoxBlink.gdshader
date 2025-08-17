shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 0.0, 1.0); // 发光颜色（默认黄色）
uniform float glow_intensity : hint_range(0.0, 2.0) = 1.0; // 发光强度
uniform float glow_radius : hint_range(0.0, 0.1) = 0.05; // 发光半径
uniform vec4 base_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // ColorRect 的基础颜色

void fragment() {
    // 计算到中心的距离，UV 从 (0,0) 到 (1,1)
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(UV, center);
    
    // 确定圆的半径（基于 UV 坐标，0.5 是最大半径）
    float circle_radius = 0.5;
    
    // 计算主体圆形区域（内部不透明）
    float circle = smoothstep(circle_radius, circle_radius - 0.01, dist); // 裁剪为圆形，0.01 控制边缘平滑度
    
    // 计算发光效果，基于距离生成柔和的辉光
    float glow = smoothstep(circle_radius, circle_radius + glow_radius, dist) * glow_intensity;
    
    // 混合基础颜色和发光颜色
    vec4 final_color = mix(base_color, glow_color, glow);
    
    // 应用圆形裁剪和发光效果
    COLOR = vec4(final_color.rgb, circle * base_color.a); // 圆形区域不透明，外部透明
}