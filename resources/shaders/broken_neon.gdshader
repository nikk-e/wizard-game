shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.2, 0.8, 1.0);
uniform float base_intensity = 1.0;
uniform float flicker_speed = 3.0;
uniform float flicker_strength = 0.4;
uniform float noise_scale = 5.0;
uniform float glow_strength = 3.0;

float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float broken_flicker(float t) {
    float n = rand(vec2(floor(t)));
    if (n < 0.1) {
        return 0.0; // Flicker off
    } else if (n < 0.15) {
        return 1.3; // Sudden flash
    }
    return 1.0;
}

void fragment() {
    float time = TIME * flicker_speed;
    float noise = rand(vec2(time, UV.y * noise_scale));

    // Flicker pattern using sine and noise
    float flicker = base_intensity * broken_flicker(time) + sin(time * 10.0 + noise * 6.28) * flicker_strength;

    // Clamp to avoid negative glow
    flicker = clamp(flicker, 0.0, 1.4);

	vec4 tex_color = texture(TEXTURE, UV);
	COLOR = tex_color;
    COLOR = glow_color * flicker * tex_color.a * glow_strength;
}