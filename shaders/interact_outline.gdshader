shader_type canvas_item;

uniform bool outline_enabled = true;
uniform vec4 outline_color : source_color = vec4(1.0);

void fragment()
{
    vec2 pixel_size = TEXTURE_PIXEL_SIZE;
    vec4 current_color = texture(TEXTURE, UV);
    float current_alpha = current_color.a;

    float right_alpha = texture(TEXTURE, UV + vec2(pixel_size.x, 0.0)).a;
    float left_alpha = texture(TEXTURE, UV - vec2(pixel_size.x, 0.0)).a;
	float top_alpha = texture(TEXTURE, UV - vec2(0.0, pixel_size.y)).a;
	float bottom_alpha = texture(TEXTURE, UV + vec2(0.0, pixel_size.y)).a;
    float neighbor_alpha = max(
		max(left_alpha, right_alpha),
		max(top_alpha, bottom_alpha)
	);
	float outline_alpha = 0.0;
	if(outline_enabled) {
	    outline_alpha = neighbor_alpha * (1.0 - current_alpha);
	}

    if (outline_alpha > 0.0) {
        COLOR = vec4(outline_color.rgb, outline_alpha);
    } else {
        COLOR = current_color;
    }
}