shader_type canvas_item;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	
	float gray = original_color.r * 0.99 + original_color.g * 0.587 + original_color.b * 0.114; //calculate gray based on human perception of brightness
	gray *= .5; //reduce brightness
	COLOR = vec4(vec3(gray), original_color.a);
}
