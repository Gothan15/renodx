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
SamplerState s_diffuse_map_s : register(s1);
SamplerState s_normal_map_s : register(s2);
SamplerState s_gloss_map_s : register(s3);
SamplerState s_skin_mask_map_s : register(s4);
Texture2D<float4> s_diffuse_map : register(t0);
Texture2D<float4> s_normal_map : register(t1);
Texture2D<float4> s_gloss_map : register(t2);
Texture2D<float4> s_skin_mask_map : register(t3);
TextureCube<float4> s_sky : register(t4);


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
  r1.xyz = r0.xyz * float3(5,5,5) + float3(0.200000003,0.200000003,0.200000003);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = saturate(v8.xxx * r1.xyz + r0.xyz);
  r0.w = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r1.xyz = r0.www + -r0.xyz;
  r0.xyz = v8.yyy * r1.xyz + r0.xyz;
  r0.w = dot(v4.xyz, v4.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = v4.xyz * r0.www;
  r0.w = dot(v6.xyz, v6.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = v6.xyz * r0.www;
  r3.xyzw = s_normal_map.Sample(s_normal_map_s, v2.zw).xyzw;
  r3.xy = float2(0.00196078443,0.00196078443) + r3.wy;
  r3.xy = r3.xy * float2(2,2) + float2(-1,-1);
  r2.xyz = r3.yyy * r2.xyz;
  r1.xyz = r3.xxx * r1.xyz + r2.xyz;
  r0.w = dot(r3.xy, r3.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = sqrt(r0.w);
  r1.w = dot(v3.xyz, v3.xyz);
  r1.w = rsqrt(r1.w);
  r2.xyz = v3.xyz * r1.www;
  r1.xyz = r0.www * r2.xyz + r1.xyz;
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = r1.xyz * r0.www;
  r1.xyz = r1.xyz * r0.www + float3(0,0.75,0);
  r0.w = dot(r2.xyz, -sun_direction.xyz);
  r3.xyz = r0.www * float3(0.800000012,0.899999976,0.300000012) + float3(0.300000012,0.5,0.300000012);
  r3.xyz = saturate(float3(0.694444418,0.694444418,0.444444448) * r3.xyz);
  r1.w = r0.w * r3.x + 0.300000012;
  r1.w = saturate(1 + -r1.w);
  r4.xyz = float3(0.612065971,0.456263006,0.0500000007) * r3.yyy;
  r5.xyz = r4.xyz * r1.www;
  r4.xyz = -r4.xyz * r1.www + float3(1,1,1);
  r5.xyz = r0.www * r3.xxx + r5.xyz;
  r1.w = -r0.w * r3.x + 1;
  r3.xyz = float3(0.319999993,0.0500000007,0.00600000005) * r3.zzz;
  r3.xyz = r3.xyz * r1.www;
  r3.xyz = r3.xyz * r4.xyz + r5.xyz;
  r3.xyz = r3.xyz + -r0.www;
  r4.xyzw = s_skin_mask_map.Sample(s_skin_mask_map_s, v2.xy).xyzw;
  r3.xyz = saturate(r4.yyy * r3.xyz + r0.www);
  r3.xyz = r3.xyz * r0.xyz;
  r3.xyz = sun_colour.xyz * r3.xyz;
  r0.w = cmp(0 < g_hdr_on);
  r5.xyzw = (bool4)r0.wwww ? float4(0.00400000019,360,0.600000024,1) : float4(1,1,0.800000012,0.649999976);
  r3.xyz = r5.xxx * r3.xyz;
  r0.w = dot(r2.xyz, sun_direction.xyz);
  r1.w = saturate(r0.w);
  r0.w = r0.w + r0.w;
  r6.xyz = r2.xyz * -r0.www + sun_direction.xyz;
  r0.w = r1.w * r1.w;
  r7.xyz = -camera_position.xyz + v1.xyz;
  r1.w = dot(r7.xyz, r7.xyz);
  r2.w = rsqrt(r1.w);
  r1.w = sqrt(r1.w);
  r8.xyz = r7.xyz * r2.www;
  r2.w = saturate(dot(r8.xyz, -sun_direction.xyz));
  r2.w = r2.w * r2.w;
  r2.w = r2.w * r2.w;
  r0.w = r2.w * r0.w;
  r0.w = r0.w * r4.z;
  r4.yzw = sun_colour.xyz * r4.yyy;
  r4.yzw = r4.yzw * float3(-0.300000012,-1,-1) + sun_colour.xyz;
  r4.yzw = r4.yzw * r5.xxx;
  r4.yzw = r4.yzw * r0.www;
  r4.yzw = r4.yzw * r0.xyz;
  r4.yzw = float3(0.899999976,0.899999976,0.899999976) * r4.yzw;
  r3.xyz = r3.xyz * float3(0.899999976,0.899999976,0.899999976) + r4.yzw;
  r0.w = dot(r6.xyz, -r8.xyz);
  r0.w = max(0, r0.w);
  r0.w = log2(r0.w);
  r6.xyzw = s_gloss_map.Sample(s_gloss_map_s, v2.xy).xyzw;
  r2.w = r6.x * r6.x;
  r3.w = v8.x * -r6.y + r6.y;
  r3.w = v8.y * -r3.w + r3.w;
  r2.w = r2.w * 127 + 1.60000002;
  r0.w = r2.w * r0.w;
  r0.w = exp2(r0.w);
  r0.w = min(1, r0.w);
  r0.w = r3.w * r0.w;
  r4.yzw = sun_colour.xyz * r0.www;
  r4.yzw = r4.yzw * r5.xxx;
  r3.xyz = r4.yzw * float3(2,2,2) + r3.xyz;
  r0.w = dot(-r8.xyz, r2.xyz);
  r2.w = r0.w + r0.w;
  r0.w = saturate(1 + -r0.w);
  r0.w = r0.w * r0.w;
  r0.w = r0.w * r4.x;
  r0.w = 1.5 * r0.w;
  r0.w = r0.w * r5.w;
  r4.xyz = r2.xyz * -r2.www + -r8.xyz;
  r2.xyz = float3(1,4,1) * r2.xyz;
  r4.xyz = float3(1,4,1) * r4.xyz;
  r2.w = dot(r4.xyz, r4.xyz);
  r2.w = rsqrt(r2.w);
  r4.xyz = r4.xyz * r2.www;
  r6.xyz = cmp(r4.xyz < float3(0,0,0));
  r4.xyz = r4.xyz * r4.xyz;
  r8.xyz = (bool3)r6.xxx ? ambient_cube_lr[1].xyz : ambient_cube_lr[0].xyz;
  r6.xyw = (bool3)r6.yyy ? ambient_cube_tb[1].xyz : ambient_cube_tb[0].xyz;
  r9.xyz = (bool3)r6.zzz ? ambient_cube_fb[1].xyz : ambient_cube_fb[0].xyz;
  r6.xyz = r6.xyw * r4.yyy;
  r4.xyw = r4.xxx * r8.xyz + r6.xyz;
  r4.xyz = r4.zzz * r9.xyz + r4.xyw;
  r1.x = dot(r1.xyz, r1.xyz);
  r1.x = rsqrt(r1.x);
  r1.x = r1.y * r1.x;
  r1.x = max(0, r1.x);
  r0.w = r1.x * r0.w;
  r1.xyz = r0.www * r4.xyz;
  r0.w = dot(r2.xyz, r2.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = r2.xyz * r0.www;
  r4.xyz = cmp(r2.xyz < float3(0,0,0));
  r2.xyz = r2.xyz * r2.xyz;
  r6.xyz = (bool3)r4.xxx ? ambient_cube_lr[1].xyz : ambient_cube_lr[0].xyz;
  r4.xyw = (bool3)r4.yyy ? ambient_cube_tb[1].xyz : ambient_cube_tb[0].xyz;
  r8.xyz = (bool3)r4.zzz ? ambient_cube_fb[1].xyz : ambient_cube_fb[0].xyz;
  r4.xyz = r4.xyw * r2.yyy;
  r2.xyw = r2.xxx * r6.xyz + r4.xyz;
  r2.xyz = r2.zzz * r8.xyz + r2.xyw;
  r0.xyz = r2.xyz * r0.xyz;
  r0.xyz = r0.xyz * r5.yyy;
  r0.w = r5.x * r5.z;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  r0.xyz = r0.xyz + r3.xyz;
  r7.w = max(0, r7.y);
  r2.xyzw = s_sky.Sample(s_sky_s, r7.xwz).xyzw;
  r1.xyz = g_volume_fog_colour.xyz * sun_colour.xyz;
  r1.xyz = float3(1.5,1.5,1.5) * r1.xyz;
  r1.xyz = abs(sun_direction.yyy) * r1.xyz;
  r2.xyz = -r1.xyz * r5.xxx + r2.xyz;
  r1.xyz = r1.xyz * r5.xxx;
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