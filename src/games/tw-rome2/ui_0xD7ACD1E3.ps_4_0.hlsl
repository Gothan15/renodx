// ---- Created with 3Dmigoto v1.4.1 on Mon Jan 12 05:27:10 2026

#include "./shared.h"

static const float HDR_INV_GAMMA = 1.0 / 2.2;

cbuffer colorimetry_VS_PS : register(b0)
{
  float g_brightness : packoffset(c0);
  float g_gamma_output : packoffset(c0.y);
  float g_inv_gamma_output : packoffset(c0.z);
}

cbuffer sprite_PS : register(b1)
{
  float g_windows_time_PS : packoffset(c0);
  float g_model_time_PS : packoffset(c0.y);
  float g_text_rendering_enabled_PS : packoffset(c0.z);
  float g_switch_diffuse_channels : packoffset(c0.w);
  float2 g_screen_dimensions_PS : packoffset(c1);
}

SamplerState s_diffuse_map_s : register(s0);
Texture2D<float4> s_diffuse_map : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  float w2 : TEXCOORD7,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  float3 v5 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = s_diffuse_map.SampleLevel(s_diffuse_map_s, v2.xy, v2.y).xyzw;
  // Text rendering path - remove SDR clamp in HDR mode
  r1.x = (RENODX_TONE_MAP_TYPE != 0) ? max(0, r0.x) : saturate(r0.x);
  r1.x = log2(r1.x);
  // Use fixed gamma 2.2 in HDR mode for text
  float text_inv_gamma = (RENODX_TONE_MAP_TYPE != 0) ? HDR_INV_GAMMA : g_inv_gamma_output;
  r1.x = text_inv_gamma * r1.x;
  r1.w = exp2(r1.x);
  r1.xyz = float3(1,1,1);
  r2.xy = cmp(float2(0.5,0.5) < g_text_rendering_enabled_PS);
  r0.xz = (bool2)r2.yy ? r0.zx : r0.xz;
  r0.xyzw = (bool4)r2.xxxx ? r1.xyzw : r0.xyzw;
  r1.x = r0.w * v1.w + -0.00392156886;
  r1.x = cmp(r1.x < 0);
  if (r1.x != 0) discard;
  r1.xy = v5.xy + -v4.xw;
  r1.zw = -v5.xy + v4.zy;
  r1.xyzw = cmp(r1.xyzw < float4(0,0,0,0));
  r1.xy = (int2)r1.zw | (int2)r1.xy;
  r1.x = (int)r1.y | (int)r1.x;
  if (r1.x != 0) discard;
  r1.xyzw = v1.xyzw * r0.xyzw;
  r0.w = dot(r1.xyz, float3(0.300000012,0.589999974,0.109999999));
  r0.xyz = -r0.xyz * v1.xyz + r0.www;
  // SDR clamp removed for HDR
  r0.xyz = (RENODX_TONE_MAP_TYPE != 0)
         ? max(0, v3.xxx * r0.xyz + r1.xyz)
         : saturate(v3.xxx * r0.xyz + r1.xyz);
  r0.xyz = log2(r0.xyz);
  // Use fixed gamma 2.2 in HDR mode
  float inv_gamma = (RENODX_TONE_MAP_TYPE != 0) ? HDR_INV_GAMMA : g_inv_gamma_output;
  r0.xyz = inv_gamma * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  r0.x = cmp(0 < r1.w);
  r0.y = v3.y * r1.w;
  o0.w = (bool)r0.x ? r0.y : r1.w;
  return;
}