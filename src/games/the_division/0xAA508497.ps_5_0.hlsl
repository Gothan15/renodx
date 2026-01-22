// ---- Created with 3Dmigoto v1.4.1 on Wed Jan 21 14:44:46 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear centroid float2 v0 : IO0_uv0,
  linear centroid float4 v1 : IO1_offsets0,
  linear centroid float4 v2 : IO1_offsets1,
  linear centroid float4 v3 : IO1_offsets2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  // --- Base sample and edge deltas against first offsets
  r0.xyz = t0.SampleLevel(s0_s, v0.xy, 0).xyz;
  r1.xyz = t0.SampleLevel(s0_s, v1.xy, 0).xyz;
  r1.xyz = -r1.xyz + r0.xyz;
  r0.w = max(abs(r1.x), abs(r1.y));
  r1.x = max(r0.w, abs(r1.z));
  // --- Edge deltas against second offsets
  r2.xyz = t0.SampleLevel(s0_s, v1.zw, 0).xyz;
  r2.xyz = -r2.xyz + r0.xyz;
  r0.w = max(abs(r2.x), abs(r2.y));
  r1.y = max(r0.w, abs(r2.z));
  // --- Discard if no edge candidate above threshold
  r1.zw = cmp(r1.xy >= cb0[0].zz);
  r1.zw = r1.zw ? float2(1,1) : 0;
  r0.w = dot(r1.zw, float2(1,1));
  r0.w = cmp(r0.w == 0.000000);
  if (r0.w != 0) discard;
  // --- Check remaining neighborhood samples for strongest edge
  r2.xyz = t0.SampleLevel(s0_s, v2.xy, 0).xyz;
  r2.xyz = -r2.xyz + r0.xyz;
  r0.w = max(abs(r2.x), abs(r2.y));
  r0.w = max(r0.w, abs(r2.z));
  r2.xyz = t0.SampleLevel(s0_s, v2.zw, 0).xyz;
  r2.xyz = -r2.xyz + r0.xyz;
  r2.x = max(abs(r2.x), abs(r2.y));
  r2.x = max(r2.x, abs(r2.z));
  r2.y = max(r1.x, r1.y);
  r0.w = max(r2.y, r0.w);
  r0.w = max(r0.w, r2.x);
  r2.xyz = t0.SampleLevel(s0_s, v3.xy, 0).xyz;
  r2.xyz = -r2.xyz + r0.xyz;
  r2.x = max(abs(r2.x), abs(r2.y));
  r2.x = max(r2.x, abs(r2.z));
  r2.yzw = t0.SampleLevel(s0_s, v3.zw, 0).xyz;
  r0.xyz = -r2.yzw + r0.xyz;
  r0.x = max(abs(r0.x), abs(r0.y));
  r0.x = max(r0.x, abs(r0.z));
  // --- Final edge comparison and output flags
  r0.y = max(r2.x, r0.w);
  r0.x = max(r0.y, r0.x);
  r0.x = 0.5 * r0.x;
  r0.xy = cmp(r1.xy >= r0.xx);
  r0.xy = r0.xy ? float2(1,1) : 0;
  o0.xy = r1.zw * r0.xy;
  o0.zw = float2(0,0);
  return;
}