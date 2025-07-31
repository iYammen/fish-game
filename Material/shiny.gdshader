shader_type canvas_item;

uniform float shine_pixel_width = 20.0; // Width in pixels
uniform float shine_speed = 1.5;
uniform float shine_strength = 1.0;
uniform float shine_angle = 0.0; // In radians
uniform int shine_count = 1; // How many bands appear at once
uniform vec4 shine_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec2 uv = UV;
	vec4 tex_color = texture(TEXTURE, uv);
	vec4 final_color = tex_color;

	if (tex_color.a > 0.05) {
		float time_offset = mod(TIME * shine_speed, 2.0) - 1.0;

		// Build rotation matrix
		float c = cos(shine_angle);
		float s = sin(shine_angle);
		mat2 rot = mat2(vec2(c, s), vec2(-s, c));

		// Rotate UV
		vec2 rotated_uv = rot * (uv - vec2(0.5));

		// Convert pixel width to UV width
		float uv_width = shine_pixel_width * TEXTURE_PIXEL_SIZE.x;

		// Control how many shines appear
		float x = rotated_uv.x * float(shine_count);

		// Create multiple shine bands
		float band = fract(x - time_offset);
		band = smoothstep(0.0, uv_width, band) *
		       (1.0 - smoothstep(uv_width, uv_width * 2.0, band));

		vec4 shine = shine_color * band * shine_strength;
		final_color += shine;
	}

	COLOR = final_color;
}
