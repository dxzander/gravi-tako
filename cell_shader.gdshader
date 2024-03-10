//rgb to hsv from https://godotshaders.com/shader/hsv-adjustment/

shader_type spatial;
render_mode cull_disabled, depth_prepass_alpha;

uniform sampler2D main_texture : source_color, hint_default_white;
uniform vec4 main_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform bool is_glass = false;
uniform bool is_metal = false;
uniform float metalness : hint_range(0.0, 1.0) = 0.5;
uniform float roughness : hint_range(0.0, 1.0) = 0.0;

uniform float shade_threshold : hint_range(-1.0, 1.0, 0.001) = 0.0;
uniform float shade_softness : hint_range(0.0, 1.0, 0.001) = 0.1;
uniform bool parametric_shade = true;
uniform float shade_darkness : hint_range(0.0, 1.0, 0.05) = 0.5; //supposed to be a %
uniform vec4 shade_color : source_color = vec4(0.0, 0.0, 0.0, 0.0);

uniform bool is_specular = false;
uniform float specular_threshold : hint_range(0.0, 1.0, 0.001) = 0.5;
uniform float specular_softness : hint_range(0.0, 1.0, 0.001) = 0.1;
uniform bool parametric_specular = true;
uniform float specular_brightness : hint_range(0.0, 1.0, 0.05) = 0.5; //supposed to be a %
uniform vec3 specular_color : source_color = vec3(1.0, 1.0, 1.0);

uniform float edge_threshold : hint_range(0.0, 1.0, 0.001) = 0.5;
uniform float edge_softness : hint_range(0.0, 1.0, 0.001) = 0.05;
uniform vec4 edge_color : source_color = vec4(1.0, 1.0, 1.0, 0.4);

uniform bool is_emitting = false;
uniform vec4 emission_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float emission_energy : hint_range(0.0, 1.0, 0.05) = 1.0;

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float SchlickFresnel(float u) {
	float m = 1.0 - u;
	float m2 = m * m;
	return m2 * m2 * m;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 _main = texture(main_texture, UV) * main_color;
	float VdotN = dot(VIEW, NORMAL);
	float fresnel = clamp(SchlickFresnel(VdotN), 0.0, 1.0);
	
	if (is_glass) {
		// glass
		float a = mix(0.001, 1.0, fresnel);
		ALBEDO = mix(edge_color.rgb * edge_color.a, _main.rgb, a);
		ALPHA = mix(fresnel * edge_color.a, 1.0, a);
	} else {
		// normal toon
		float a = smoothstep(edge_threshold - edge_softness, edge_threshold + edge_softness, fresnel);
		ALBEDO = _main.rgb + edge_color.rgb * edge_color.a * a;
	}
	
	ROUGHNESS = roughness;
	
	if (is_emitting) {
		EMISSION = emission_color.rgb * emission_energy;
	}
	
	if (is_metal) {
		METALLIC = metalness;
	}
}

void light() {
	float NdotL = dot(NORMAL, LIGHT);
	vec3 base = ALBEDO.rgb;
	vec3 base_hsv = base;
	vec3 shade = shade_color.rgb;
	vec3 spec = specular_color;
	
	if (parametric_shade || parametric_specular) {
		base_hsv = rgb2hsv(base);
	}
	
	if (parametric_shade) {
		shade = hsv2rgb(vec3(base_hsv.x, base_hsv.y, base_hsv.z * (1.0 - shade_darkness)));
	}
	
	if (parametric_specular) {
		spec = hsv2rgb(vec3(base_hsv.x, base_hsv.y, base_hsv.z + (1.0 - base_hsv.z) * specular_brightness));
	}
	
	// Shadows
	float shade_value = smoothstep(shade_threshold - shade_softness, shade_threshold + shade_softness, NdotL);
	shade_value *= ATTENUATION;
	vec3 diffuse = mix(shade, base, shade_value * LIGHT_COLOR);
	DIFFUSE_LIGHT += diffuse * LIGHT_COLOR / PI;
	
	// Specular
	if (is_specular) {
		//float specular_value = smoothstep(specular_threshold - specular_softness, specular_threshold + specular_softness, NdotL);
		//specular_value *= ATTENUATION;
		float gloss = pow(2.0, 8.0 * (1.0 - specular_threshold));
		float intensity = pow(dot(NORMAL, normalize(VIEW + LIGHT)), gloss * gloss);
		SPECULAR_LIGHT += LIGHT_COLOR * spec * ATTENUATION * smoothstep(0.05, 0.05 + specular_softness, intensity);
	}
}