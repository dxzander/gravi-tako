// taken from https://godotshaders.com/shader/pixel-perfect-outline-shader/

shader_type spatial;
render_mode cull_front, unshaded;

uniform vec4 outline_color : source_color;
global uniform float outline_width;
uniform bool use_global = true;
uniform float outline_width_local = 1.0;
varying float width;

void vertex() {
	vec4 clip_position = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
	vec3 clip_normal = mat3(PROJECTION_MATRIX) * (mat3(MODELVIEW_MATRIX) * NORMAL);
	
	if (use_global) {
		width = outline_width;
	} else {
		width = outline_width * 2.0;
	}
	vec2 offset = normalize(clip_normal.xy) / VIEWPORT_SIZE * clip_position.w * width * 2.0;
	
	clip_position.xy += offset;
	
	POSITION = clip_position;
}

void fragment() {
	ALBEDO = outline_color.rgb;
	if (outline_color.a < 1.0) {
		ALPHA = outline_color.a;
	}
}