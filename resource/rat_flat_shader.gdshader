shader_type spatial;
render_mode unshaded, world_vertex_coords; //vertex_lighting;

const float colorSteps = 64.0;
const float min_light = 0.05;//0.017;
const vec3 global_light_direction = vec3(1.0, 1.0, -1.0);

void vertex() {
    // Transform the vertex position from model space to clip space
    vec4 vertex_pos = (INV_PROJECTION_MATRIX * vec4(VERTEX,1.0));
    // Calculate the interpolated vertex color based on the vertex's normal
    vec3 light_direction = normalize(global_light_direction); // Adjust the light direction as needed
    float light_intensity = max(min_light, dot(NORMAL, light_direction));
    vec4 interpolated_color = mix(COLOR * light_intensity, COLOR, light_intensity);
    // Assign the interpolated color to the fragment shader
    COLOR = interpolated_color;
}

void fragment() {
	vec3 col = floor(COLOR.rgb * colorSteps) / colorSteps;
	ALBEDO = col;
}

//void light() {
//	//lambert
//	DIFFUSE_LIGHT += clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * ALBEDO;
//}
//
//void fragment() {
//	ALBEDO = COLOR.rgb;
//}

