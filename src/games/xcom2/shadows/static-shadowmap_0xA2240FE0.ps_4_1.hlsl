// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 11:57:18 2026

cbuffer _Globals : register(b0)
{
  float4x4 ScreenToWorldMatrix : packoffset(c0);
  float4 SpherePositionRadius : packoffset(c4);
  bool bDecompressSceneColor : packoffset(c5);
  float4 SampleOffsets[8] : packoffset(c6);
  float3 ShadowBufferSizeAndSoftTransitionScale : packoffset(c14);
  float2 ShadowTexelSize : packoffset(c15);
  float LightingChannelMask : packoffset(c15.z);
  float MinShadowOpacity : packoffset(c15.w);
  float ShadowFadeFraction : packoffset(c16);
  float4x4 StaticScreenToShadowMatrix : packoffset(c17);
  float4x4 DynamicScreenToShadowMatrix : packoffset(c21);
  float4 LightPositionAndInvRadius : packoffset(c25);
  float4x4 ShadowViewProjectionMatrices[6] : packoffset(c26);
  float ShadowmapResolution : packoffset(c50);
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
  float4 r0,r1,r2,r3,r4,r5,r6;
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
  r1.xyzw = r0.xyxy / r0.wwww;
  r0.x = min(0.999000013, r0.z);
  r2.xyzw = r1.xyzw * ShadowBufferSizeAndSoftTransitionScale.xyxy + float4(-2,-2,-2,-2);
  r0.yz = ShadowBufferSizeAndSoftTransitionScale.xy * r1.zw;
  r0.yz = frac(r0.yz);
  r1.xyzw = floor(r2.xyzw);
  r2.xyzw = float4(0.5,0.5,1.5,0.5) + r1.zwzw;
  r2.xyzw = ShadowTexelSize.xyxy * r2.xyzw;
  r0.w = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r2.xy, 0).x;
  r2.x = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r2.zw, 0).x;
  r2.x = r2.x + -r0.x;
  r2.x = saturate(r2.x * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r0.w = r0.w + -r0.x;
  r3.x = saturate(r0.w * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r4.xyzw = float4(0.5,1.5,1.5,1.5) + r1.zwzw;
  r4.xyzw = ShadowTexelSize.xyxy * r4.xyzw;
  r0.w = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r4.xy, 0).x;
  r4.x = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r4.zw, 0).x;
  r4.x = r4.x + -r0.x;
  r2.y = saturate(r4.x * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r0.w = r0.w + -r0.x;
  r3.y = saturate(r0.w * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r4.xyzw = float4(0.5,2.5,1.5,2.5) + r1.zwzw;
  r4.xyzw = ShadowTexelSize.xyxy * r4.xyzw;
  r0.w = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r4.xy, 0).x;
  r4.x = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r4.zw, 0).x;
  r4.x = r4.x + -r0.x;
  r2.z = saturate(r4.x * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r0.w = r0.w + -r0.x;
  r3.z = saturate(r0.w * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r4.xyzw = -r3.xyyz + r2.xyyz;
  r4.xyzw = r0.yyyy * r4.xyzw + r3.xyyz;
  r3.xy = r4.yw + -r4.xz;
  r3.xy = r0.zz * r3.xy + r4.xz;
  r4.xyzw = float4(2.5,0.5,3.5,0.5) + r1.zwzw;
  r4.xyzw = ShadowTexelSize.xyxy * r4.xyzw;
  r0.w = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r4.xy, 0).x;
  r4.x = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r4.zw, 0).x;
  r4.x = r4.x + -r0.x;
  r4.x = saturate(r4.x * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r0.w = r0.w + -r0.x;
  r5.x = saturate(r0.w * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r6.xyzw = float4(2.5,1.5,3.5,1.5) + r1.zwzw;
  r6.xyzw = ShadowTexelSize.xyxy * r6.xyzw;
  r0.w = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r6.xy, 0).x;
  r6.x = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r6.zw, 0).x;
  r6.x = r6.x + -r0.x;
  r4.y = saturate(r6.x * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r0.w = r0.w + -r0.x;
  r5.y = saturate(r0.w * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r6.xyzw = float4(2.5,2.5,3.5,2.5) + r1.zwzw;
  r6.xyzw = ShadowTexelSize.xyxy * r6.xyzw;
  r0.w = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r6.xy, 0).x;
  r6.x = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r6.zw, 0).x;
  r6.x = r6.x + -r0.x;
  r4.z = saturate(r6.x * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r0.w = r0.w + -r0.x;
  r5.z = saturate(r0.w * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r6.xyzw = r5.xyyz + -r2.xyyz;
  r6.xyzw = r0.yyyy * r6.xyzw + r2.xyyz;
  r2.xy = r6.yw + -r6.xz;
  r2.xy = r0.zz * r2.xy + r6.xz;
  r0.w = r3.x + r2.x;
  r6.xyzw = -r5.xyyz + r4.xyyz;
  r6.xyzw = r0.yyyy * r6.xyzw + r5.xyyz;
  r4.xy = r6.yw + -r6.xz;
  r4.xy = r0.zz * r4.xy + r6.xz;
  r0.w = r4.x + r0.w;
  r0.w = r0.w + r3.y;
  r0.w = r0.w + r2.y;
  r0.w = r0.w + r4.y;
  r6.xyzw = float4(0.5,3.5,1.5,3.5) + r1.zwzw;
  r1.xyzw = float4(2.5,3.5,3.5,3.5) + r1.xyzw;
  r1.xyzw = ShadowTexelSize.xyxy * r1.xyzw;
  r6.xyzw = ShadowTexelSize.xyxy * r6.xyzw;
  r2.x = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r6.xy, 0).x;
  r2.y = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r6.zw, 0).x;
  r2.xy = r2.xy + -r0.xx;
  r2.w = saturate(r2.y * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r3.w = saturate(r2.x * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r2.xy = -r3.zw + r2.zw;
  r2.xy = r0.yy * r2.xy + r3.zw;
  r2.y = r2.y + -r2.x;
  r2.x = r0.z * r2.y + r2.x;
  r0.w = r2.x + r0.w;
  r1.x = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r1.xy, 0).x;
  r1.y = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r1.zw, 0).x;
  r1.y = r1.y + -r0.x;
  r0.x = r1.x + -r0.x;
  r5.w = saturate(r0.x * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r4.w = saturate(r1.y * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r1.xy = -r5.zw + r4.zw;
  r1.xy = r0.yy * r1.xy + r5.zw;
  r1.zw = r5.zw + -r2.zw;
  r0.xy = r0.yy * r1.zw + r2.zw;
  r0.y = r0.y + -r0.x;
  r0.x = r0.z * r0.y + r0.x;
  r0.x = r0.w + r0.x;
  r0.y = r1.y + -r1.x;
  r0.y = r0.z * r0.y + r1.x;
  r0.x = r0.x + r0.y;
  r0.x = saturate(0.111110002 * r0.x);
  r0.y = 1 + -MinShadowOpacity;
  r0.x = r0.x * r0.y + MinShadowOpacity;
  r0.x = r0.x * r0.x + -1;
  r0.x = ShadowFadeFraction * r0.x + 1;
  o0.xyzw = sqrt(r0.xxxx);
  return;
}