// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 14:14:51 2026

cbuffer _Globals : register(b0)
{
  float4x4 ScreenToWorldMatrix : packoffset(c0);
  float4 SpherePositionRadius : packoffset(c4);
  bool bDecompressSceneColor : packoffset(c5);
  float4 DeferredRenderingParameters : packoffset(c6);
  float4 SharedFogParameter0 : packoffset(c7);
  float4 SharedFogParameter1 : packoffset(c8);
  float4 SharedFogParameter2 : packoffset(c9);
  float4 SharedFogParameter3 : packoffset(c10);
  float bUseExponentialHeightFog : packoffset(c11);
  float4 FogInScattering[4] : packoffset(c12);
  float4 FogMaxHeight : packoffset(c16);
  float4 AOScreenPositionScaleBias : packoffset(c17);
  float3x3 WorldToViewMatrix : packoffset(c18);
  float2 HalfSceneColorTexelSize : packoffset(c21);
  float4x4 ScreenToView : packoffset(c22);
  float4x4 ScreenToWorldOffset : packoffset(c26);
  float4 NoiseScale : packoffset(c30);
  float2 ProjectionScale : packoffset(c31);
  float4x4 ProjectionMatrix : packoffset(c32);
  float4 OcclusionCalcParameters : packoffset(c36);
  float HaloDistanceScale : packoffset(c37);
  float4 OcclusionRemapParameters : packoffset(c38);
  float4 OcclusionFadeoutParameters : packoffset(c39);
  float MaxRadiusTransform : packoffset(c40);
  float4x4 TranslatedWorldToView : packoffset(c41);
  float4x4 TranslatedWorldToClip : packoffset(c45);
  float4 ScreenPosToUV : packoffset(c49);
  float3 LevelVolumeDimensions : packoffset(c50);
  float3 LevelVolumePosition : packoffset(c51);
  float3 VoxelSizeXYZ : packoffset(c52);
  float3 CameraPosWS : packoffset(c53);
  float4 FilterParameters : packoffset(c54);
  float4 CustomParameters : packoffset(c55);
  float4 OcclusionColor : packoffset(c56);
  float3 HaveSeenFOWTint : packoffset(c57);
  float2 InvEncodePower : packoffset(c58);
  float3 CameraPosition : packoffset(c59);
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
SamplerState SceneColorTexture_s : register(s1);
SamplerState AmbientOcclusionTexture_s : register(s2);
Texture2D<float4> AmbientOcclusionTexture : register(t0);
Texture2D<float4> SceneColorTexture : register(t1);
Texture2D<float4> SceneDepthTexture : register(t2);


#include "../shared.h"

// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float3 v2 : TEXCOORD2,
  float4 v3 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = SceneDepthTexture.SampleLevel(SceneDepthTexture_s, v0.xy, 0).x;
  r0.y = r0.x * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r0.x = cmp(0.999000013 < r0.x);
  r0.y = 1 / r0.y;
  r0.x = r0.x ? 1000000 : r0.y;
  r0.y = -CameraPosition.z + InvEncodePower.y;
  r0.z = min(-0.100000001, v1.z);
  r0.y = r0.y / r0.z;
  r0.x = r0.x + -r0.y;
  r0.zw = AmbientOcclusionTexture.Sample(AmbientOcclusionTexture_s, v0.xy).xz;
  r0.w = 1 + -r0.w;
  r0.x = r0.w * r0.x + r0.y;
  r0.xyw = v1.xyz * r0.xxx;
  r1.x = cmp(0.00999999978 < abs(r0.w));
  r1.x = r1.x ? r0.w : 0.00999999978;
  r1.y = -SharedFogParameter0.y * r1.x;
  r1.x = SharedFogParameter0.y * r1.x;
  r1.y = exp2(r1.y);
  r1.y = 1 + -r1.y;
  r1.x = r1.y / r1.x;
  r1.y = dot(r0.xyw, r0.xyw);
  r1.z = sqrt(r1.y);
  r1.y = rsqrt(r1.y);
  r0.xyw = r1.yyy * r0.xyw;
  r0.x = dot(SharedFogParameter3.xyz, r0.xyw);
  r0.x = -r0.x * 0.499000013 + 0.5;
  r0.x = log2(r0.x);
  r0.x = SharedFogParameter0.z * r0.x;
  r0.x = exp2(r0.x);
  r0.y = -SharedFogParameter0.w + r1.z;
  r0.y = max(0, r0.y);
  r0.y = SharedFogParameter0.x * r0.y;
  r0.y = r0.y * r1.x;
  r0.y = exp2(-r0.y);
  r0.y = min(1, r0.y);
  r0.y = max(SharedFogParameter1.w, r0.y);
  r1.xyz = SceneColorTexture.Sample(SceneColorTexture_s, v0.xy).xyz;
  float3 originalScene = r1.xyz;
  if (CUSTOM_FOW_MODE == 0) {
    // Original: mono-luminance tint (vanilla behavior)
    r0.w = dot(r1.xyz, float3(0.300000012,0.589999974,0.109999999));
    r1.xyz = HaveSeenFOWTint.xyz * r0.www + -OcclusionColor.xyz;
  } else {
    // Alt: chrominance-preserving tint
    r1.xyz = r1.xyz * HaveSeenFOWTint.xyz + -OcclusionColor.xyz;
  }
  r0.w = saturate(1.25 * r0.z);
  r0.z = saturate(-0.800000012 + r0.z);
  r1.xyz = r0.www * r1.xyz + OcclusionColor.xyz;
  r0.w = -r0.z * 5 + 1;
  r0.z = 5 * r0.z;
  o0.w = r0.z * r0.y;
  r1.xyz = r1.xyz * r0.www;
  r1.xyz = r1.xyz * r0.yyy;
  r0.y = 1 + -r0.y;
  r1.xyz = r1.xyz * r0.www;
  r2.xyz = -SharedFogParameter2.xyz + SharedFogParameter1.xyz;
  r0.xzw = r0.xxx * r2.xyz + SharedFogParameter2.xyz;
  o0.xyz = r0.xzw * r0.yyy + r1.xyz;
  if (CUSTOM_FOW_MODE >= 1) {
    o0.xyz = lerp(o0.xyz, originalScene, 0.05f);
  }
  return;
}