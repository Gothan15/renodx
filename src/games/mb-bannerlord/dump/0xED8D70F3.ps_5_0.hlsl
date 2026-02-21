// ---- Created with 3Dmigoto v1.4.1 on Thu Feb 19 09:36:59 2026
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t0.Sample(s1_s, v2.xy).x;
  r0.y = t1.Sample(s1_s, v2.xy).x;
  o0.xyzw = min(r0.yyyy, r0.xxxx);
  return;
}