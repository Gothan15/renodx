// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 12:52:37 2026
#include "./common.hlsl"

cbuffer _Globals : register(b0)
{
  float4 tor : packoffset(c0);
  float4 tog : packoffset(c1);
  float4 tob : packoffset(c2);
  float4 consts : packoffset(c3);
}

SamplerState tex0_s : register(s0);
SamplerState tex1_s : register(s1);
SamplerState tex2_s : register(s2);
Texture2D<float4> tex0 : register(t0);
Texture2D<float4> tex1 : register(t1);
Texture2D<float4> tex2 : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  o0.w = consts.w;
  r0.x = tex0.Sample(tex0_s, v0.xy).x;
  r0.y = tex1.Sample(tex1_s, v0.xy).x;
  r0.z = tex2.Sample(tex2_s, v0.xy).x;
  r0.w = consts.x;
  float3 rgb;
  rgb.x = dot(tor.xyzw, r0.xyzw);
  rgb.y = dot(tog.xyzw, r0.xyzw);
  rgb.z = dot(tob.xyzw, r0.xyzw);

  rgb = AutoHDRVideo(rgb);

  o0.x = rgb.x;
  o0.y = rgb.y;
  o0.z = rgb.z;
  return;
}