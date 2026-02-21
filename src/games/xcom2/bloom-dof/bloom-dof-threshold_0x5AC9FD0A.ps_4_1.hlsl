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

cbuffer PSOffsetConstants : register(b2)
{
  float4 ScreenPositionScaleBias : packoffset(c0);
  float4 MinZ_MaxZRatio : packoffset(c1);
  float NvStereoEnabled : packoffset(c2);
  float4 DiffuseOverrideParameter : packoffset(c3);
  float4 SpecularOverrideParameter : packoffset(c4);
  float4 CameraPositionPS : packoffset(c5);
  float4 ScreenTexelSize : packoffset(c6);
  float4 ViewportPositionScaleBias : packoffset(c7);
  float4 TransLightingVolumeMin : packoffset(c8);
  float4 TransLightingVolumeInvSize : packoffset(c9);
  float2 NumMSAASamples : packoffset(c10);
}

SamplerState SceneDepthTexture_s : register(s0);
SamplerState SmallSceneColorTexture_s : register(s1);
Texture2D<float4> SmallSceneColorTexture : register(t0);
Texture2D<float4> SceneDepthTexture : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = SmallSceneColorTexture.SampleLevel(SmallSceneColorTexture_s, v0.wz, GatherParams.y).xyz;
  r0.xyz = GatherParams.xxx * r0.xyz;
  r0.xyz = min(float3(32,32,32), r0.xyz);
  r1.x = max(r0.y, r0.z);
  r1.x = max(r1.x, r0.x);
  r1.y = -BloomScaleAndThreshold.y + r1.x;
  r1.x = saturate(r1.y / r1.x);
  r1.xyz = r1.xxx * r0.xyz;
  r2.xyz = SmallSceneColorTexture.SampleLevel(SmallSceneColorTexture_s, v0.xy, GatherParams.y).xyz;
  r2.xyz = GatherParams.xxx * r2.xyz;
  r2.xyz = min(float3(32,32,32), r2.xyz);
  r1.w = max(r2.y, r2.z);
  r1.w = max(r2.x, r1.w);
  r3.x = -BloomScaleAndThreshold.y + r1.w;
  r1.w = saturate(r3.x / r1.w);
  r1.xyz = r2.xyz * r1.www + r1.xyz;
  r3.xyz = SmallSceneColorTexture.SampleLevel(SmallSceneColorTexture_s, v1.xy, GatherParams.y).xyz;
  r3.xyz = GatherParams.xxx * r3.xyz;
  r3.xyz = min(float3(32,32,32), r3.xyz);
  r1.w = max(r3.y, r3.z);
  r1.w = max(r3.x, r1.w);
  r4.x = -BloomScaleAndThreshold.y + r1.w;
  r1.w = saturate(r4.x / r1.w);
  r1.xyz = r3.xyz * r1.www + r1.xyz;
  r4.xyz = SmallSceneColorTexture.SampleLevel(SmallSceneColorTexture_s, v1.wz, GatherParams.y).xyz;
  r4.xyz = GatherParams.xxx * r4.xyz;
  r4.xyz = min(float3(32,32,32), r4.xyz);
  r1.w = max(r4.y, r4.z);
  r1.w = max(r4.x, r1.w);
  r5.x = -BloomScaleAndThreshold.y + r1.w;
  r1.w = saturate(r5.x / r1.w);
  r1.xyz = r4.xyz * r1.www + r1.xyz;
  r5.xyz = float3(0.25,0.25,0.25) * r1.xyz;
  o0.xyz = float3(0.0625,0.0625,0.0625) * r1.xyz;
  r1.x = max(r5.y, r5.z);
  r1.x = max(r5.x, r1.x);
  r1.x = cmp(0 < r1.x);
  o0.w = r1.x ? TemporalParams.y : TemporalParams.x;
  r1.x = SceneDepthTexture.SampleLevel(SceneDepthTexture_s, v0.wz, 0).x;
  r1.y = r1.x * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r1.x = cmp(0.999000013 < r1.x);
  r1.y = 1 / r1.y;
  r0.w = r1.x ? 1000000 : r1.y;
  r1.x = -PackedParameters.x + r0.w;
  r1.y = saturate(PackedParameters.y * abs(r1.x));
  r1.x = cmp(r1.x < 0);
  r1.x = r1.x ? MinMaxBlurClamp.x : MinMaxBlurClamp.y;
  r1.y = log2(r1.y);
  r1.y = PackedParameters.z * r1.y;
  r1.y = exp2(r1.y);
  r1.x = min(r1.x, r1.y);
  r1.x = max(PackedParameters.w, r1.x);
  r1.x = r1.x * r1.x + 0.00100000005;
  r0.xyzw = r1.xxxx * r0.xyzw;
  r1.y = SceneDepthTexture.SampleLevel(SceneDepthTexture_s, v0.xy, 0).x;
  r1.z = r1.y * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r1.y = cmp(0.999000013 < r1.y);
  r1.z = 1 / r1.z;
  r2.w = r1.y ? 1000000 : r1.z;
  r1.y = -PackedParameters.x + r2.w;
  r1.z = saturate(PackedParameters.y * abs(r1.y));
  r1.y = cmp(r1.y < 0);
  r1.y = r1.y ? MinMaxBlurClamp.x : MinMaxBlurClamp.y;
  r1.z = log2(r1.z);
  r1.z = PackedParameters.z * r1.z;
  r1.z = exp2(r1.z);
  r1.y = min(r1.y, r1.z);
  r1.y = max(PackedParameters.w, r1.y);
  r1.y = r1.y * r1.y + 0.00100000005;
  r0.xyzw = r2.xyzw * r1.yyyy + r0.xyzw;
  r1.x = r1.y + r1.x;
  r1.y = SceneDepthTexture.SampleLevel(SceneDepthTexture_s, v1.xy, 0).x;
  r1.z = r1.y * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r1.y = cmp(0.999000013 < r1.y);
  r1.z = 1 / r1.z;
  r3.w = r1.y ? 1000000 : r1.z;
  r1.y = -PackedParameters.x + r3.w;
  r1.z = saturate(PackedParameters.y * abs(r1.y));
  r1.y = cmp(r1.y < 0);
  r1.y = r1.y ? MinMaxBlurClamp.x : MinMaxBlurClamp.y;
  r1.z = log2(r1.z);
  r1.z = PackedParameters.z * r1.z;
  r1.z = exp2(r1.z);
  r1.y = min(r1.y, r1.z);
  r1.y = max(PackedParameters.w, r1.y);
  r1.y = r1.y * r1.y + 0.00100000005;
  r0.xyzw = r3.xyzw * r1.yyyy + r0.xyzw;
  r1.x = r1.x + r1.y;
  r1.y = SceneDepthTexture.SampleLevel(SceneDepthTexture_s, v1.wz, 0).x;
  r1.z = r1.y * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r1.y = cmp(0.999000013 < r1.y);
  r1.z = 1 / r1.z;
  r4.w = r1.y ? 1000000 : r1.z;
  r1.y = -PackedParameters.x + r4.w;
  r1.z = saturate(PackedParameters.y * abs(r1.y));
  r1.y = cmp(r1.y < 0);
  r1.y = r1.y ? MinMaxBlurClamp.x : MinMaxBlurClamp.y;
  r1.z = log2(r1.z);
  r1.z = PackedParameters.z * r1.z;
  r1.z = exp2(r1.z);
  r1.y = min(r1.y, r1.z);
  r1.y = max(PackedParameters.w, r1.y);
  r1.y = r1.y * r1.y + 0.00100000005;
  r0.xyzw = r4.xyzw * r1.yyyy + r0.xyzw;
  r1.x = r1.x + r1.y;
  r0.xyzw = r0.xyzw / r1.xxxx;
  r1.x = cmp(r0.w < 14);
  o1.w = r1.x ? -65504 : -r0.w;
  o1.xyz = r0.xyz;
  return;
}