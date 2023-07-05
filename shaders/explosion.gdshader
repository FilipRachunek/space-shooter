shader_type spatial;
render_mode depth_draw_opaque, shadows_disabled, skip_vertex_transform;

uniform vec2 texture_speed = vec2(0.0, 1.0);

uniform float flash_power : hint_range(0.0, 10.0) = 1.0;
uniform vec4 flash_color : source_color = vec4(1.0, 0.85, 0.42, 1.0);

uniform float fire_power : hint_range(0.0, 10.0) = 1.0;
instance uniform float fire_aperture : hint_range(0.0, 3.0) = 0.25;
uniform vec4 fire_root_color : source_color = vec4(1.0, 0.75, 0.3, 1.0);
uniform vec4 fire_tip_color : source_color = vec4(1.0, 0.03, 0.0, 1.0);
uniform float fire_speed = 1.0;

uniform float smoke_power : hint_range(0.0, 10.0) = 1.0;
uniform float smoke_aperture : hint_range(0.0, 3.0) = 0.45;
uniform vec4 smoke_color1 : source_color = vec4(0.46, 0.46, 0.46, 1.0);
uniform vec4 smoke_color2 : source_color = vec4(0.185, 0.185, 0.185, 1.0);
uniform float smoke_speed = 0.1;

global uniform float global_time;

void vertex() {
    MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
    VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

float random(vec2 pos) { 
    return fract(sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453);
}

float value_noise(vec2 pos) {
    vec2 p = floor(pos);
    vec2 f = fract(pos);

    float v00 = random(p + vec2(0.0, 0.0));
    float v10 = random(p + vec2(1.0, 0.0));
    float v01 = random(p + vec2(0.0, 1.0));
    float v11 = random(p + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(mix(v00, v10, u.x), mix(v01, v11, u.x), u.y);
}

float noise_texture(vec2 uv) {
    return (
        value_noise(uv * 0.984864) * 0.5
        + value_noise(uv * 2.543) * 0.25
        + value_noise(uv * 9.543543) * 0.125
        + value_noise(uv * 21.65436) * 0.0625
        + value_noise(uv * 42.0) * 0.03125
        + value_noise(uv * 87.135148) * 0.015625
        + value_noise(uv * 340.66534654) * 0.0078125
    );
}

void fragment() {
    float flash = clamp((1.0 - length(vec2(0.5, 0.5) - UV) * 2.0) * flash_power, 0.0, 1.0);
    float fire = clamp((1.0 - length(vec2(0.5, 0.5) - UV) * 2.0) * fire_power, 0.0, 1.0);
    float fire_noise = fire * (((fire + fire_aperture) * noise_texture(UV * 3.0 + texture_speed * global_time * fire_speed) - fire_aperture) * 75.0);
    vec4 fire_color = mix(fire_tip_color, fire_root_color, fire_noise * 0.5);

    float smoke = clamp((1.0 - length(vec2(0.5, 0.5) - UV) * 2.0) * smoke_power, 0.0, 1.0);
    float smoke_noise_texel = noise_texture(UV + texture_speed * global_time * smoke_speed);
    float smoke_noise = smoke * (((smoke + smoke_aperture) * smoke_noise_texel - smoke_aperture) * 75.0);
    vec4 smoke_color = mix(smoke_color1, smoke_color2, clamp(smoke_noise_texel * 4.0 - 1.5, 0.0, 1.0));

    EMISSION = (
        flash_color.rgb * flash
        + fire_color.rgb * clamp(fire_noise, 0.0, 1.0)
    );
    ALBEDO = (
        smoke_color.rgb * clamp(smoke_noise, 0.0, 1.0)
    );
    ALPHA = clamp(flash + fire_noise + smoke_noise, 0.0, 1.0);
}
