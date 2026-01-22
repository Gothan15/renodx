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

SamplerState s_sky_s : register(s0);
SamplerState s_environment_s : register(s1);
SamplerState s_diffuse_map_s : register(s2);
SamplerState s_specular_colour_map_s : register(s3);
SamplerState s_normal_map_s : register(s4);
SamplerState s_gloss_map_s : register(s5);
Texture2D<float4> s_diffuse_map : register(t0);
Texture2D<float4> s_specular_colour_map : register(t1);
Texture2D<float4> s_normal_map : register(t2);
Texture2D<float4> s_gloss_map : register(t3);
TextureCube<float4> s_environment : register(t4);
TextureCube<float4> s_sky : register(t5);


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
  float4 v7 : TEXCOORD6,
  nointerpolation float4 v8 : TEXCOORD7,
  float3 v9 : TEXCOORD8,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = s_diffuse_map.Sample(s_diffuse_map_s, v2.xy).xyzw;
  r0.w = -0.501960814 + r0.w;
  r0.w = cmp(r0.w < 0);
  if (r0.w != 0) discard;
  r1.xyz = v1.xyz;
  r1.w = 1;
  r2.x = dot(r1.xyzw, view_projection._m00_m10_m20_m30);
  r2.y = dot(r1.xyzw, view_projection._m01_m11_m21_m31);
  r0.w = dot(r1.xyzw, view_projection._m03_m13_m23_m33);
  r1.xy = r2.xy / r0.ww;
  r1.zw = cmp(r1.xy >= g_clip_rect.xy);
  r1.xy = cmp(g_clip_rect.zw >= r1.xy);
  r0.w = (bool)r1.x ? r1.z : 0;
  r0.w = (bool)r1.w ? r0.w : 0;
  r0.w = (bool)r1.y ? r0.w : 0;
  r0.w = ~(int)r0.w;
  if (r0.w != 0) discard;
  r1.xyzw = s_gloss_map.Sample(s_gloss_map_s, v2.xy).xyzw;
  r0.w = r1.x * r1.x;
  r0.w = r0.w * 0.979900002 + 0.0199999996;
  r0.w = r0.w * 0.5 + 0.5;
  r0.w = r0.w * 2 + -1;
  r1.z = -r0.w * r0.w + 1;
  r0.w = cmp(0 < r0.w);
  r0.w = (int)-r0.w;
  r1.z = max(0.00100000005, r1.z);
  r1.z = log2(r1.z);
  r1.w = 4.95061684 * r1.z;
  r1.z = r1.z * 0.346573591 + 4.54688501;
  r1.w = r1.z * r1.z + -r1.w;
  r1.w = sqrt(r1.w);
  r1.z = r1.w + -r1.z;
  r1.z = max(0, r1.z);
  r1.z = sqrt(r1.z);
  r0.w = r1.z * r0.w;
  r0.w = 1.41421354 * r0.w;
  r0.w = 0.0174532924 / r0.w;
  r0.w = max(9.99999975e-05, r0.w);
  r0.w = 1 / r0.w;
  r1.zw = float2(-0.0123413419,0.0123413419) * r0.ww;
  r1.zw = r1.zw * r1.zw;
  r2.xyzw = r1.zzww * float4(0.140012279,0.140012279,0.140012279,0.140012279) + float4(1.27323949,1,1.27323949,1);
  r2.xy = r2.xz / r2.yw;
  r1.zw = r2.xy * -r1.zw;
  r1.zw = float2(1.44269502,1.44269502) * r1.zw;
  r1.zw = exp2(r1.zw);
  r1.xzw = float3(1,1,1) + -r1.xzw;
  r1.zw = sqrt(r1.zw);
  r2.xy = cmp(float2(-0,0) < r0.ww);
  r2.x = (int)r2.x;
  r2.y = (int)-r2.y;
  r1.w = r2.y * r1.w + 1;
  r1.z = r2.x * r1.z + 1;
  r1.xz = float2(8,0.5) * r1.xz;
  r1.z = r1.w * 0.5 + -r1.z;
  r1.w = dot(v4.xyz, v4.xyz);
  r1.w = rsqrt(r1.w);
  r2.xyz = v4.xyz * r1.www;
  r1.w = dot(v6.xyz, v6.xyz);
  r1.w = rsqrt(r1.w);
  r3.xyz = v6.xyz * r1.www;
  r4.xyzw = s_normal_map.Sample(s_normal_map_s, v2.zw).xyzw;
  r4.xy = float2(0.00196078443,0.00196078443) + r4.wy;
  r4.xy = r4.xy * float2(2,2) + float2(-1,-1);
  r3.xyz = r4.yyy * r3.xyz;
  r2.xyz = r4.xxx * r2.xyz + r3.xyz;
  r1.w = dot(r4.xy, r4.xy);
  r1.w = 1 + -r1.w;
  r1.w = max(0, r1.w);
  r1.w = sqrt(r1.w);
  r2.w = dot(v3.xyz, v3.xyz);
  r2.w = rsqrt(r2.w);
  r3.xyz = v3.xyz * r2.www;
  r2.xyz = r1.www * r3.xyz + r2.xyz;
  r1.w = dot(r2.xyz, r2.xyz);
  r1.w = rsqrt(r1.w);
  r2.xyz = r2.xyz * r1.www;
  r3.xyz = -camera_position.xyz + v1.xyz;
  r1.w = dot(r3.xyz, r3.xyz);
  r2.w = rsqrt(r1.w);
  r1.w = sqrt(r1.w);
  r4.xyz = r3.xyz * r2.www;
  r2.w = dot(r4.xyz, r2.xyz);
  r2.w = r2.w + r2.w;
  r5.xyz = r2.xyz * -r2.www + r4.xyz;
  r2.w = dot(r5.xyz, r4.xyz);
  r4.x = dot(-sun_direction.xyz, r4.xyz);
  r4.x = max(9.99999975e-05, r4.x);
  r4.x = log2(r4.x);
  r4.x = 60 * r4.x;
  r4.x = exp2(r4.x);
  r2.w = max(9.99999975e-05, r2.w);
  r2.w = log2(r2.w);
  r2.w = 60 * r2.w;
  r2.w = exp2(r2.w);
  r1.y = v8.y * -r1.y + r1.y;
  r6.xyzw = s_environment.SampleLevel(s_environment_s, r5.xyz, r1.x).xyzw;
  r1.x = dot(-sun_direction.xyz, r5.xyz);
  r1.x = max(-1, r1.x);
  r1.x = min(1, r1.x);
  r1.y = v8.x * -r1.y + r1.y;
  r4.y = 1 + -r1.y;
  r2.w = r2.w * r4.y + r1.y;
  r4.z = 1 + -r2.w;
  r4.z = r4.z * r1.y;
  r1.z = r1.z * r2.w + r4.z;
  r1.z = max(r1.y, r1.z);
  r5.xyz = r6.xyz * r1.zzz;
  r6.xyzw = s_specular_colour_map.Sample(s_specular_colour_map_s, v2.xy).xyzw;
  r1.z = dot(r6.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r7.xyz = r1.zzz + -r6.xyz;
  r6.xyz = v8.yyy * r7.xyz + r6.xyz;
  r5.xyz = r6.xyz * r5.xyz;
  r5.xyz = float3(2.5,2.5,2.5) * r5.xyz;
  r1.z = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r7.xyz = r1.zzz + -r0.xyz;
  r0.xyz = v8.yyy * r7.xyz + r0.xyz;
  r7.xyz = r0.xyz * float3(5,5,5) + float3(0.200000003,0.200000003,0.200000003);
  r7.xyz = r7.xyz + -r0.xyz;
  r0.xyz = saturate(v8.xxx * r7.xyz + r0.xyz);
  r7.xyz = float3(1,4,1) * r2.xyz;
  r1.z = dot(r2.xyz, -sun_direction.xyz);
  r2.x = dot(r7.xyz, r7.xyz);
  r2.x = rsqrt(r2.x);
  r2.xyz = r7.xyz * r2.xxx;
  r7.xyz = cmp(r2.xyz < float3(0,0,0));
  r2.xyz = r2.xyz * r2.xyz;
  r8.xyz = (bool3)r7.xxx ? ambient_cube_lr[1].xyz : ambient_cube_lr[0].xyz;
  r7.xyw = (bool3)r7.yyy ? ambient_cube_tb[1].xyz : ambient_cube_tb[0].xyz;
  r9.xyz = (bool3)r7.zzz ? ambient_cube_fb[1].xyz : ambient_cube_fb[0].xyz;
  r7.xyz = r7.xyw * r2.yyy;
  r2.xyw = r2.xxx * r8.xyz + r7.xyz;
  r2.xyz = r2.zzz * r9.xyz + r2.xyw;
  r2.w = cmp(0 < g_hdr_on);
  r7.xyz = (bool3)r2.www ? float3(0.00400000019,360,1) : float3(1,1,273);
  r2.xyz = r7.yyy * r2.xyz;
  r2.xyz = r2.xyz * r0.xyz;
  r2.xyz = r2.xyz * r4.yyy;
  r2.w = r4.x * r4.y + r1.y;
  r2.xyz = r2.xyz * r7.xxx + r5.xyz;
  r4.x = abs(r1.x) * -0.0187292993 + 0.0742610022;
  r4.x = r4.x * abs(r1.x) + -0.212114394;
  r4.x = r4.x * abs(r1.x) + 1.57072878;
  r4.y = 1 + -abs(r1.x);
  r1.x = cmp(r1.x < -r1.x);
  r4.y = sqrt(r4.y);
  r4.z = r4.x * r4.y;
  r4.z = r4.z * -2 + 3.14159274;
  r1.x = (bool)r1.x ? r4.z : 0;
  r1.x = r4.x * r4.y + r1.x;
  r4.xy = float2(-0.0174532924,0.0174532924) + r1.xx;
  r4.xy = r4.xy * r0.ww;
  r0.w = cmp(r4.x < 0);
  r4.zw = cmp(float2(0,0) < r4.xy);
  r4.xy = float2(0.707106769,0.707106769) * r4.xy;
  r4.xy = r4.xy * r4.xy;
  r0.w = (int)r0.w + (int)-r4.z;
  r1.x = (int)-r4.w;
  r0.w = (int)r0.w;
  r5.xyzw = r4.xxyy * float4(0.140012279,0.140012279,0.140012279,0.140012279) + float4(1.27323949,1,1.27323949,1);
  r4.zw = r5.xz / r5.yw;
  r4.xy = -r4.xy * r4.zw;
  r4.xy = float2(1.44269502,1.44269502) * r4.xy;
  r4.xy = exp2(r4.xy);
  r4.xy = float2(1,1) + -r4.xy;
  r4.xy = sqrt(r4.xy);
  r0.w = r0.w * r4.x + 1;
  r1.x = r1.x * r4.y + 1;
  r0.w = 0.5 * r0.w;
  r0.w = r1.x * 0.5 + -r0.w;
  r1.x = 0.99984771 + r1.z;
  r1.z = max(0, r1.z);
  r0.xyz = r1.zzz * r0.xyz;
  r0.xyz = sun_colour.xyz * r0.xyz;
  r1.x = saturate(1.00015235 * r1.x);
  r0.w = r1.x * r0.w;
  r0.w = r0.w * r2.w;
  r1.x = cmp(0 < r1.y);
  r1.x = (bool)r1.x ? 1.000000 : 0;
  r0.w = r1.x * r0.w;
  r1.x = max(r0.w, r1.y);
  r0.w = saturate(r0.w * r7.z);
  r4.xyz = r0.www * r6.xyz;
  r0.w = 1 + -r1.x;
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = r0.xyz * r7.xxx;
  r0.xyz = r4.xyz * sun_colour.xyz + r0.xyz;
  r0.xyz = r2.xyz + r0.xyz;
  r3.w = max(0, r3.y);
  r2.xyzw = s_sky.Sample(s_sky_s, r3.xwz).xyzw;
  r1.xyz = g_volume_fog_colour.xyz * sun_colour.xyz;
  r1.xyz = float3(1.5,1.5,1.5) * r1.xyz;
  r1.xyz = abs(sun_direction.yyy) * r1.xyz;
  r2.xyz = -r1.xyz * r7.xxx + r2.xyz;
  r1.xyz = r1.xyz * r7.xxx;
  r0.w = 1 + -g_fog_distance_strength;
  r0.w = 1000 * r0.w;
  r0.w = r1.w / r0.w;
  r2.w = 1 + -g_fog_distance_start;
  r2.w = r2.w * 8 + -4;
  r0.w = r2.w + r0.w;
  r0.w = 1.44269502 * r0.w;
  r0.w = exp2(r0.w);
  r0.w = g_fog_distance_scale / r0.w;
  r0.w = saturate(g_fog_distance_scale + -r0.w);
  r2.w = saturate(dot(r0.ww, g_fog_colour_blend));
  r1.xyz = r2.www * r2.xyz + r1.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r2.x = max(0.00100000005, g_fog_clear_distance);
  r2.x = 1 / r2.x;
  r1.w = r2.x * r1.w;
  r1.w = min(1, r1.w);
  r2.x = r1.w * -2 + 3;
  r1.w = r1.w * r1.w;
  r1.w = r2.x * r1.w;
  r2.x = g_fog_height_top + -v1.y;
  r2.x = -g_fog_height_bottom + r2.x;
  r2.y = g_fog_height_top + -g_fog_height_bottom;
  r2.y = 1 / r2.y;
  r2.x = saturate(r2.x * r2.y);
  r2.y = r2.x * -2 + 3;
  r2.x = r2.x * r2.x;
  r2.x = r2.y * r2.x;
  r0.w = g_fog_height_strength * r2.x + r0.w;
  r0.w = saturate(r1.w * r0.w);
  // SDR clamp removed for HDR
  r0.xyz = (RENODX_TONE_MAP_TYPE != 0)
         ? max(0, r0.www * r1.xyz + r0.xyz)
         : saturate(r0.www * r1.xyz + r0.xyz);
  r0.xyz = log2(r0.xyz);
  // Use fixed gamma 2.2 in HDR mode, bypass user gamma slider
  float inv_gamma = (RENODX_TONE_MAP_TYPE != 0) ? HDR_INV_GAMMA : g_inv_gamma_output;
  r0.xyz = inv_gamma * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  // Remove min(1,1,1) SDR clamp in HDR mode
  o0.xyz = (RENODX_TONE_MAP_TYPE != 0) ? r0.xyz : min(float3(1,1,1), r0.xyz);
  o0.w = 1;
  return;
}