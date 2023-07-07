shader_type spatial;

render_mode unshaded, blend_add;

uniform sampler2D noise_texture : source_color;
uniform vec4 color_rim : source_color = vec4(0.57, 0.9, 1.0, 0.96);
uniform vec4 color_noise : source_color = vec4(0.21, 0.84, 1.0, 1.0);
instance uniform float alpha : hint_range(0.0, 1.0, 0.01) = 1.0;

void vertex() {
	//Billboarding
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0), vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0), vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0), vec4(0.0, 0.0, 0.0, 1.0));
}

void fragment() {
	
	float dist = length(vec2(UV - 0.5) * 2.0);
	if (dist > 1.0) {
		dist = 0.0;
	}
	dist = pow(dist, 6.0);
	
	ALBEDO = color_rim.rgb * dist * color_rim.a;
	
	vec3 noise_color_1 = texture(noise_texture, vec2(UV.x + TIME / 2.0, UV.y)).rgb;
	vec3 noise_color_2 = texture(noise_texture, vec2(UV.x - TIME / 1.8, UV.y)).rgb;
	vec3 noise_color_3 = texture(noise_texture, vec2(UV.x, UV.y + TIME / 2.1)).rgb;
	vec3 noise_color_4 = texture(noise_texture, vec2(UV.x, UV.y - TIME / 2.2)).rgb;
	
	vec3 noise_color_x = mix(noise_color_1, noise_color_2, 0.5);
	vec3 noise_color_y = mix(noise_color_3, noise_color_4, 0.5);
	vec3 noise_color = mix(noise_color_x, noise_color_y, 0.5) * dist * color_noise.rgb * color_noise.a;

	ALBEDO = mix(ALBEDO, noise_color, 0.75) * alpha;
	ALPHA = dist * color_noise.a * alpha;
}
