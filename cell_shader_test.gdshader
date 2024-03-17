//rgb to hsv from https://godotshaders.com/shader/hsv-adjustment/

shader_type spatial;
render_mode cull_disabled, depth_prepass_alpha, blend_add;

group_uniforms albedo;
uniform sampler2D main_texture : source_color, hint_default_white;
uniform vec4 main_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

group_uniforms normal;
uniform float normal_strength : hint_range(-16.0, 16.0) = 1.0;
uniform sampler2D normal_map : hint_normal;

group_uniforms metal;
uniform bool is_metal = false;
uniform float metalness : hint_range(0.0, 1.0) = 0.5;

group_uniforms roughness;
uniform float roughness : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D roughness_texture : hint_roughness_normal;

group_uniforms shading;
uniform float shade_threshold : hint_range(-1.0, 1.0, 0.001) = 0.0;
uniform float shade_softness : hint_range(0.0, 1.0, 0.001) = 0.1;
uniform bool parametric_shade = true;
uniform float shade_darkness : hint_range(0.0, 1.0, 0.05) = 0.5; //supposed to be a %

group_uniforms edging;
uniform float edge_threshold : hint_range(0.0, 1.0, 0.001) = 0.5;
uniform float edge_softness : hint_range(0.0, 1.0, 0.001) = 0.05;
uniform vec4 edge_color : source_color = vec4(1.0, 1.0, 1.0, 0.4);

group_uniforms specular;
uniform bool is_specular = false;
uniform float specular_threshold : hint_range(0.0, 1.0, 0.001) = 0.5;
uniform float specular_softness : hint_range(0.0, 1.0, 0.001) = 0.1;
uniform float specular_transparency : hint_range(0.0, 1.0) = 0.5;

group_uniforms emission;
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

float fresnel(float amount, vec3 normal, vec3 view) {
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

vec3 fresnel_glow(float amount, float intensity, vec3 color, vec3 normal, vec3 view) {
	return pow((1.0 - dot(normalize(normal), normalize(view))), amount) * color * intensity;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 _main = main_color * texture(main_texture, UV);
	//vec3 fresnel = fresnel_glow(0.5, 0.5, edge_color.rgb, NORMAL, VIEW);
	
	float fresnel = fresnel(1.0, NORMAL, VIEW);
	float alpha = smoothstep(edge_threshold - edge_softness, edge_threshold + edge_softness, fresnel);
	ALBEDO = _main.rgb + (edge_color.rgb * alpha * edge_color.a);
	ALPHA = _main.a;
	
	ROUGHNESS = roughness * texture(roughness_texture, UV).r;
	
	if (is_emitting) {
		EMISSION = emission_color.rgb * _main.rgb * emission_energy;
	}
	
	if (is_metal) {
		METALLIC = metalness;
	}
	
	NORMAL_MAP = texture(normal_map, UV).xyz;
	NORMAL_MAP_DEPTH = normal_strength;
}

void light() {
	float NdotL = dot(NORMAL, LIGHT);
	vec3 base = ALBEDO.rgb;
	
	// Shadows
	float shade_value = smoothstep(shade_threshold - shade_softness, shade_threshold + shade_softness, NdotL);
	
	if (parametric_shade){
		vec3 base_hsv = rgb2hsv(base);
		vec3 shade = hsv2rgb(vec3(base_hsv.x, base_hsv.y, base_hsv.z * (1.0 - shade_darkness)));
		vec3 diffuse = mix(shade, base, shade_value);
		DIFFUSE_LIGHT += diffuse * ATTENUATION * (LIGHT_COLOR / PI);
	} else {
		DIFFUSE_LIGHT += shade_value * ATTENUATION * (LIGHT_COLOR / PI);
	}
	
	// Specular
	if (is_specular) {
		float gloss = pow(2.0, 8.0 * (1.0 - specular_threshold));
		float intensity = pow(dot(NORMAL, normalize(VIEW + LIGHT)), gloss * gloss);
		float specular = smoothstep(0.05, 0.05 + specular_softness, intensity);
		SPECULAR_LIGHT += specular * ATTENUATION * (LIGHT_COLOR / PI) * specular_transparency;
	}
}