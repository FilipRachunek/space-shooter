shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 center;
uniform float force;
uniform float size;

void fragment() {
	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 frag_uv = FRAGCOORD.xy / resolution.xy;
	float aspect_ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 aspect_uv = (frag_uv - vec2(0.5, 0.0)) / vec2(aspect_ratio, 1.0) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(size - 0.1, size, length(aspect_uv - center))) * smoothstep(size - 0.2, size - 0.1, length(aspect_uv - center));
	vec2 displacement = normalize(aspect_uv - center) * force * mask;
	COLOR = texture(screen_texture, frag_uv - displacement);
}
