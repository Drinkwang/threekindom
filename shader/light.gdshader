shader_type canvas_item;
uniform sampler2D textureSample:hint_screen_texture;

void fragment() {
	COLOR=texture(textureSample,SCREEN_UV);
	COLOR.a=texture(TEXTURE,UV).a;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
