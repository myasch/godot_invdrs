shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.b *= 1.0 - (UV[1] * UV[1]);
	COLOR.r *= 0.25 + UV[1] * UV[1];
	COLOR.g *= 0.25 + UV[0] * UV[0];
}