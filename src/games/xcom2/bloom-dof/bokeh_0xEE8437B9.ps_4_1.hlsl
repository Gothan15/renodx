// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 19:58:52 2026

SamplerState BokehTexture_s : register(s0);
Texture2D<float4> BokehTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float3 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(v1.z < 0);
  if (r0.x != 0) discard;
  r0.xyz = BokehTexture.Sample(BokehTexture_s, v1.xy).xyz;
  r0.w = dot(float3(0.333333343,0.333333343,0.333333343), r0.xyz);
  o0.xyzw = v0.xyzw * r0.xyzw;
  return;
}