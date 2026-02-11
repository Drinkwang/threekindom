shader_type canvas_item;

// 核心可调参数
uniform float bg_threshold = 0.1;          // 背景黑色透明阈值
uniform float edge_threshold = 0.15;       // 边缘检测灵敏度（调小更精准）
uniform float stroke_pixels : hint_range(0.0, 5.0) = 1.0; // 描边厚度（像素数）
uniform vec3 stroke_color = vec3(0.0);     // 描边颜色（纯黑）

void fragment() {
    // 1. 采样当前像素颜色
    vec4 original_color = texture(TEXTURE, UV);
    bool is_black_bg = (original_color.r < bg_threshold) && 
                       (original_color.g < bg_threshold) && 
                       (original_color.b < bg_threshold);
    
    // 2. 计算UV步长（适配纹理分辨率）
    ivec2 tex_size_ivec = textureSize(TEXTURE, 0);
    vec2 tex_size = vec2(tex_size_ivec);
    float uv_step_x = stroke_pixels / tex_size.x;
    float uv_step_y = stroke_pixels / tex_size.y;
    
    // 3. 检测：当前像素是否是「物体外部的透明区域」且靠近物体边缘
    bool is_outside_edge = false;
    float current_brightness = (original_color.r + original_color.g + original_color.b) / 3.0;
    
    // 只在透明背景区域检测是否靠近物体（向外描边的核心）
    if (is_black_bg) {
        // 采样周围8个方向的像素，判断是否靠近物体
        vec2 offsets[8] = vec2[](
            vec2(-uv_step_x, -uv_step_y), vec2(0.0, -uv_step_y), vec2(uv_step_x, -uv_step_y),
            vec2(-uv_step_x, 0.0),                                 vec2(uv_step_x, 0.0),
            vec2(-uv_step_x, uv_step_y),  vec2(0.0, uv_step_y),  vec2(uv_step_x, uv_step_y)
        );
        
        for (int i = 0; i < 8; i++) {
            vec4 neighbor_color = texture(TEXTURE, UV + offsets[i]);
            float neighbor_brightness = (neighbor_color.r + neighbor_color.g + neighbor_color.b) / 3.0;
            // 如果周围像素是物体（非背景），说明当前像素是物体外边缘 → 绘制描边
            if (neighbor_brightness > edge_threshold) {
                is_outside_edge = true;
                break;
            }
        }
    }
    
    // 4. 最终颜色赋值
    if (is_outside_edge) {
        // 物体外边缘 → 绘制黑色描边
        COLOR = vec4(stroke_color, 1.0);
    } else if (is_black_bg) {
        // 纯黑背景（非边缘）→ 完全透明
        COLOR = vec4(0.0, 0.0, 0.0, 0.0);
    } else {
        // 物体本身 → 保留原颜色
        COLOR = original_color;
    }
}