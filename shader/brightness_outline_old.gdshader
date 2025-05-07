shader_type canvas_item;

// 亮度参数
uniform float brightness : hint_range(0.0, 2.0) = 1.0; // 亮度增益，1.0 为原始亮度

// 描边参数
uniform float outline_size : hint_range(0.0, 10.0) = 2.0; // 描边宽度（像素）
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0); // 描边颜色，默认黑色
uniform float outline_threshold : hint_range(0.0, 1.0) = 0.5; // 描边阈值

void fragment() {
    // 获取原始纹理颜色
    vec4 color = texture(TEXTURE, UV);

    // 提升亮度
    vec3 brightened_color = color.rgb * brightness;

    // 默认输出亮度调整后的颜色
    COLOR = vec4(brightened_color, color.a);

    // 如果 outline_size > 0，才执行描边逻辑
    if (outline_size > 0.0) {
        vec2 pixel_size = 1.0 / vec2(textureSize(TEXTURE, 0)); // 每个像素的大小
        float max_alpha = color.a; // 中心像素的透明度
        bool is_outline = false;

        // 检查周围像素，寻找边界
        for (int x = -1; x <= 1; x++) {
            for (int y = -1; y <= 1; y++) {
                if (x == 0 && y == 0) continue; // 跳过中心像素
                vec2 offset = vec2(float(x), float(y)) * outline_size * pixel_size;
                float neighbor_alpha = texture(TEXTURE, UV + offset).a;

                // 如果中心不透明且周围有透明像素，标记为描边
                if (max_alpha > outline_threshold && neighbor_alpha <= outline_threshold) {
                    is_outline = true;
                    break;
                }
            }
            if (is_outline) break; // 提前退出外层循环
        }

        // 如果是描边区域，应用描边颜色
        if (is_outline) {
            COLOR = outline_color;
        }
    }
}