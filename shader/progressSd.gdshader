shader_type canvas_item;

uniform sampler2D progress_texture; // 进度纹理
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // 描边颜色
uniform vec4 bg_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // 描边颜色
uniform float outline_width : hint_range(0.0, 0.1) = 0.02; // 描边宽度（比例）
uniform float fill_degrees = 360.0; // 填充角度
uniform float initial_angle = 0.0;
uniform float radius_threshold : hint_range(0.0, 0.5) = 0.45; // 圆形外边缘的半径阈值
void fragment() {
    vec2 uv = UV - vec2(0.5); // 将 UV 坐标移到中心
    float angle = atan(uv.y, uv.x) * 180.0 / 3.14159; // 计算当前像素的角度

    angle = mod(angle - initial_angle, 360.0); // 调整角度以匹配起始角度
    vec4 tex_color = texture(progress_texture, UV); // 获取进度纹理颜色
    float dist = length(uv); // 计算到中心的距离（用于检测圆形边缘）

    // 计算扇形区域
    bool in_sector = angle <= fill_degrees && tex_color.a > 0.0;

    // 计算描边区域
    // 1. 终点描边
    bool in_end_outline = angle > fill_degrees && angle <= fill_degrees + outline_width * 360.0 && tex_color.a > 0.0;
    // 2. 起点描边
    bool in_start_outline = angle >= 360.0 - outline_width * 360.0 && angle < 360.0 && tex_color.a > 0.0 && fill_degrees > 0.0;
    // 3. 圆形外边缘描边（基于距离）
    bool in_radius_outline = dist > radius_threshold && dist <= radius_threshold + outline_width && in_sector;

    if (in_sector) {
        COLOR = tex_color*bg_color; // 扇形区域使用原纹理颜色
    } else if (in_end_outline || in_start_outline || in_radius_outline) {
        COLOR = outline_color * tex_color.a; // 描边区域使用描边颜色，保留纹理透明度
    } else {
        COLOR = vec4(0.0, 0.0, 0.0, 0.0); // 透明区域，确保不遮挡
    }
}