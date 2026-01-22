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
SamplerState normal0_sampler_s : register(s12);
SamplerState normal1_sampler_s : register(s13);
TextureCube<float4> s_sky : register(t0);
Texture2D<float4> g_black_and_white_points_sampler : register(t1);
Texture2D<float4> g_scurve_texture_sampler : register(t2);
Texture2D<float4> normal0_sampler : register(t3);
Texture2D<float4> normal1_sampler : register(t4);
Texture2D<float4> s_normal_map : register(t5);
Texture2D<float4> sampler0 : register(t6);
Texture2D<float4> sampler1 : register(t7);
Texture2D<float4> sampler2 : register(t8);
Texture2D<float4> sampler3 : register(t9);
Texture2D<float4> sampler4 : register(t10);
Texture2D<float4> sampler5 : register(t11);
Texture2D<float4> sampler6 : register(t12);
Texture2D<float4> sampler7 : register(t13);


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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = wind_offset + time_in_sec;
  r1.xyzw = float4(1.5,0.200000003,0.670000017,0.800000012) * r0.xxxx;
  r0.xyz = float3(2.5,0.300000012,0.870000005) * r0.xxx;
  r0.xyz = sin(r0.xyz);
  r2.xyz = sin(r1.xyz);
  r0.w = r2.x * r2.y;
  r0.w = r0.w * r2.z;
  r0.w = r0.w * 0.5 + 1;
  r0.w = r0.w * 0.800000012 + r1.w;
  r1.xz = r0.ww * float2(0.200000003,0.200000003) + v5.xy;
  r2.xyzw = normal0_sampler.Sample(normal0_sampler_s, r1.xz).xyzw;
  r1.xz = float2(0.00196078443,0.00196078443) + r2.wy;
  r2.xy = r1.xz * float2(2,2) + float2(-1,-1);
  r0.w = dot(r2.xy, r2.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r2.z = sqrt(r0.w);
  r0.x = r0.x * r0.y;
  r0.x = r0.x * r0.z;
  r0.x = r0.x * 0.5 + 1;
  r0.y = 0.400000006 * r0.x;
  r0.x = r0.x * 0.5 + r1.y;
  r0.xz = r0.xx * float2(0.5,0.200000003) + v5.xy;
  r1.xyzw = normal1_sampler.Sample(normal1_sampler_s, r0.xz).xyzw;
  r0.xz = float2(0.00196078443,0.00196078443) + r1.wy;
  r0.xz = r0.xz * float2(2,2) + float2(-1,-1);
  r1.xy = r0.xz * r0.yy;
  r0.x = dot(r0.xz, r0.xz);
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r1.z = sqrt(r0.x);
  r0.xyz = r2.xyz + r1.xyz;
  r0.w = dot(r0.xyz, r0.xyz);
  r0.w = rsqrt(r0.w);
  r0.xyz = r0.xyz * r0.www;
  r1.xyzw = r0.xyxy * float4(0.5,0.5,0.5,0.5) + float4(0.5,0.5,0.5,0.5);
  r0.xyz = r0.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,-0.5);
  r0.xyz = v6.xxx * r0.xyz + float3(0,0,1);
  r1.xyzw = r1.xyzw * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r1.xyzw = v6.xxxx * r1.xyzw;
  r1.xyzw = v6.yyyy * r1.xyzw;
  r2.xyzw = r1.zwzw * float4(0.0199999996,0.0199999996,0.0199999996,0.0199999996) + v7.xyzw;
  r3.xyzw = cmp(r2.xyzw < float4(0,0,0,0));
  r4.xyzw = cmp(float4(1,1,1,1) < r2.xyzw);
  r3.xz = (int2)r3.xz | (int2)r4.xz;
  r3.xy = (int2)r3.yw | (int2)r3.xz;
  r3.xy = (int2)r4.yw | (int2)r3.xy;
  r2.xy = g_texture0_offset_scale.zw * r2.xy + g_texture0_offset_scale.xy;
  r2.zw = g_texture1_offset_scale.zw * r2.zw + g_texture1_offset_scale.xy;
  r4.xyzw = sampler1.Sample(sampler1_s, r2.zw).xyzw;
  r4.xyzw = (bool4)r3.yyyy ? float4(1,1,1,0) : r4.xyzw;
  r2.xyzw = sampler0.Sample(sampler0_s, r2.xy).xyzw;
  r2.xyzw = (bool4)r3.xxxx ? float4(1,1,1,0) : r2.xyzw;
  r0.w = 1 + -global_alpha0;
  r0.w = max(r0.w, r2.w);
  r3.xyzw = float4(1,1,1,1) + -global_alpha1;
  r3.x = max(r3.x, r4.w);
  r0.w = r3.x * r0.w;
  r5.xyzw = r1.zwzw * float4(0.0199999996,0.0199999996,0.0199999996,0.0199999996) + v8.xyzw;
  r6.xyzw = cmp(r5.xyzw < float4(0,0,0,0));
  r7.xyzw = cmp(float4(1,1,1,1) < r5.xyzw);
  r6.xz = (int2)r6.xz | (int2)r7.xz;
  r6.xy = (int2)r6.yw | (int2)r6.xz;
  r6.xy = (int2)r7.yw | (int2)r6.xy;
  r5.xy = g_texture2_offset_scale.zw * r5.xy + g_texture2_offset_scale.xy;
  r5.zw = g_texture3_offset_scale.zw * r5.zw + g_texture3_offset_scale.xy;
  r7.xyzw = sampler3.Sample(sampler3_s, r5.zw).xyzw;
  r7.xyzw = (bool4)r6.yyyy ? float4(1,1,1,0) : r7.xyzw;
  r5.xyzw = sampler2.Sample(sampler2_s, r5.xy).xyzw;
  r5.xyzw = (bool4)r6.xxxx ? float4(1,1,1,0) : r5.xyzw;
  r3.x = max(r5.w, r3.y);
  r0.w = r3.x * r0.w;
  r3.x = max(r7.w, r3.z);
  r0.w = r3.x * r0.w;
  r6.xyzw = r1.zwzw * float4(0.0199999996,0.0199999996,0.0199999996,0.0199999996) + v9.xyzw;
  r8.xyzw = cmp(r6.xyzw < float4(0,0,0,0));
  r9.xyzw = cmp(float4(1,1,1,1) < r6.xyzw);
  r3.xy = (int2)r8.xz | (int2)r9.xz;
  r3.xy = (int2)r8.yw | (int2)r3.xy;
  r3.xy = (int2)r9.yw | (int2)r3.xy;
  r6.xy = g_texture4_offset_scale.zw * r6.xy + g_texture4_offset_scale.xy;
  r6.zw = g_texture5_offset_scale.zw * r6.zw + g_texture5_offset_scale.xy;
  r8.xyzw = sampler5.Sample(sampler5_s, r6.zw).xyzw;
  r8.xyzw = (bool4)r3.yyyy ? float4(1,1,1,0) : r8.xyzw;
  r6.xyzw = sampler4.Sample(sampler4_s, r6.xy).xyzw;
  r6.xyzw = (bool4)r3.xxxx ? float4(1,1,1,0) : r6.xyzw;
  r3.x = max(r6.w, r3.w);
  r0.w = r3.x * r0.w;
  r3.xyz = float3(1,1,1) + -global_alpha5;
  r3.x = max(r3.x, r8.w);
  r0.w = r3.x * r0.w;
  r9.xyzw = r1.xyzw * float4(0.0199999996,0.0199999996,0.0199999996,0.0199999996) + v10.xyzw;
  r1.xy = r1.zw * float2(0.0199999996,0.0199999996) + v5.xy;
  r1.xyzw = s_normal_map.Sample(s_normal_map_s, r1.xy).xyzw;
  r1.xy = float2(0.00196078443,0.00196078443) + r1.wy;
  r1.xy = r1.xy * float2(2,2) + float2(-1,-1);
  r10.xyzw = cmp(r9.xyzw < float4(0,0,0,0));
  r11.xyzw = cmp(float4(1,1,1,1) < r9.xyzw);
  r3.xw = (int2)r10.xz | (int2)r11.xz;
  r3.xw = (int2)r10.yw | (int2)r3.xw;
  r3.xw = (int2)r11.yw | (int2)r3.xw;
  r9.xy = g_texture6_offset_scale.zw * r9.xy + g_texture6_offset_scale.xy;
  r9.zw = g_texture7_offset_scale.zw * r9.zw + g_texture7_offset_scale.xy;
  r10.xyzw = sampler7.Sample(sampler7_s, r9.zw).xyzw;
  r10.xyzw = (bool4)r3.wwww ? float4(1,1,1,0) : r10.xyzw;
  r9.xyzw = sampler6.Sample(sampler6_s, r9.xy).xyzw;
  r9.xyzw = (bool4)r3.xxxx ? float4(1,1,1,0) : r9.xyzw;
  r1.w = max(r9.w, r3.y);
  r3.x = max(r10.w, r3.z);
  r0.w = r1.w * r0.w;
  r0.w = r0.w * r3.x + -0.5;
  r0.w = cmp(r0.w < 0);
  if (r0.w != 0) discard;
  r2.xyz = colour0.xyz * r2.xyz;
  o0.w = v3.w * r2.w;
  r3.xyz = colour1.xyz * r4.xyz;
  r0.w = max(global_alpha1, r4.w);
  r1.w = 1 + -texture01_blend_height.w;
  r4.xyzw = cmp(height1_vertical == float4(0,0,0,0));
  r4.xyzw = (bool4)r4.xyzw ? v5.xxxx : v5.yyyy;
  r1.w = cmp(r4.x >= r1.w);
  r1.w = (bool)r1.w ? 1.000000 : 0;
  r1.w = texture01_blend_height.z * r1.w;
  r2.w = r1.w * r0.w;
  r0.w = -r1.w * r0.w + 1;
  r3.xyz = r3.xyz * r2.www;
  r2.xyz = r2.xyz * r0.www + r3.xyz;
  r3.xyz = colour2.xyz * r5.xyz;
  r0.w = max(global_alpha2, r5.w);
  r5.xy = float2(1,1) + float2(-texture23_blend_height.y, -texture23_blend_height.w);
  r4.xy = cmp(r4.yz >= r5.xy);
  r4.xy = (bool2)r4.xy ? float2(1,1) : 0;
  r4.xy = float2(texture23_blend_height.x, texture23_blend_height.z) * r4.xy;
  r1.w = r4.x * r0.w;
  r0.w = -r4.x * r0.w + 1;
  r3.xyz = r3.xyz * r1.www;
  r2.xyz = r2.xyz * r0.www + r3.xyz;
  r3.xyz = colour3.xyz * r7.xyz;
  r0.w = max(global_alpha3, r7.w);
  r1.w = r4.y * r0.w;
  r0.w = -r4.y * r0.w + 1;
  r3.xyz = r3.xyz * r1.www;
  r2.xyz = r2.xyz * r0.www + r3.xyz;
  r3.xyz = colour4.xyz * r6.xyz;
  r0.w = max(global_alpha4, r6.w);
  r4.xy = float2(1,1) + float2(-texture45_blend_height.y, -texture45_blend_height.w);
  r1.w = cmp(r4.w >= r4.x);
  r1.w = (bool)r1.w ? 1.000000 : 0;
  r1.w = texture45_blend_height.x * r1.w;
  r2.w = r1.w * r0.w;
  r0.w = -r1.w * r0.w + 1;
  r3.xyz = r3.xyz * r2.www;
  r2.xyz = r2.xyz * r0.www + r3.xyz;
  r3.xyz = colour5.xyz * r8.xyz;
  r0.w = max(global_alpha5, r8.w);
  r4.xzw = cmp(height5_vertical == float3(0,0,0));
  r4.xzw = (bool3)r4.xzw ? v5.xxx : v5.yyy;
  r1.w = cmp(r4.x >= r4.y);
  r1.w = (bool)r1.w ? 1.000000 : 0;
  r1.w = texture45_blend_height.z * r1.w;
  r2.w = r1.w * r0.w;
  r0.w = -r1.w * r0.w + 1;
  r3.xyz = r3.xyz * r2.www;
  r2.xyz = r2.xyz * r0.www + r3.xyz;
  r3.xyz = colour6.xyz * r9.xyz;
  r0.w = max(global_alpha6, r9.w);
  r4.xy = float2(1,1) + float2(-texture67_blend_height.y, -texture67_blend_height.w);
  r4.xy = cmp(r4.zw >= r4.xy);
  r4.xy = (bool2)r4.xy ? float2(1,1) : 0;
  r4.xy = float2(texture67_blend_height.x, texture67_blend_height.z) * r4.xy;
  r1.w = r4.x * r0.w;
  r0.w = -r4.x * r0.w + 1;
  r3.xyz = r3.xyz * r1.www;
  r2.xyz = r2.xyz * r0.www + r3.xyz;
  r3.xyz = colour7.xyz * r10.xyz;
  r0.w = max(global_alpha7, r10.w);
  r1.w = r4.y * r0.w;
  r0.w = -r4.y * r0.w + 1;
  r3.xyz = r3.xyz * r1.www;
  r2.xyz = r2.xyz * r0.www + r3.xyz;
  r3.xyz = r2.xyz * float3(5,5,5) + float3(0.200000003,0.200000003,0.200000003);
  r3.xyz = r3.xyz + -r2.xyz;
  r2.xyz = saturate(v6.zzz * r3.xyz + r2.xyz);
  r0.w = dot(r2.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r3.xyz = r0.www + -r2.xyz;
  r2.xyz = v6.www * r3.xyz + r2.xyz;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r1.z = sqrt(r0.w);
  r0.xyz = r1.xyz + r0.xyz;
  r0.w = dot(r0.xyz, r0.xyz);
  r0.w = rsqrt(r0.w);
  r0.xyz = r0.xyz * r0.www;
  r0.w = dot(v4.xyz, v4.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = v4.xyz * r0.www;
  r1.xyz = r1.xyz * r0.yyy;
  r0.y = dot(v3.xyz, v3.xyz);
  r0.y = rsqrt(r0.y);
  r3.xyz = v3.xyz * r0.yyy;
  r0.xyw = r0.xxx * r3.xyz + r1.xyz;
  r1.x = dot(v2.xyz, v2.xyz);
  r1.x = rsqrt(r1.x);
  r1.xyz = v2.xyz * r1.xxx;
  r0.xyz = r0.zzz * r1.xyz + r0.xyw;
  r0.w = saturate(dot(r0.xyz, -fake_ui_light_direction.xyz));
  r0.w = 0.200000003 + r0.w;
  r1.xyz = camera_position.xyz + -v1.xyz;
  r1.w = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(r1.w);
  r1.xyz = r1.xyz * r1.www + -fake_ui_light_direction.xyz;
  r1.w = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(r1.w);
  r1.xyz = r1.xyz * r1.www;
  r0.x = dot(r0.xyz, r1.xyz);
  r0.y = abs(r0.x) * abs(r0.x);
  r0.y = r0.y * r0.y;
  r0.x = abs(r0.x) * r0.y;
  r0.y = 0.0500000007 * r0.x;
  r0.z = dot(r0.yyy, float3(0.212599993,0.715200007,0.0722000003));
  r0.x = -r0.x * 0.0500000007 + r0.z;
  r0.x = v6.w * r0.x + r0.y;
  r0.xyz = r2.xyz * r0.www + r0.xxx;
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