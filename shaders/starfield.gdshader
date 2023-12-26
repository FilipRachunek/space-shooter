#define S(x, y, s) smoothstep(x, y, s)
shader_type canvas_item;
render_mode unshaded;

void fragment() {
	vec2 uv = (SCREEN_UV - 0.5) / vec2(SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y, 1.0);
	vec3 color = vec3(0.0);
	float dist = length(vec2(0.0, 0.0) + uv);
	float elem = 0.005 / dist;
	color += elem * S(0.4, 0.05, dist) * vec3(0.9, 0.0, 0.0);
	COLOR = vec4(color, 1.0);
}
