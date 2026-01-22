// ---- Created with 3Dmigoto v1.4.1 on Wed Jan 21 14:44:46 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[2];
}




// 3Dmigoto declarations
#define cmp -


void main)
{
// Needs manual fix for instruction:
// unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u0
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

// Needs manual fix for instruction:
// unknown dcl_: dcl_thread_group 8, 8, 1
  // --- Compute source UVs from thread ID
  r0.xy = (uint2)vThreadID.xy << int2(2,2);
  r0.xy = (uint2)r0.xy;
  r0.xy = float2(1,1) + r0.xy;
  r0.xy = r0.xy * cb0[0].xy + cb0[0].zw;
  // --- Clamp to bounds and sample center
  r0.zw = max(cb0[1].xy, r0.xy);
  r0.zw = min(cb0[1].zw, r0.zw);
  r1.xyz = t0.SampleLevel(s0_s, r0.zw, 0).xyz;
  // --- Sample 3 additional neighbors (2x2) and average
  r2.xyzw = cb0[0].xyxy * float4(2,0,0,2) + r0.xyxy;
  r0.xy = cb0[0].xy * float2(2,2) + r0.xy;
  r0.xy = max(cb0[1].xy, r0.xy);
  r0.xy = min(cb0[1].zw, r0.xy);
  r0.xyz = t0.SampleLevel(s0_s, r0.xy, 0).xyz;
  r2.xyzw = max(cb0[1].xyxy, r2.xyzw);
  r2.xyzw = min(cb0[1].zwzw, r2.xyzw);
  r3.xyz = t0.SampleLevel(s0_s, r2.xy, 0).xyz;
  r2.xyz = t0.SampleLevel(s0_s, r2.zw, 0).xyz;
  r1.xyz = r3.xyz + r1.xyz;
  r1.xyz = r1.xyz + r2.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  r0.w = 0;
  // --- Store downsampled result to UAV
// No code for instruction (needs manual fix):
store_uav_typed u0.xyzw, vThreadID.xyyy, r0.xyzw
  return;
}