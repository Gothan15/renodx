
#include "./shared.h"

Texture2D<float4> t6 : register(t6);

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

  // Sample adapted luminance (auto-exposure) from t6 center
  r0.x = t6.Sample(s3_s, float2(0.5,0.5)).x;

  // Fetch source texture dimensions; used to compute scaled UVs (render scale)
  t0.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.yz = fDest.xy;
  r1.xy = float2(1,1) / r0.yz;
  // Convert scaled pixel coords to normalized UVs with half-pixel offset
  r1.zw = cb2[33].xy * r0.yz;
  r1.zw = trunc(r1.zw);
  r0.yz = r1.zw / r0.yz;
  r0.yz = -r1.xy * float2(0.5,0.5) + r0.yz;
  r1.zw = cb2[33].xy * v2.xy;
  r1.zw = max(float2(0,0), r1.zw);
  r0.yz = min(r1.zw, r0.yz);
  // Sample main scene color
  r2.xyzw = t0.SampleLevel(s3_s, r0.yz, 0).xyzw;

  // Choose exposure: auto (1 / adapted luminance) or fallback (1 / cb2[23].z)
  r0.y = 1 / r0.x;
  r0.z = cmp(cb0[101].x == 0.000000);
  r0.w = 1 / cb2[23].z;
  r0.y = r0.z ? r0.w : r0.y;

  // Apply exposure to scene color
  r2.xyz = r2.xyz * r0.yyy;
  o0.w = r2.w;
  r2.xyz = max(float3(9.99999997e-07,9.99999997e-07,9.99999997e-07), r2.xyz);

  // ===========================================================================
  // SECTION 6: TONEMAPPING (Modified Hable curve)
  // ===========================================================================
  r0.xyz = r2.xyz * r0.xxx;

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