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
  float4 RenderTargetClampParameter : packoffset(c20);
  float4 MotionBlurMaskScaleAndBias : packoffset(c21);
  float4x4 ScreenToWorld : packoffset(c22);
  float4x4 PrevViewProjMatrix : packoffset(c26);
  float4 StaticVelocityParameters : packoffset(c30) = {0.5,-0.5,0.0125000002,0.0222222228};
  float4 DynamicVelocityParameters : packoffset(c31) = {0.0250000004,-0.0444444455,-0.0500000007,0.088888891};
  float StepOffsetsOpaque[5] : packoffset(c32);
  float StepWeightsOpaque[5] : packoffset(c37);
  float StepOffsetsTranslucent[5] : packoffset(c42);
  float StepWeightsTranslucent[5] : packoffset(c47);
  float4 DirtyLensValues : packoffset(c52);
  float4 BloomTintAndScreenBlendThreshold : packoffset(c53);
  float4 HalfResMaskRect : packoffset(c54);
  float4 DOFKernelSize : packoffset(c55);
}

SamplerState FilterColor0Texture_s : register(s0);
SamplerState LowResPostProcessBufferPoint_s : register(s1);
Texture2D<float4> LowResPostProcessBufferPoint : register(t0);
Texture2D<float4> FilterColor0Texture : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = LowResPostProcessBufferPoint.Sample(LowResPostProcessBufferPoint_s, v1.zw).xyzw;
  r0.w = -PackedParameters.x + abs(r0.w);
  r1.x = saturate(PackedParameters.y * abs(r0.w));
  r0.w = cmp(r0.w < 0);
  r0.w = r0.w ? MinMaxBlurClamp.x : MinMaxBlurClamp.y;
  r1.x = log2(r1.x);
  r1.x = PackedParameters.z * r1.x;
  r1.x = exp2(r1.x);
  r0.w = min(r1.x, r0.w);
  r0.w = max(PackedParameters.w, r0.w);
  r0.w = 1 + -r0.w;
  r1.xyzw = FilterColor0Texture.Sample(FilterColor0Texture_s, v0.zw).xyzw;
  r2.x = r1.w * 4 + r0.w;
  r2.x = cmp(r2.x == 0.000000);
  r0.w = r2.x ? 1 : r0.w;
  r1.xyz = float3(4,4,4) * r1.xyz;
  r1.w = r1.w * 4 + r0.w;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  o0.w = r0.w;
  r0.xyz = r0.xyz / r1.www;
  o0.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  return;
}