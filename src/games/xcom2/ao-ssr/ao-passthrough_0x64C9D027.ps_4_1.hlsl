// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 11:53:35 2026

SamplerState AmbientOcclusionTexture_s : register(s0);
Texture2D<float4> AmbientOcclusionTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float3 v2 : TEXCOORD2,
  float4 v3 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = AmbientOcclusionTexture.Sample(AmbientOcclusionTexture_s, v0.xy).x;
  o0.xyzw = r0.xxxx;
  return;
}