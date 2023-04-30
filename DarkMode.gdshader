shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

vec3 hue_shift(vec3 color, float dhue) {
	float s = sin(dhue);
	float c = cos(dhue);
	return (color * c) + (color * s) * mat3(
		vec3(0.167444, 0.329213, -0.496657),
		vec3(-0.327948, 0.035669, 0.292279),
		vec3(1.250268, -1.047561, -0.202707)
	) + dot(vec3(0.299, 0.587, 0.114), color) * (1.0 - c);
}

void fragment() {
	vec3 c = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;

	// Old way of re-mapping colors, left for future reference
	// float luminance = c.r * 0.3 + c.g * 0.59 + c.b * 0.11;
	// vec3 black_color = vec3(0.07, 0.06, 0.08);
	// vec3 blackened = mix(c, black_color, smoothstep(.6, .9, luminance));
	// vec3 whitened = mix(vec3(1.0), c,  smoothstep(.1, .4, luminance));
	// COLOR.rgb = mix(whitened, blackened, luminance);

	vec3 inverted = 1.0 - c;

	COLOR.rgb = hue_shift(inverted, PI);
}
