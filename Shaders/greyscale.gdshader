shader_type canvas_item;

	uniform bool active = false;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	
	float grayscale = (original_color.r * 0.299 + original_color.g * 0.587 + original_color.b * 0.114);
	
	vec3 grayscale_color = vec3(grayscale, grayscale, grayscale);
	
	COLOR.rgb = grayscale_color;
	COLOR.a = original_color.a;
}
