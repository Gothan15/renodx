// ---- Created with 3Dmigoto v1.4.1 on Wed Jan 21 14:27:57 2026
Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[5];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[5];
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
  float4 v3 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  // --- Radial falloff (screen-space) based on v0 within v1/w1 bounds
  r0.xy = -v1.xy + v0.xy;
  r0.zw = w1.xy + -v1.xy;
  r0.xy = r0.xy / r0.zw;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = cb1[3].w + -r0.x;
  r0.x = max(0, r0.x);
  r0.x = cb1[4].x * r0.x;
  r0.x = log2(r0.x);
  r0.x = cb1[4].y * r0.x;
  r0.x = exp2(r0.x);
  r0.x = min(1, r0.x);
  r0.x = 1 + -r0.x;
  r0.x = -cb1[3].z * r0.x + 1;
  // --- Sample base color and blend with alternate sample based on mask
  r0.yz = w0.xy * cb0[0].zw + cb0[0].xy;
  r0.yz = max(cb0[1].xy, r0.yz);
  r0.yz = min(cb0[1].zw, r0.yz);
  r0.yzw = t1.SampleLevel(s1_s, r0.yz, 0).xyz;
  r1.xyz = t0.SampleLevel(s0_s, v0.xy, 0).xyz;
  r0.yzw = -r1.xyz + r0.yzw;
  r1.w = t2.SampleLevel(s1_s, w0.xy, 0).x;
  r1.w = saturate(r1.w * cb0[4].y + cb0[4].x);
  r0.yzw = r1.www * r0.yzw + r1.xyz;
  // --- Multiply by detail/overlay from t3 * t4
  r1.xy = w0.xy * cb0[2].zw + cb0[2].xy;
  r1.xy = max(cb0[3].xy, r1.xy);
  r1.xy = min(cb0[3].zw, r1.xy);
  r1.xyz = t3.SampleLevel(s1_s, r1.xy, 0).xyz;
  r2.xyz = t4.SampleLevel(s1_s, w0.xy, 0).xyz;
  r0.yzw = r1.xyz * r2.xyz + r0.yzw;
  // --- Apply radial falloff to RGB (optional if cb1[3].z <= 0)
  r1.xyz = r0.yzw * r0.xxx;
  r0.x = cmp(0 < cb1[3].z);
  r0.xyz = r0.xxx ? r1.xyz : r0.yzw;
  // --- Tonemapping bypass: output pre-tonemap color for unclamp check
  r0.xyz = r0.xyz * 10.0;
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}