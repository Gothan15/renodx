// ---- Created with 3Dmigoto v1.4.1 on Wed Jan 21 14:27:57 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[1];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[2];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : IO0_uv0,
  float2 w0 : IO1_uv1,
  nointerpolation float2 v1 : IO2_uv0Min0,
  nointerpolation float2 w1 : IO3_uv0Max0,
  float2 v2 : IO4_uv1Min0,
  float2 w2 : IO5_uv1Max0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  // --- Base sample and initialization
  r0.xyzw = t0.SampleLevel(s0_s, v0.xy, 0).xyzw;
  r1.xyzw = float4(0.100000001,0.100000001,0.100000001,0.100000001) * r0.xyzw;
  // --- Compute sample count from alpha magnitude and clamp by cb0[1].w
  r0.x = abs(r0.w) + abs(r0.w);
  r0.x = ceil(r0.x);
  r0.x = (int)r0.x;
  r0.x = min(asint(cb0[1].w), (int)r0.x);
  // --- Horizontal/first-direction gather loop (offsets from cb1[0].xy)
  r2.xyzw = r1.xyzw;
  r0.yz = float2(0.100000001,0);
  while (true) {
    r3.x = cmp((int)r0.z >= (int)r0.x);
    if (r3.x != 0) break;
    r3.x = (int)r0.z;
    r3.x = 0.5 + r3.x;
    r3.yz = cb1[0].xy * r3.xx + v0.xy;
    r3.yz = max(v1.xy, r3.yz);
    r3.yz = min(w1.xy, r3.yz);
    r4.xyzw = t0.SampleLevel(s0_s, r3.yz, 0).xyzw;
    r3.x = saturate(-r3.x * 0.5 + abs(r0.w));
    r3.y = r3.x * abs(r4.w);
    r2.xyzw = r4.xyzw * r3.yyyy + r2.xyzw;
    r0.y = r3.x * abs(r4.w) + r0.y;
    r0.z = (int)r0.z + 1;
  }
  // --- Normalize first-direction accumulated color
  r2.xyzw = r2.xyzw / r0.yyyy;
  // --- Vertical/second-direction gather loop (offsets from cb1[0].zw)
  r3.xyzw = r1.xyzw;
  r0.yz = float2(0.100000001,0);
  while (true) {
    r4.x = cmp((int)r0.z >= (int)r0.x);
    if (r4.x != 0) break;
    r4.x = (int)r0.z;
    r4.x = 0.5 + r4.x;
    r4.yz = cb1[0].zw * r4.xx + v0.xy;
    r4.yz = max(v1.xy, r4.yz);
    r4.yz = min(w1.xy, r4.yz);
    r5.xyzw = t0.SampleLevel(s0_s, r4.yz, 0).xyzw;
    r4.x = saturate(-r4.x * 0.5 + abs(r0.w));
    r4.y = r4.x * abs(r5.w);
    r3.xyzw = r5.xyzw * r4.yyyy + r3.xyzw;
    r0.y = r4.x * abs(r5.w) + r0.y;
    r0.z = (int)r0.z + 1;
  }
  // --- Normalize second-direction and combine
  r0.xyzw = r3.xyzw / r0.yyyy;
  r0.xyzw = r2.xyzw + r0.xyzw;
  // --- Outputs: o0 is first-direction blur, o1 is combined/averaged blur
  o1.xyzw = float4(0.5,0.5,0.5,0.5) * r0.xyzw;
  o0.xyzw = r2.xyzw;
  return;
}