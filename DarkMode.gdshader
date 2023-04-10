shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec3 c = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	float luminance = c.r * 0.3 + c.g * 0.59 + c.b * 0.11;
	vec3 black_color = vec3(0.07, 0.06, 0.08);
	vec3 blackened = mix(c, black_color, smoothstep(.6, .9, luminance));
	vec3 whitened = mix(vec3(1.0), c,  smoothstep(.1, .4, luminance));
	COLOR.rgb = mix(whitened, blackened, luminance);
}
