// ---- Created with 3Dmigoto v1.4.1 on Mon Jan 12 05:27:10 2026

#include "./shared.h"

static const float HDR_INV_GAMMA = 1.0 / 2.2;

cbuffer colorimetry_VS_PS : register(b0)
{
  float g_brightness : packoffset(c0);
  float g_gamma_output : packoffset(c0.y);
  float g_inv_gamma_output : packoffset(c0.z);
}

cbuffer camera_VS_PS : register(b1)
{
  float3 camera_position : packoffset(c0);
  float4x4 view : packoffset(c1);
  float4x4 projection : packoffset(c5);
  float4x4 view_projection : packoffset(c9);
  float4x4 inv_view : packoffset(c13);
  float4x4 inv_projection : packoffset(c17);
  float4x4 inv_view_projection : packoffset(c21);
  float4 camera_near_far : packoffset(c25);
  float time_in_sec : packoffset(c26);
  float2 g_inverse_focal_length : packoffset(c26.y);
  float g_vertical_fov : packoffset(c26.w);
  float4 g_screen_size : packoffset(c27);
  float g_vpos_texel_offset : packoffset(c28);
  float4 g_viewport_dimensions : packoffset(c29);
  float4 g_camera_temp0 : packoffset(c30);
  float4 g_camera_temp1 : packoffset(c31);
  float4 g_camera_temp2 : packoffset(c32);
  float4 g_clip_rect : packoffset(c33);
  float g_hide_foliage : packoffset(c34);
}

cbuffer lighting_VS_PS : register(b2)
{
  float3 sun_direction : packoffset(c0);
  float3 sun_colour : packoffset(c1);
  float3 ambient_cube_lr[2] : packoffset(c2);
  float3 ambient_cube_tb[2] : packoffset(c4);
  float3 ambient_cube_fb[2] : packoffset(c6);
  float3 g_deep_water_colour : packoffset(c8);
  float3 g_shallow_water_colour : packoffset(c9);
  float3 g_sea_bed_light_scatter : packoffset(c10);
  float g_refraction_light_scatter : packoffset(c10.w);
  float g_hdr_on : packoffset(c11);
}

cbuffer fog_VS_PS : register(b3)
{
  float3 g_volume_fog_colour : packoffset(c0);
  float g_fog_distance_start : packoffset(c0.w);
  float g_fog_distance_strength : packoffset(c1);
  float g_fog_distance_scale : packoffset(c1.y);
  float g_fog_height_bottom : packoffset(c1.z);
  float g_fog_height_top : packoffset(c1.w);
  float g_fog_height_strength : packoffset(c2);
  float g_fog_colour_blend : packoffset(c2.y);
  float g_fog_clear_distance : packoffset(c2.z);
}

cbuffer texture_scale : register(b4)
{
  float4 g_texture0_offset_scale : packoffset(c0);
  float4 g_texture1_offset_scale : packoffset(c1);
  float4 g_texture2_offset_scale : packoffset(c2);
  float4 g_texture3_offset_scale : packoffset(c3);
  float4 g_texture4_offset_scale : packoffset(c4);
  float4 g_texture5_offset_scale : packoffset(c5);
  float4 g_texture6_offset_scale : packoffset(c6);
  float4 g_texture7_offset_scale : packoffset(c7);
  float wind_offset : packoffset(c8);
}

cbuffer texture_blend_PS : register(b5)
{
  float4 texture01_blend_height : packoffset(c0);  // xy = texture0, zw = texture1
  float4 texture23_blend_height : packoffset(c1);  // xy = texture2, zw = texture3
  float4 texture45_blend_height : packoffset(c2);  // xy = texture4, zw = texture5
  float4 texture67_blend_height : packoffset(c3);  // xy = texture6, zw = texture7
  float3 colour0 : packoffset(c4);
  float3 colour1 : packoffset(c5);
  float3 colour2 : packoffset(c6);
  float3 colour3 : packoffset(c7);
  float3 colour4 : packoffset(c8);
  float3 colour5 : packoffset(c9);
  float3 colour6 : packoffset(c10);
  float3 colour7 : packoffset(c11);
  float global_alpha0 : packoffset(c11.w);
  float global_alpha1 : packoffset(c12);
  float global_alpha2 : packoffset(c12.y);
  float global_alpha3 : packoffset(c12.z);
  float global_alpha4 : packoffset(c12.w);
  float global_alpha5 : packoffset(c13);
  float global_alpha6 : packoffset(c13.y);
  float global_alpha7 : packoffset(c13.z);
  float height0_vertical : packoffset(c13.w);
  float height1_vertical : packoffset(c14);
  float height2_vertical : packoffset(c14.y);
  float height3_vertical : packoffset(c14.z);
  float height4_vertical : packoffset(c14.w);
  float height5_vertical : packoffset(c15);
  float height6_vertical : packoffset(c15.y);
  float height7_vertical : packoffset(c15.z);
  float normal_and_gloss : packoffset(c15.w);
  float3 fake_ui_light_direction : packoffset(c16);
  float4 g_texture0_output_offset_scale : packoffset(c17);
  float4 g_texture1_output_offset_scale : packoffset(c18);
  float4 g_texture2_output_offset_scale : packoffset(c19);
  float4 g_texture3_output_offset_scale : packoffset(c20);
  float4 g_texture4_output_offset_scale : packoffset(c21);
  float4 g_texture5_output_offset_scale : packoffset(c22);
  float4 g_texture6_output_offset_scale : packoffset(c23);
  float4 g_texture7_output_offset_scale : packoffset(c24);
}

