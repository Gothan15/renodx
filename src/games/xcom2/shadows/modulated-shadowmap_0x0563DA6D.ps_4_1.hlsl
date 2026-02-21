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
SamplerState DynamicShadowDepthTexture_s : register(s2);
Texture2D<float4> SceneDepthTexture : register(t0);
Texture2D<float4> StaticShadowDepthTexture : register(t1);
Texture2D<float4> DynamicShadowDepthTexture : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
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
  r1.xyzw = StaticScreenToShadowMatrix._m02_m12_m22_m32 * r0.zzzz + r1.xyzw;
  r1.xyzw = StaticScreenToShadowMatrix._m03_m13_m23_m33 + r1.xyzw;
  r1.xy = r1.xy / r1.ww;
  r0.w = min(0.999000013, r1.z);
  r1.zw = r1.xy * ShadowBufferSizeAndSoftTransitionScale.xy + float2(-1,-1);
  r1.xy = ShadowBufferSizeAndSoftTransitionScale.xy * r1.xy;
  r2.xy = frac(r1.xy);
  r1.xy = floor(r1.zw);
  r3.xyzw = float4(0.5,0.5,0.5,1.5) + r1.xyxy;
  r3.xyzw = ShadowTexelSize.xyxy * r3.xyzw;
  r1.z = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r3.xy, 0).x;
  r1.w = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r3.zw, 0).x;
  r1.zw = r1.zw + -r0.ww;
  r3.z = saturate(r1.w * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r3.x = saturate(r1.z * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r4.xyzw = DynamicScreenToShadowMatrix._m01_m11_m21_m31 * r0.yyyy;
  r4.xyzw = DynamicScreenToShadowMatrix._m00_m10_m20_m30 * r0.xxxx + r4.xyzw;
  r4.xyzw = DynamicScreenToShadowMatrix._m02_m12_m22_m32 * r0.zzzz + r4.xyzw;
  r4.xyzw = DynamicScreenToShadowMatrix._m03_m13_m23_m33 + r4.xyzw;
  r0.xy = r4.xy / r4.ww;
  r0.z = min(0.999000013, r4.z);
  r1.zw = r0.xy * ShadowBufferSizeAndSoftTransitionScale.xy + float2(-1,-1);
  r0.xy = ShadowBufferSizeAndSoftTransitionScale.xy * r0.xy;
  r2.zw = frac(r0.xy);
  r0.xy = floor(r1.zw);
  r4.xyzw = float4(0.5,0.5,0.5,1.5) + r0.xyxy;
  r4.xyzw = ShadowTexelSize.xyxy * r4.xyzw;
  r1.z = DynamicShadowDepthTexture.SampleLevel(DynamicShadowDepthTexture_s, r4.xy, 0).x;
  r1.w = DynamicShadowDepthTexture.SampleLevel(DynamicShadowDepthTexture_s, r4.zw, 0).x;
  r1.zw = r1.zw + -r0.zz;
  r3.w = saturate(r1.w * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r3.y = saturate(r1.z * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r4.xyzw = float4(0.5,2.5,1.5,0.5) + r1.xyxy;
  r4.xyzw = ShadowTexelSize.xyxy * r4.xyzw;
  r1.z = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r4.zw, 0).x;
  r1.w = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r4.xy, 0).x;
  r1.zw = r1.zw + -r0.ww;
  r4.z = saturate(r1.w * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r5.x = saturate(r1.z * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r6.xyzw = float4(0.5,2.5,1.5,0.5) + r0.xyxy;
  r6.xyzw = ShadowTexelSize.xyxy * r6.xyzw;
  r1.z = DynamicShadowDepthTexture.SampleLevel(DynamicShadowDepthTexture_s, r6.zw, 0).x;
  r1.w = DynamicShadowDepthTexture.SampleLevel(DynamicShadowDepthTexture_s, r6.xy, 0).x;
  r1.zw = r1.zw + -r0.zz;
  r4.w = saturate(r1.w * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r5.y = saturate(r1.z * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r6.xyzw = float4(1.5,1.5,1.5,2.5) + r1.xyxy;
  r6.xyzw = ShadowTexelSize.xyxy * r6.xyzw;
  r1.z = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r6.xy, 0).x;
  r1.w = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r6.zw, 0).x;
  r1.zw = r1.zw + -r0.ww;
  r6.z = saturate(r1.w * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r5.z = saturate(r1.z * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r7.xyzw = float4(1.5,1.5,1.5,2.5) + r0.xyxy;
  r7.xyzw = ShadowTexelSize.xyxy * r7.xyzw;
  r1.z = DynamicShadowDepthTexture.SampleLevel(DynamicShadowDepthTexture_s, r7.xy, 0).x;
  r1.w = DynamicShadowDepthTexture.SampleLevel(DynamicShadowDepthTexture_s, r7.zw, 0).x;
  r1.zw = r1.zw + -r0.zz;
  r6.w = saturate(r1.w * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r5.w = saturate(r1.z * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r7.xyzw = r5.xyzw + -r3.xyzw;
  r7.xyzw = r2.xzxz * r7.xyzw + r3.xyzw;
  r4.xy = r3.zw;
  r1.zw = r7.zw + -r7.xy;
  r1.zw = r2.yw * r1.zw + r7.xy;
  r6.xy = r5.zw;
  r3.xyzw = r6.xyzw + -r4.xyzw;
  r3.xyzw = r2.xzxz * r3.xyzw + r4.xyzw;
  r3.zw = r3.zw + -r3.xy;
  r3.xy = r2.yw * r3.zw + r3.xy;
  r1.zw = r3.xy + r1.zw;
  r3.xyzw = float4(2.5,0.5,2.5,1.5) + r1.xyxy;
  r1.xy = float2(2.5,2.5) + r1.xy;
  r1.xy = ShadowTexelSize.xy * r1.xy;
  r1.x = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r1.xy, 0).x;
  r1.x = r1.x + -r0.w;
  r4.z = saturate(r1.x * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r3.xyzw = ShadowTexelSize.xyxy * r3.xyzw;
  r1.x = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r3.xy, 0).x;
  r1.y = StaticShadowDepthTexture.SampleLevel(StaticShadowDepthTexture_s, r3.zw, 0).x;
  r1.y = r1.y + -r0.w;
  r0.w = r1.x + -r0.w;
  r3.x = saturate(r0.w * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r3.z = saturate(r1.y * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r7.xyzw = float4(2.5,0.5,2.5,1.5) + r0.xyxy;
  r0.xy = float2(2.5,2.5) + r0.xy;
  r0.xy = ShadowTexelSize.xy * r0.xy;
  r0.x = DynamicShadowDepthTexture.SampleLevel(DynamicShadowDepthTexture_s, r0.xy, 0).x;
  r0.x = r0.x + -r0.z;
  r4.w = saturate(r0.x * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r7.xyzw = ShadowTexelSize.xyxy * r7.xyzw;
  r0.x = DynamicShadowDepthTexture.SampleLevel(DynamicShadowDepthTexture_s, r7.xy, 0).x;
  r0.y = DynamicShadowDepthTexture.SampleLevel(DynamicShadowDepthTexture_s, r7.zw, 0).x;
  r0.xy = r0.xy + -r0.zz;
  r3.y = saturate(r0.x * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r3.w = saturate(r0.y * ShadowBufferSizeAndSoftTransitionScale.z + 1);
  r0.xyzw = r3.xyzw + -r5.xyzw;
  r4.xy = r3.zw;
  r3.xyzw = r4.xyzw + -r6.xyzw;
  r3.xyzw = r2.xzxz * r3.xyzw + r6.xyzw;
  r0.xyzw = r2.xzxz * r0.xyzw + r5.xyzw;
  r0.zw = r0.zw + -r0.xy;
  r0.xy = r2.yw * r0.zw + r0.xy;
  r0.xy = r1.zw + r0.xy;
  r0.zw = r3.zw + -r3.xy;
  r0.zw = r2.yw * r0.zw + r3.xy;
  r0.xy = r0.xy + r0.zw;
  r0.xy = saturate(float2(0.25,0.25) * r0.xy);
  r0.x = min(r0.x, r0.y);
  r0.y = 1 + -MinShadowOpacity;
  r0.x = r0.x * r0.y + MinShadowOpacity;
  r0.x = r0.x * r0.x + -1;
  r0.x = ShadowFadeFraction * r0.x + 1;
  o0.xyzw = sqrt(r0.xxxx);
  return;
}