// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 11:57:18 2026

SamplerState AOOutputTexture_s : register(s0);
Texture2D<float4> AOOutputTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = AOOutputTexture.Sample(AOOutputTexture_s, v0.xy).x;
  o0.xyz = r0.xxx;
  o0.w = 1;
  return;
}