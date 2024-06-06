// based on https://godotshaders.com/shader/pixel-perfect-outline-shader/

shader_type spatial;
render_mode cull_front, unshaded;
//render_mode cull_front;

group_uniforms base;
uniform vec3 outline_color : source_color = vec3(1.0, 1.0, 1.0);
global uniform float outline_width;
uniform bool use_global = true;
uniform float outline_width_local = 1.0;
varying float width;

group_uniforms edging;
uniform bool is_edging = false;
uniform float edge_threshold : hint_range(0.0, 1.0, 0.001) = 0.85;
uniform float edge_softness : hint_range(0.0, 1.0, 0.001) = 0.35;
uniform vec4 edge_color : source_color = vec4(1.0, 1.0, 1.0, 0.4);
uniform bool parametric_edging = true;
uniform float edge_darkness : hint_range(0.0, 1.0, 0.05) = 0.0; //supposed to be a %
uniform float edge_saturation : hint_range(-1.0, 1.0, 0.05) = 0.65; //supposed to be a %
uniform float edge_hue_shift : hint_range(-0.5, 0.5, 0.01) = 0.35; //supposed to be a %

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

void vertex() {
	vec4 clip_position = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
	vec3 clip_normal = mat3(PROJECTION_MATRIX) * (mat3(MODELVIEW_MATRIX) * NORMAL);
	
	if (use_global) {
		width = outline_width;
	} else {
		width = outline_width_local;
	}
	vec2 offset = normalize(clip_normal.xy) / VIEWPORT_SIZE * clip_position.w * width * 2.0;
	
	clip_position.xy += offset;
	
	POSITION = clip_position;
}

//void fragment() {
	//ALBEDO = outline_color.rgb;
	////ALBEDO = COLOR.rgb;
	//if (outline_color.a < 1.0) {
		//ALPHA = outline_color.a;
	//}
//}

void fragment() {
	vec4 _main = vec4(outline_color.rgb, 1.0);
	vec3 gen_noise = vec3(0,0,0);
	
	if (is_edging) {
		float fresnel = fresnel(1.0, NORMAL, VIEW);
		float alpha = smoothstep(edge_threshold - edge_softness, edge_threshold + edge_softness, fresnel);
		vec3 edge = edge_color.rgb;
		if (parametric_edging) {
			vec3 edge_hsv = rgb2hsv(_main.rgb);
			edge = hsv2rgb(vec3(edge_hsv.x + edge_hue_shift, edge_hsv.y + edge_saturation, edge_hsv.z * (1.0 - edge_darkness)));
		}
		ALBEDO = mix(_main.rgb, edge.rgb, alpha * edge_color.a);
	} else {
		ALBEDO = _main.rgb;
	}
	
	//if (transparency < 1.0) {
		//ALPHA = transparency;
	//}
}