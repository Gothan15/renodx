// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 11:57:18 2026

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
  float4 UVScaleBias : packoffset(c19);
  int MinZ : packoffset(c20);
  float4 ClearColor : packoffset(c21);
  float2 InvViewport : packoffset(c22);
  float3 LevelVolumeDimensions : packoffset(c23);
  float3 LevelVolumePosition : packoffset(c24);
  float3 VoxelSizeUVW : packoffset(c25);
  float3 CameraPosWS : packoffset(c26);
  float4 NoiseScale : packoffset(c27);
  float3 AmbientIntensity : packoffset(c28);
  float3 CenterLocation : packoffset(c29);
  float4 BlendParameters : packoffset(c30);
  float3 BlendParameters2 : packoffset(c31);
  float3 BoxCenter : packoffset(c32);
  float3 BoxMax : packoffset(c33);
  float3 BoxMin : packoffset(c34);
  float4x4 ScreenToWorldOffset : packoffset(c35);
  float2 CharSpecAndDiffMod : packoffset(c39);
  float4 ScreenPositionScaleBiasForAmbient : packoffset(c40);
  float4 RedSHCoeff : packoffset(c41);
  float4 GreenSHCoeff : packoffset(c42);
  float4 BlueSHCoeff : packoffset(c43);
  float3 TileMinimum : packoffset(c44);
  float LerpAmount : packoffset(c44.w);
  int3 VolumeSize : packoffset(c45);
}

Texture3D<float4> VolumeMap : register(t0);


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

  r0.xy = floor(v1.xy);
  r0.z = (uint)v2.x;
  r0.xyz = -TileMinimum.xyz + r0.xyz;
  r0.xyz = (int3)r0.xyz;
  r0.w = 0;
  r0.x = VolumeMap.Load(r0.xyzw).x;
  r0.x = -0.100000001 + r0.x;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  o0.xyzw = RedSHCoeff.xyzw;
  o1.xyzw = GreenSHCoeff.xyzw;
  o2.xyzw = BlueSHCoeff.xyzw;
  return;
}