SamplerState s_sky_s : register(s0);
SamplerState s_normal_map_s : register(s1);
SamplerState g_black_and_white_points_sampler_s : register(s2);
SamplerState g_scurve_texture_sampler_s : register(s3);
SamplerState sampler0_s : register(s4);
SamplerState sampler1_s : register(s5);
SamplerState sampler2_s : register(s6);
SamplerState sampler3_s : register(s7);
SamplerState sampler4_s : register(s8);
SamplerState sampler5_s : register(s9);
SamplerState sampler6_s : register(s10);
SamplerState sampler7_s : register(s11);
TextureCube<float4> s_sky : register(t0);
Texture2D<float4> g_black_and_white_points_sampler : register(t1);
Texture2D<float4> g_scurve_texture_sampler : register(t2);
Texture2D<float4> s_normal_map : register(t3);
Texture2D<float4> sampler0 : register(t4);
Texture2D<float4> sampler1 : register(t5);
Texture2D<float4> sampler2 : register(t6);
Texture2D<float4> sampler3 : register(t7);
Texture2D<float4> sampler4 : register(t8);
Texture2D<float4> sampler5 : register(t9);
Texture2D<float4> sampler6 : register(t10);
Texture2D<float4> sampler7 : register(t11);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  float4 v6 : TEXCOORD5,
  float4 v7 : COLOR0,
  float4 v8 : COLOR1,
  float4 v9 : COLOR2,
  float4 v10 : COLOR3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cmp(v7.xyzw < float4(0,0,0,0));
  r1.xyzw = cmp(float4(1,1,1,1) < v7.xyzw);
  r0.xz = (int2)r0.xz | (int2)r1.xz;
  r0.xy = (int2)r0.yw | (int2)r0.xz;
  r0.xy = (int2)r1.yw | (int2)r0.xy;
  r0.zw = g_texture0_offset_scale.zw * v7.xy + g_texture0_offset_scale.xy;
  r1.xyzw = sampler0.Sample(sampler0_s, r0.zw).xyzw;
  r1.xyzw = (bool4)r0.xxxx ? float4(1,1,1,0) : r1.xyzw;
  r0.x = 1 + -global_alpha0;
  r0.x = max(r0.x, r1.w);
  r0.zw = g_texture1_offset_scale.zw * v7.zw + g_texture1_offset_scale.xy;
  r2.xyzw = sampler1.Sample(sampler1_s, r0.zw).xyzw;
  r2.xyzw = (bool4)r0.yyyy ? float4(1,1,1,0) : r2.xyzw;
  r3.xyzw = float4(1,1,1,1) + -global_alpha1;
  r0.y = max(r3.x, r2.w);
  r0.x = r0.x * r0.y;
  r4.xyzw = cmp(v8.xyzw < float4(0,0,0,0));
  r5.xyzw = cmp(float4(1,1,1,1) < v8.xyzw);
  r0.yz = (int2)r4.xz | (int2)r5.xz;
  r0.yz = (int2)r4.yw | (int2)r0.yz;
  r0.yz = (int2)r5.yw | (int2)r0.yz;
  r4.xy = g_texture2_offset_scale.zw * v8.xy + g_texture2_offset_scale.xy;
  r4.xyzw = sampler2.Sample(sampler2_s, r4.xy).xyzw;
  r4.xyzw = (bool4)r0.yyyy ? float4(1,1,1,0) : r4.xyzw;
  r0.y = max(r4.w, r3.y);
  r0.x = r0.x * r0.y;
  r0.yw = g_texture3_offset_scale.zw * v8.zw + g_texture3_offset_scale.xy;
  r5.xyzw = sampler3.Sample(sampler3_s, r0.yw).xyzw;
  r5.xyzw = (bool4)r0.zzzz ? float4(1,1,1,0) : r5.xyzw;
  r0.y = max(r5.w, r3.z);
  r0.x = r0.x * r0.y;
  r6.xyzw = cmp(v9.xyzw < float4(0,0,0,0));
  r7.xyzw = cmp(float4(1,1,1,1) < v9.xyzw);
  r0.yz = (int2)r6.xz | (int2)r7.xz;
  r0.yz = (int2)r6.yw | (int2)r0.yz;
  r0.yz = (int2)r7.yw | (int2)r0.yz;
  r3.xy = g_texture4_offset_scale.zw * v9.xy + g_texture4_offset_scale.xy;
  r6.xyzw = sampler4.Sample(sampler4_s, r3.xy).xyzw;
  r6.xyzw = (bool4)r0.yyyy ? float4(1,1,1,0) : r6.xyzw;
  r0.y = max(r6.w, r3.w);
  r0.x = r0.x * r0.y;
  r0.yw = g_texture5_offset_scale.zw * v9.zw + g_texture5_offset_scale.xy;
  r3.xyzw = sampler5.Sample(sampler5_s, r0.yw).xyzw;
  r3.xyzw = (bool4)r0.zzzz ? float4(1,1,1,0) : r3.xyzw;
  r0.yzw = float3(1,1,1) + -global_alpha5;
  r0.y = max(r0.y, r3.w);
  r0.x = r0.x * r0.y;
  r7.xyzw = cmp(v10.xyzw < float4(0,0,0,0));
  r8.xyzw = cmp(float4(1,1,1,1) < v10.xyzw);
  r7.xz = (int2)r7.xz | (int2)r8.xz;
  r7.xy = (int2)r7.yw | (int2)r7.xz;
  r7.xy = (int2)r8.yw | (int2)r7.xy;
  r7.zw = g_texture6_offset_scale.zw * v10.xy + g_texture6_offset_scale.xy;
  r8.xyzw = sampler6.Sample(sampler6_s, r7.zw).xyzw;
  r8.xyzw = (bool4)r7.xxxx ? float4(1,1,1,0) : r8.xyzw;
  r0.y = max(r8.w, r0.z);
  r0.x = r0.x * r0.y;
  r0.yz = g_texture7_offset_scale.zw * v10.zw + g_texture7_offset_scale.xy;
  r9.xyzw = sampler7.Sample(sampler7_s, r0.yz).xyzw;
  r7.xyzw = (bool4)r7.yyyy ? float4(1,1,1,0) : r9.xyzw;
  r0.y = max(r7.w, r0.w);
  r0.x = r0.x * r0.y + -0.5;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.xyz = colour0.xyz * r1.xyz;
  o0.w = v3.w * r1.w;
  r1.xyz = colour1.xyz * r2.xyz;
  r0.w = max(global_alpha1, r2.w);
  r1.w = 1 + -texture01_blend_height.w;
  r2.xyzw = cmp(height1_vertical == float4(0,0,0,0));
  r2.xyzw = (bool4)r2.xyzw ? v5.xxxx : v5.yyyy;
  r1.w = cmp(r2.x >= r1.w);
  r1.w = (bool)r1.w ? 1.000000 : 0;
  r1.w = texture01_blend_height.z * r1.w;
  r2.x = r1.w * r0.w;
  r0.w = -r1.w * r0.w + 1;
  r1.xyz = r2.xxx * r1.xyz;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  r1.xyz = colour2.xyz * r4.xyz;
  r0.w = max(global_alpha2, r4.w);
  r4.xy = float2(1,1) + float2(-texture23_blend_height.y, -texture23_blend_height.w);
  r2.xy = cmp(r2.yz >= r4.xy);
  r2.xy = (bool2)r2.xy ? float2(1,1) : 0;
  r2.xy = float2(texture23_blend_height.x, texture23_blend_height.z) * r2.xy;
  r1.w = r2.x * r0.w;
  r0.w = -r2.x * r0.w + 1;
  r1.xyz = r1.xyz * r1.www;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  r1.xyz = colour3.xyz * r5.xyz;
  r0.w = max(global_alpha3, r5.w);
  r1.w = r2.y * r0.w;
  r0.w = -r2.y * r0.w + 1;
  r1.xyz = r1.xyz * r1.www;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  r1.xyz = colour4.xyz * r6.xyz;
  r0.w = max(global_alpha4, r6.w);
  r2.xy = float2(1,1) + float2(-texture45_blend_height.y, -texture45_blend_height.w);
  r1.w = cmp(r2.w >= r2.x);
  r1.w = (bool)r1.w ? 1.000000 : 0;
  r1.w = texture45_blend_height.x * r1.w;
  r2.x = r1.w * r0.w;
  r0.w = -r1.w * r0.w + 1;
  r1.xyz = r2.xxx * r1.xyz;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  r1.xyz = colour5.xyz * r3.xyz;
  r0.w = max(global_alpha5, r3.w);
  r2.xzw = cmp(height5_vertical == float3(0,0,0));
  r2.xzw = (bool3)r2.xzw ? v5.xxx : v5.yyy;
  r1.w = cmp(r2.x >= r2.y);
  r1.w = (bool)r1.w ? 1.000000 : 0;
  r1.w = texture45_blend_height.z * r1.w;
  r2.x = r1.w * r0.w;
  r0.w = -r1.w * r0.w + 1;
  r1.xyz = r2.xxx * r1.xyz;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  r1.xyz = colour6.xyz * r8.xyz;
  r0.w = max(global_alpha6, r8.w);
  r2.xy = float2(1,1) + float2(-texture67_blend_height.y, -texture67_blend_height.w);
  r2.xy = cmp(r2.zw >= r2.xy);
  r2.xy = (bool2)r2.xy ? float2(1,1) : 0;
  r2.xy = float2(texture67_blend_height.x, texture67_blend_height.z) * r2.xy;
  r1.w = r2.x * r0.w;
  r0.w = -r2.x * r0.w + 1;
  r1.xyz = r1.xyz * r1.www;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  r1.xyz = colour7.xyz * r7.xyz;
  r0.w = max(global_alpha7, r7.w);
  r1.w = r2.y * r0.w;
  r0.w = -r2.y * r0.w + 1;
  r1.xyz = r1.xyz * r1.www;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  r1.xyz = r0.xyz * float3(5,5,5) + float3(0.200000003,0.200000003,0.200000003);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = saturate(v6.zzz * r1.xyz + r0.xyz);
  r0.w = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r1.xyz = r0.www + -r0.xyz;
  r0.xyz = v6.www * r1.xyz + r0.xyz;
  r1.xyzw = s_normal_map.Sample(s_normal_map_s, v5.xy).xyzw;
  r1.xy = float2(0.00196078443,0.00196078443) + r1.wy;
  r1.zw = r1.xy * float2(2,2) + float2(-1,-1);
  r2.xy = r1.xy + r1.xy;
  r0.w = dot(r1.zw, r1.zw);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r2.z = sqrt(r0.w);
  r1.xyz = float3(-1,-1,1) + r2.xyz;
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = r1.xyz * r0.www;
  r0.w = dot(v4.xyz, v4.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = v4.xyz * r0.www;
  r2.xyz = r2.xyz * r1.yyy;
  r0.w = dot(v3.xyz, v3.xyz);
  r0.w = rsqrt(r0.w);
  r3.xyz = v3.xyz * r0.www;
  r1.xyw = r1.xxx * r3.xyz + r2.xyz;
  r0.w = dot(v2.xyz, v2.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = v2.xyz * r0.www;
  r1.xyz = r1.zzz * r2.xyz + r1.xyw;
  r2.xyz = camera_position.xyz + -v1.xyz;
  r0.w = dot(r2.xyz, r2.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = r2.xyz * r0.www + -fake_ui_light_direction.xyz;
  r0.w = dot(r2.xyz, r2.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = r2.xyz * r0.www;
  r0.w = dot(r1.xyz, r2.xyz);
  r1.x = saturate(dot(r1.xyz, -fake_ui_light_direction.xyz));
  r1.x = 0.200000003 + r1.x;
  r1.y = abs(r0.w) * abs(r0.w);
  r1.y = r1.y * r1.y;
  r0.w = r1.y * abs(r0.w);
  r1.y = 0.0500000007 * r0.w;
  r1.z = dot(r1.yyy, float3(0.212599993,0.715200007,0.0722000003));
  r0.w = -r0.w * 0.0500000007 + r1.z;
  r0.w = v6.w * r0.w + r1.y;
  r0.xyz = r0.xyz * r1.xxx + r0.www;
  r0.w = 1 + -g_fog_distance_start;
  r0.w = r0.w * 8 + -4;
  r1.x = 1 + -g_fog_distance_strength;
  r1.x = 1000 * r1.x;
  r2.xyz = -camera_position.xyz + v1.xyz;
  r1.y = dot(r2.xyz, r2.xyz);
  r1.y = sqrt(r1.y);
  r1.x = r1.y / r1.x;
  r0.w = r1.x + r0.w;
  r0.w = 1.44269502 * r0.w;
  r0.w = exp2(r0.w);
  r0.w = g_fog_distance_scale / r0.w;
  r0.w = saturate(g_fog_distance_scale + -r0.w);
  r1.x = saturate(dot(r0.ww, g_fog_colour_blend));
  r2.w = max(0, r2.y);
  r2.xyzw = s_sky.Sample(s_sky_s, r2.xwz).xyzw;
  r3.xyz = g_volume_fog_colour.xyz * sun_colour.xyz;
  r3.xyz = float3(1.5,1.5,1.5) * r3.xyz;
  r3.xyz = abs(sun_direction.yyy) * r3.xyz;
  r1.z = cmp(0 < g_hdr_on);
  r1.z = (bool)r1.z ? 0.00400000019 : 1;
  r2.xyz = -r3.xyz * r1.zzz + r2.xyz;
  r3.xyz = r3.xyz * r1.zzz;
  r1.xzw = r1.xxx * r2.xyz + r3.xyz;
  r1.xzw = max(float3(0.0109999999,0.0109999999,0.0109999999), r1.xzw);
  r2.x = dot(float3(0.412400007,0.357600003,0.180500001), r1.xzw);
  r2.y = dot(float3(0.0193000007,0.119199999,0.950500011), r1.xzw);
  r1.x = dot(float3(0.212599993,0.715200007,0.0722000003), r1.xzw);
  r1.z = r2.x + r1.x;
  r1.z = r1.z + r2.y;
  r1.w = r2.x / r1.z;
  r1.z = r1.x / r1.z;
  r1.x = log2(r1.x);
  r2.x = 1 + -r1.w;
  r2.x = r2.x + -r1.z;
  r1.z = max(0.00100000005, r1.z);
  r3.xyzw = g_black_and_white_points_sampler.SampleLevel(g_black_and_white_points_sampler_s, float2(0.5,0.5), 0).xyzw;
  r1.x = r1.x * 0.30103001 + -r3.x;
  r2.yz = r3.zw + -r3.xy;
  r4.x = r1.x / r2.y;
  r4.y = 0.5;
  r4.xyzw = g_scurve_texture_sampler.Sample(g_scurve_texture_sampler_s, r4.xy).xyzw;
  r1.x = r4.x * r2.y + r3.x;
  r1.x = 3.32192802 * r1.x;
  r1.x = exp2(r1.x);
  r1.x = r1.x + -r3.y;
  r3.y = r1.x / r2.z;
  r1.x = r3.y * r2.x;
  r3.z = r1.x / r1.z;
  r1.x = r3.y * r1.w;
  r3.x = r1.x / r1.z;
  r2.x = dot(float3(3.24049997,-1.53719997,-0.49849999), r3.xyz);
  r2.y = dot(float3(-0.969299972,1.87600005,0.0416000001), r3.xyz);
  r2.z = dot(float3(0.0555999987,-0.203999996,1.05719995), r3.xyz);
  r1.xzw = max(float3(0,0,0), r2.xyz);
  r1.xzw = r1.xzw + -r0.xyz;
  r2.x = max(0.00100000005, g_fog_clear_distance);
  r2.x = 1 / r2.x;
  r1.y = r2.x * r1.y;
  r1.y = min(1, r1.y);
  r2.x = r1.y * -2 + 3;
  r1.y = r1.y * r1.y;
  r1.y = r2.x * r1.y;
  r2.x = g_fog_height_top + -v1.y;
  r2.x = -g_fog_height_bottom + r2.x;
  r2.y = g_fog_height_top + -g_fog_height_bottom;
  r2.y = 1 / r2.y;
  r2.x = saturate(r2.x * r2.y);
  r2.y = r2.x * -2 + 3;
  r2.x = r2.x * r2.x;
  r2.x = r2.y * r2.x;
  r0.w = g_fog_height_strength * r2.x + r0.w;
  r0.w = saturate(r1.y * r0.w);
  // SDR clamp removed for HDR
  r0.xyz = (RENODX_TONE_MAP_TYPE != 0)
         ? max(0, r0.www * r1.xzw + r0.xyz)
         : saturate(r0.www * r1.xzw + r0.xyz);
  r0.xyz = log2(r0.xyz);
  // Use fixed gamma 2.2 in HDR mode, bypass user gamma slider
  float inv_gamma = (RENODX_TONE_MAP_TYPE != 0) ? HDR_INV_GAMMA : g_inv_gamma_output;
  r0.xyz = inv_gamma * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  return;
}