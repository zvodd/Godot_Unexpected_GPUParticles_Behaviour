shader_type spatial;
render_mode unshaded;
uniform sampler2D texture_albedo : source_color;

void fragment() {
	// Get the world position of the fragment
	vec3 world_pos = (INV_VIEW_MATRIX * vec4(VERTEX,1.0)).xyz;

	// Normalize world_pos to have values between 0 and 1
	world_pos = (world_pos + vec3(1.0)) * 0.5;

	// Sample the texture based on each axis
	vec4 tex_color_x = texture(texture_albedo, vec2(world_pos.y, world_pos.z));
	vec4 tex_color_y = texture(texture_albedo, vec2(world_pos.x, world_pos.z));
	vec4 tex_color_z = texture(texture_albedo, vec2(world_pos.x, world_pos.y));

	// Calculate the final color as a combination of the three samples
	 vec4 final_color = mix(mix(tex_color_x, tex_color_y, 0.5 ),tex_color_z, 0.66666); 
//    vec4 final_color = (tex_color_x + tex_color_y + tex_color_z) / 3.0;

	// Output the final color
	ALBEDO = final_color.rgb;
	ALPHA = final_color.a;
}

