// ---- Created with 3Dmigoto v1.4.1 on Wed Jan 21 14:27:57 2026
Texture2D<float4> t1 : register(t1);

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
  float4 v1 : IO1_offsets0,
  linear centroid float4 v2 : IO1_offsets1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  // --- Gather neighborhood/offset samples from t1 (search/edge data)
  r0.xz = t1.SampleLevel(s0_s, v0.xy, 0).xz;
  r0.y = t1.SampleLevel(s0_s, v2.zw, 0).y;
  r0.w = t1.SampleLevel(s0_s, v2.xy, 0).w;
  // --- If all samples are ~0, pass through original color
  r1.x = dot(r0.xyzw, float4(1,1,1,1));
  r1.x = cmp(r1.x < 9.99999975e-06);
  if (r1.x != 0) {
    o0.xyzw = t0.SampleLevel(s0_s, v0.xy, 0).xyzw;
  } else {
    // --- Determine dominant offset direction (pick strongest component/sign)
    r1.x = cmp(r0.z < r0.w);
    r1.x = r1.x ? r0.w : -r0.z;
    r0.z = cmp(r0.x < r0.y);
    r1.w = r0.z ? r0.y : -r0.x;
    r0.x = cmp(abs(r1.w) < abs(r1.x));
    r1.yz = float2(0,0);
    r0.xy = r0.xx ? r1.xy : r1.zw;
    // --- Sample base color and neighbor in chosen direction
    r1.xyzw = t0.SampleLevel(s0_s, v0.xy, 0).xyzw;
    r0.zw = cmp(float2(0,0) < r0.xy);
    r2.xy = cmp(r0.xy < float2(0,0));
    r0.zw = (int2)-r0.zw + (int2)r2.xy;
    r0.zw = (int2)r0.zw;
    r0.zw = r0.zw * cb0[0].xy + v0.xy;
    r2.xyzw = t0.SampleLevel(s0_s, r0.zw, 0).xyzw;
    // --- Blend between base and neighbor by magnitude (edge-aware filter)
    r0.x = max(abs(r0.y), abs(r0.x));
    r2.xyzw = r2.xyzw + -r1.xyzw;
    o0.xyzw = r0.xxxx * r2.xyzw + r1.xyzw;
  }
  return;
}