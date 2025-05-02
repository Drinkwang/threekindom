
shader_type canvas_item;

// 亮度参数
uniform float brightness : hint_range(0.0, 2.0) = 1.0; // 亮度增益，1.0 为原始亮度
uniform float global_alpha : hint_range(0.0, 1.0) = 1.0; // 全局透明度

// 多层描边参数
uniform float outline_size : hint_range(0.0, 10.0) = 2.0; // 最大描边宽度（像素）
uniform vec4 outline_color_1 : source_color = vec4(0.0, 0.0, 0.0, 1.0); // 第一层描边颜色
uniform vec4 outline_color_2 : source_color = vec4(0.0, 0.0, 0.0, 0.7); // 第二层描边颜色
uniform vec4 outline_color_3 : source_color = vec4(0.0, 0.0, 0.0, 0.4); // 第三层描边颜色
uniform float outline_threshold : hint_range(0.0, 1.0) = 0.5; // 描边阈值
uniform float outline_step : hint_range(0.0, 5.0) = 1.0; // 每层描边宽度增量

void fragment() {
    // 获取原始纹理颜色
    vec4 color = texture(TEXTURE, UV);

    // 提升亮度
    vec3 brightened_color = color.rgb * brightness;

    // 默认输出亮度调整后的颜色，应用全局透明度
    vec4 final_color = vec4(brightened_color, color.a * global_alpha);

    // 如果 outline_size > 0，执行多层描边逻辑
    if (outline_size > 0.0) {
        vec2 pixel_size = 1.0 / vec2(textureSize(TEXTURE, 0)); // 每个像素的大小
        float max_alpha = color.a; // 中心像素的透明度
        bool is_outline = false;
        vec4 outline_color = vec4(0.0); // 最终描边颜色

        // 检查多层描边（3层）
        for (int layer = 1; layer <= 3; layer++) {
            float current_size = outline_size + float(layer - 1) * outline_step; // 每层宽度递增
            bool layer_is_outline = false;

            // 检查周围像素，寻找当前层的边界
            for (int x = -1; x <= 1; x++) {
                for (int y = -1; y <= 1; y++) {
                    if (x == 0 && y == 0) continue; // 跳过中心像素
                    vec2 offset = vec2(float(x), float(y)) * current_size * pixel_size;
                    float neighbor_alpha = texture(TEXTURE, UV + offset).a;

                    // 如果中心不透明且周围有透明像素，标记为描边
                    if (max_alpha > outline_threshold && neighbor_alpha <= outline_threshold) {
                        layer_is_outline = true;
                        break;
                    }
                }
                if (layer_is_outline) break; // 提前退出内层循环
            }

            // 应用当前层的描边颜色（优先级：内层 > 外层）
            if (layer_is_outline && !is_outline) {
                is_outline = true;
                if (layer == 1) {
                    outline_color = outline_color_1;
                } else if (layer == 2) {
                    outline_color = outline_color_2;
                } else if (layer == 3) {
                    outline_color = outline_color_3;
                }
            }
        }

        // 如果是描边区域，应用描边颜色并保留全局透明度
        if (is_outline) {
            final_color = vec4(outline_color.rgb, outline_color.a * global_alpha);
        }
    }

    // 输出最终颜色
    COLOR = final_color;
}

