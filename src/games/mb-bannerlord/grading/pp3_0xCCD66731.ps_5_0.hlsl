

#include "../shared.h"

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

cbuffer cb2 : register(b2)
{
  float4 cb2[34];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[102];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  t1.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.xy = fDest.xy;
  r0.zw = cb2[33].xy * r0.xy;
  r0.zw = trunc(r0.zw);
  r0.zw = r0.zw / r0.xy;
  r0.xy = float2(1,1) / r0.xy;
  r0.xy = -r0.xy * float2(0.5,0.5) + r0.zw;
  r0.zw = cb2[33].xy * v2.xy;
  r0.zw = max(float2(0,0), r0.zw);
  r0.xy = min(r0.zw, r0.xy);
  r1.xyz = t1.SampleLevel(s3_s, r0.xy, 0).xyz;
  r0.x = cmp(cb0[101].x == 0.000000);
  r0.y = 1 / cb2[23].z;
  r1.w = t6.Sample(s3_s, float2(0.5,0.5)).x;
  r2.x = 1 / r1.w;
  r0.x = r0.x ? r0.y : r2.x;

  // Reduce auto-exposure strength for highlights to preserve bright detail
  if (CUSTOM_AUTO_EXPOSURE > 0) {
    float y_bloom = dot(r1.xyz * r0.x, float3(0.2126, 0.7152, 0.0722));
    float t_bloom = saturate(y_bloom - 0.18);
    float strength_bloom = lerp(1.0, 0.95, t_bloom * t_bloom * t_bloom);
    float adjusted_exposure = lerp(1.0, r0.x, strength_bloom);
    r1.xyz = r1.xyz * adjusted_exposure;
  } else {
    r1.xyz = r1.xyz * r0.xxx;
  }
  r1.xyz = log2(abs(r1.xyz));
  r1.xyz = cb2[4].xxx * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  t0.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r2.xy = fDest.xy;
  r2.zw = cb2[33].xy * r2.xy;
  r2.zw = trunc(r2.zw);
  r2.zw = r2.zw / r2.xy;
  r2.xy = float2(1,1) / r2.xy;
  r2.xy = -r2.xy * float2(0.5,0.5) + r2.zw;
  r0.yz = min(r2.xy, r0.zw);
  r2.xyzw = t0.SampleLevel(s3_s, r0.yz, 0).xyzw;

  // Apply same highlight-aware exposure to scene color
  if (CUSTOM_AUTO_EXPOSURE > 0) {
    float y_scene = dot(r2.xyz * r0.x, float3(0.2126, 0.7152, 0.0722));
    float t_scene = saturate(y_scene - 0.18);
    float strength_scene = lerp(1.0, 0.95, t_scene * t_scene * t_scene);
    float adjusted_scene_exposure = lerp(1.0, r0.x, strength_scene);
    r0.xyz = r2.xyz * adjusted_scene_exposure + r1.xyz;
  } else {
    r0.xyz = r2.xyz * r0.xxx + r1.xyz;
  }
  o0.w = r2.w;
  r0.xyz = max(float3(9.99999997e-07,9.99999997e-07,9.99999997e-07), r0.xyz);

  // ===========================================================================
  // SECTION 6: TONEMAPPING (Modified Hable curve)
  // ===========================================================================
  r0.xyz = r0.xyz * r1.www;
  
  if (RENODX_TONE_MAP_TYPE == 0) {
    r1.xyz = r0.xyz * float3(0.150000006,0.150000006,0.150000006) + float3(0.0500000007,0.0500000007,0.0500000007);
    r1.xyz = r0.xyz * r1.xyz + float3(0.00400000019,0.00400000019,0.00400000019);
    r2.xyz = r0.xyz * float3(0.150000006,0.150000006,0.150000006) + float3(0.5,0.5,0.5);
    r0.xyz = r0.xyz * r2.xyz + float3(0.0600000024,0.0600000024,0.0600000024);
    r0.xyz = r1.xyz / r0.xyz;
    r0.xyz = float3(-0.0666666627,-0.0666666627,-0.0666666627) + r0.xyz;
    o0.xyz = float3(4.53191471,4.53191471,4.53191471) * r0.xyz;
  } else {
    o0.xyz = r0.xyz;
  }
  return;
}