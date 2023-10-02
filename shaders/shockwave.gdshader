shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 center = vec2(0.5, 0.5);
uniform float power = 0.2;
uniform float size = 0.0;
uniform float sharpness = 0.1;
uniform float thickness = 0.1;

void fragment() {
	// vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 frag_uv = FRAGCOORD.xy * SCREEN_PIXEL_SIZE;
	float aspect_ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 aspect_uv = (frag_uv - vec2(0.5, 0.0)) / vec2(aspect_ratio, 1.0) + vec2(0.5, 0.0);
	float annulus = (1.0 - smoothstep(size - sharpness, size, length(aspect_uv - center))) * smoothstep(size - sharpness - thickness, size - sharpness, length(aspect_uv - center));
	vec2 displacement = normalize(aspect_uv - center) * power * annulus;
	COLOR = texture(screen_texture, frag_uv - displacement);
}
