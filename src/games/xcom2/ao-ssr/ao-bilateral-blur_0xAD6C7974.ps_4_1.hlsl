// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 11:57:18 2026

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

SamplerState AmbientOcclusionTexture_s : register(s0);
Texture2D<float4> AmbientOcclusionTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -CustomParameters.zw + v0.xy;
  r0.xyzw = AmbientOcclusionTexture.Sample(AmbientOcclusionTexture_s, r0.xy).xyzw;
  r1.xyzw = AmbientOcclusionTexture.Sample(AmbientOcclusionTexture_s, v0.xy).xyzw;
  r0.y = -abs(r1.y) + abs(r0.y);
  r0.y = r0.y * r0.y;
  r2.x = FilterParameters.y * abs(r1.y);
  r2.x = max(1, r2.x);
  r2.x = min(1000, r2.x);
  r2.x = FilterParameters.x * r2.x;
  r2.x = r2.x * r2.x;
  r0.y = cmp(r0.y < r2.x);
  r0.y = r0.y ? 1.01999998 : 0.0199999996;
  r0.xzw = r0.xzw * r0.yyy;
  r2.yz = CustomParameters.zw * float2(-2,-2) + v0.xy;
  r3.xyzw = AmbientOcclusionTexture.Sample(AmbientOcclusionTexture_s, r2.yz).xyzw;
  r2.y = abs(r3.y) + -abs(r1.y);
  r2.y = r2.y * r2.y;
  r2.y = cmp(r2.y < r2.x);
  r2.y = r2.y ? 1.01999998 : 0.0199999996;
  r0.xzw = r3.xzw * r2.yyy + r0.xzw;
  r0.y = r2.y + r0.y;
  r2.y = cmp(0 < r2.x);
  r2.y = r2.y ? 1.01999998 : 0.0199999996;
  r0.xzw = r1.xzw * r2.yyy + r0.xzw;
  r0.y = r2.y + r0.y;
  r1.xz = CustomParameters.zw + v0.xy;
  r3.xyzw = AmbientOcclusionTexture.Sample(AmbientOcclusionTexture_s, r1.xz).xyzw;
  r1.x = abs(r3.y) + -abs(r1.y);
  o0.y = r1.y;
  r1.x = r1.x * r1.x;
  r1.x = cmp(r1.x < r2.x);
  r1.x = r1.x ? 1.01999998 : 0.0199999996;
  r0.xzw = r3.xzw * r1.xxx + r0.xzw;
  r0.y = r1.x + r0.y;
  o0.xzw = r0.xzw / r0.yyy;
  return;
}