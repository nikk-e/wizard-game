shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float glow_strength = 2.0;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	COLOR = tex_color;
	if (COLOR.r > 0.99 && COLOR.g > 0.99  && COLOR.b > 0.99) {
		COLOR.rgb = glow_color.rgb * glow_strength * tex_color.a;
	}

}