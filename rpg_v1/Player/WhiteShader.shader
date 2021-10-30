shader_type canvas_item;

// whether or not the sprite is white, uniform is like export var
uniform bool active = false;

// func for creating a white shader over sprite
void fragment() {
	// gets the color of every pixel in the texture
	vec4 previous_color = texture(TEXTURE, UV);
	
	// creates white mask with rbga
	vec4 white_color = vec4(1, 1, 1, previous_color.a);
	
	// automatically sets color to previous color
	COLOR = previous_color;
	
	// if active, color is white mask
	if (active) {
		COLOR = white_color;
	}
}