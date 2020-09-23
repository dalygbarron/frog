shader_type spatial;
render_mode blend_mix,cull_back,diffuse_burley;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float proximity_fade_distance;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;


void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
    VERTEX.y = sin(UV.x + TIME) * cos(UV.y + TIME);
}

vec3 waves(float time, vec2 uv) {
    float amount = sin(time + uv.x * 400.0 + sin(uv.y * 100.0) * 2.0) * 2.0 - 1.0;
    return vec3(amount, amount, amount);
}

void fragment() {
	vec2 base_uv = UV;
	//float depth_tex = textureLod(DEPTH_TEXTURE,SCREEN_UV,0.0).r;
	//vec4 world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV*2.0-1.0,depth_tex*2.0-1.0,1.0);
	//world_pos.xyz/=world_pos.w;
    vec3 wave = waves(TIME, UV);
    //ALPHA = clamp(1.0-smoothstep(world_pos.z+proximity_fade_distance,world_pos.z,VERTEX.z),0.0,1.0);
	ALBEDO = max(albedo.rgb, wave);
}
