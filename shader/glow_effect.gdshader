shader_type canvas_item;

uniform float glow_intensity = 1.0;
uniform vec4 glow_color:source_color = vec4(1.0, 1.0, 0.0, 1.0);

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    color.rgb += glow_color.rgb * glow_intensity * sin(TIME * 2.0);
    COLOR = color;
}

