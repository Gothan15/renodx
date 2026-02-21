// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 19:58:52 2026

cbuffer _Globals : register(b0)
{
  float4x4 ScreenToWorldMatrix : packoffset(c0);
  float4 SpherePositionRadius : packoffset(c4);
  bool bDecompressSceneColor : packoffset(c5);
  float4 SceneShadowsAndDesaturation : packoffset(c6);
  float4 SceneInverseHighLights : packoffset(c7);
  float4 SceneMidTones : packoffset(c8);
  float4 SceneScaledLuminanceWeights : packoffset(c9);
  float4 SceneColorize : packoffset(c10);
  float4 GammaColorScaleAndInverse : packoffset(c11);
  float4 GammaOverlayColor : packoffset(c12);
  float4 RenderTargetExtent : packoffset(c13);
  float4 ImageAdjustments1 : packoffset(c14);
  float4 ImageAdjustments2 : packoffset(c15);
  float4 ImageAdjustments3 : packoffset(c16);
  float InverseGamma : packoffset(c17);
  float4 PackedParameters : packoffset(c18);
  float4 MinMaxBlurClamp : packoffset(c19);
  float4 GatherParams : packoffset(c20);
  float4 BloomScaleAndThreshold : packoffset(c21);
  float2 TemporalParams : packoffset(c22);
}

SamplerState SmallSceneColorTexture_s : register(s0);
Texture2D<float4> SmallSceneColorTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = SmallSceneColorTexture.SampleLevel(SmallSceneColorTexture_s, v0.xy, GatherParams.y).xyz;
  r0.xyz = min(float3(32,32,32), r0.xyz);
  r1.xyz = SmallSceneColorTexture.SampleLevel(SmallSceneColorTexture_s, v0.wz, GatherParams.y).xyz;
  r1.xyz = min(float3(32,32,32), r1.xyz);
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyz = SmallSceneColorTexture.SampleLevel(SmallSceneColorTexture_s, v1.xy, GatherParams.y).xyz;
  r1.xyz = min(float3(32,32,32), r1.xyz);
  r0.xyz = r1.xyz + r0.xyz;
  r1.xyz = SmallSceneColorTexture.SampleLevel(SmallSceneColorTexture_s, v1.wz, GatherParams.y).xyz;
  r1.xyz = min(float3(32,32,32), r1.xyz);
  r0.xyz = r1.xyz + r0.xyz;
  o0.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  o0.w = 0;
  return;
}