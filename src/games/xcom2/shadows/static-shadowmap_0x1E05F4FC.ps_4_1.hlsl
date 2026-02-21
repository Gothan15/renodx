// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 14:02:36 2026

cbuffer _Globals : register(b0)
{
  float4x4 ScreenToWorldMatrix : packoffset(c0);
  float4 SpherePositionRadius : packoffset(c4);
  bool bDecompressSceneColor : packoffset(c5);
  float4 SampleOffsets[2] : packoffset(c6);
  float3 ShadowBufferSizeAndSoftTransitionScale : packoffset(c8);
  float2 ShadowTexelSize : packoffset(c9);
  float LightingChannelMask : packoffset(c9.z);
  float MinShadowOpacity : packoffset(c9.w);
  float ShadowFadeFraction : packoffset(c10);
  float4x4 StaticScreenToShadowMatrix : packoffset(c11);
  float4x4 DynamicScreenToShadowMatrix : packoffset(c15);
  float4 LightPositionAndInvRadius : packoffset(c19);
  float4x4 ShadowViewProjectionMatrices[6] : packoffset(c20);
  float ShadowmapResolution : packoffset(c44);
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
SamplerState StaticShadowDepthTexture_s : register(s1);
Texture2D<float4> SceneDepthTexture : register(t0);
Texture2D<float4> StaticShadowDepthTexture : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy / v0.ww;
  r0.zw = r0.xy * ScreenPositionScaleBias.xy + ScreenPositionScaleBias.wz;
  r0.z = SceneDepthTexture.SampleLevel(SceneDepthTexture_s, r0.zw, 0).x;
  r0.w = r0.z * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r0.z = cmp(0.999000013 < r0.z);
  r0.w = 1 / r0.w;
  r0.z = r0.z ? 1000000 : r0.w;
  r0.xy = r0.xy * r0.zz;
  r1.xyzw = StaticScreenToShadowMatrix._m01_m11_m21_m31 * r0.yyyy;
  r1.xyzw = StaticScreenToShadowMatrix._m00_m10_m20_m30 * r0.xxxx + r1.xyzw;
  r0.xyzw = StaticScreenToShadowMatrix._m02_m12_m22_m32 * r0.zzzz + r1.xyzw;
  r0.xyzw = StaticScreenToShadowMatrix._m03_m13_m23_m33 + r0.xyzw;
  r0.xy = r0.xy / r0.ww;
  r0.z = min(0.999000013, r0.z);
  r1.xy = r0.xy * ShadowBufferSizeAndSoftTransitionScale.xy + float2(-1,-1);
  r0.xy = ShadowBufferSizeAndSoftTransitionScale.xy * r0.xy;
  r0.xy = frac(r0.xy);
  r1.xy = floor(r1.xy);
  r1.zw = float2(2.5,2.5) + r1.xy;
  r1.zw = ShadowTexelSize.xy * r1.zw;
  r0.w = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r1.zw, 0).x;
  r0.w = r0.w + -r0.z;
  r2.z = saturate(r0.w * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r3.xyzw = float4(2.5,0.5,2.5,1.5) + r1.xyxy;
  r3.xyzw = ShadowTexelSize.xyxy * r3.xyzw;
  r0.w = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r3.xy, 0).x;
  r1.z = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r3.zw, 0).x;
  r1.z = r1.z + -r0.z;
  r2.y = saturate(r1.z * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r0.w = r0.w + -r0.z;
  r2.x = saturate(r0.w * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r3.xyzw = float4(0.5,2.5,1.5,0.5) + r1.xyxy;
  r3.xyzw = ShadowTexelSize.xyxy * r3.xyzw;
  r0.w = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r3.zw, 0).x;
  r1.z = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r3.xy, 0).x;
  r1.z = r1.z + -r0.z;
  r3.z = saturate(r1.z * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r0.w = r0.w + -r0.z;
  r4.x = saturate(r0.w * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r5.xyzw = float4(1.5,1.5,1.5,2.5) + r1.xyxy;
  r1.xyzw = float4(0.5,0.5,0.5,1.5) + r1.xyxy;
  r1.xyzw = ShadowTexelSize.xyxy * r1.xyzw;
  r5.xyzw = ShadowTexelSize.xyxy * r5.xyzw;
  r0.w = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r5.xy, 0).x;
  r2.w = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r5.zw, 0).x;
  r2.w = r2.w + -r0.z;
  r4.z = saturate(r2.w * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r0.w = r0.w + -r0.z;
  r4.y = saturate(r0.w * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r2.xyzw = -r4.xyyz + r2.xyyz;
  r2.xyzw = r0.xxxx * r2.xyzw + r4.xyyz;
  r2.yw = r2.yw + -r2.xz;
  r2.xy = r0.yy * r2.yw + r2.xz;
  r0.w = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r1.xy, 0).x;
  r1.x = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r1.zw, 0).x;
  r1.x = r1.x + -r0.z;
  r0.z = r0.w + -r0.z;
  r3.x = saturate(r0.z * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r3.y = saturate(r1.x * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r1.xyzw = r4.xyyz + -r3.xyyz;
  r1.xyzw = r0.xxxx * r1.xyzw + r3.xyyz;
  r0.xz = r1.yw + -r1.xz;
  r0.xy = r0.yy * r0.xz + r1.xz;
  r0.x = r0.x + r0.y;
  r0.x = r0.x + r2.x;
  r0.x = r0.x + r2.y;
  r0.x = saturate(0.25 * r0.x);
  r0.y = 1 + -MinShadowOpacity;
  r0.x = r0.x * r0.y + MinShadowOpacity;
  r0.x = r0.x * r0.x + -1;
  r0.x = ShadowFadeFraction * r0.x + 1;
  o0.xyzw = sqrt(r0.xxxx);
  return;
}