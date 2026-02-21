// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 12:09:38 2026

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
  float4 DeferredRenderingParameters : packoffset(c18);
  float4 LightColorAndFalloffExponent : packoffset(c19);
  float3 DistanceFieldParameters : packoffset(c20);
  float4x4 ScreenToShadowMatrix : packoffset(c21);
  float4 ShadowBufferAndTexelSize : packoffset(c25);
  float ShadowOverrideFactor : packoffset(c26);
  bool bReceiveDynamicShadows : packoffset(c26.y);
  bool bEnableDistanceShadowFading : packoffset(c26.z);
  float2 DistanceFadeParameters : packoffset(c27);
  float4 UVScaleBias : packoffset(c28);
  int MinZ : packoffset(c29);
  float4 ClearColor : packoffset(c30);
  float4 LevelVolumeDimensions : packoffset(c31);
  float4 LevelVolumePosition : packoffset(c32);
  float4 VoxelSizeUVW : packoffset(c33);
  float4 VoxelSizeXYZ : packoffset(c34);
  uint LightID : packoffset(c35);
  float3 CameraPosWS : packoffset(c35.y);
  float3 TranslucencyLightingVolumeInvSize : packoffset(c36);
  float3 TranslucencyLightingVolumeMin : packoffset(c37);
  float3 VoxelSizeWS : packoffset(c38);
  float4 LightColorAndFalloff : packoffset(c39);
  float4 LightPositionAndInvRadius : packoffset(c40);
  float3 LightDirection : packoffset(c41);
  float2 SpotAngles : packoffset(c42);
  float MinShadowOpacity : packoffset(c42.z);
  float4x4 WorldToShadowMatrix : packoffset(c43);
  float4 ShadowmapMinMax : packoffset(c47);
  float2 DepthBiasParams : packoffset(c48);
  float4 ShadowBufferSizeInvSize : packoffset(c49);
}



// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  uint v2 : SV_RenderTargetArrayIndex0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1,
  out float4 o2 : SV_Target2)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(LightDirection.xyz, LightDirection.xyz);
  r0.x = rsqrt(r0.x);
  r0.xyz = LightDirection.yzx * r0.xxx;
  r0.yzw = float3(-0.488602996,0.488602996,-0.488602996) * r0.xyz;
  r0.x = 0.282094985;
  o0.xyzw = LightColorAndFalloff.xxxx * r0.xyzw;
  o1.xyzw = LightColorAndFalloff.yyyy * r0.xyzw;
  o2.xyzw = LightColorAndFalloff.zzzz * r0.xyzw;
  return;
}