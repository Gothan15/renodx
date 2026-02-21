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
  float4x4 ScreenToWorldOffset : packoffset(c19);
  float4x4 TranslatedWorldToView : packoffset(c23);
  float4x4 TranslatedWorldToClip : packoffset(c27);
  float4 ScreenPosToUV : packoffset(c31);
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

SamplerState WorldNormalGBufferTexture_s : register(s0);
SamplerState SpecularGBufferTexture_s : register(s1);
SamplerState DiffuseGBufferTexture_s : register(s2);
SamplerState SceneDepthTexture_s : register(s3);
SamplerState SceneColorTexture_s : register(s4);
SamplerState InputTexture_s : register(s5);
Texture2D<float4> SceneDepthTexture : register(t0);
Texture2D<float4> WorldNormalGBufferTexture : register(t1);
Texture2D<float4> SpecularGBufferTexture : register(t2);
Texture2D<float4> DiffuseGBufferTexture : register(t3);
Texture2D<float4> InputTexture : register(t4);
Texture2D<float4> SceneColorTexture : register(t5);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float3 v1 : TEXCOORD1,
  float4 v2 : SV_Position0,
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
  r0.yzw = WorldNormalGBufferTexture.SampleLevel(WorldNormalGBufferTexture_s, v0.xy, 0).xyz;
  r0.yzw = r0.yzw * float3(2,2,2) + float3(-1,-1,-1);
  r1.x = dot(r0.yzw, r0.yzw);
  r1.x = rsqrt(r1.x);
  r0.yzw = r1.xxx * r0.yzw;
  r1.x = dot(v1.xyz, v1.xyz);
  r1.x = rsqrt(r1.x);
  r1.xyz = v1.xyz * r1.xxx;
  r1.w = dot(r1.xyz, r0.yzw);
  r1.w = r1.w + r1.w;
  r2.xyz = r0.yzw * -r1.www + r1.xyz;
  r0.y = saturate(dot(r0.yzw, -r1.xyz));
  r0.z = dot(r2.xyz, r2.xyz);
  r0.z = rsqrt(r0.z);
  r1.xyz = r2.xyz * r0.zzz;
  r0.zw = InputTexture.SampleLevel(InputTexture_s, v0.xy, 0).zw;
  r0.z = 528 * r0.z;
  r1.xyz = r0.zzz * r1.xyz;
  r1.xyz = v1.xyz * r0.xxx + r1.xyz;
  r2.xyz = TranslatedWorldToClip._m01_m11_m31 * r1.yyy;
  r1.xyw = TranslatedWorldToClip._m00_m10_m30 * r1.xxx + r2.xyz;
  r1.xyz = TranslatedWorldToClip._m02_m12_m32 * r1.zzz + r1.xyw;
  r1.xyz = TranslatedWorldToClip._m03_m13_m33 + r1.xyz;
  r0.xz = r1.xy / r1.zz;
  r0.xz = r0.xz * ScreenPosToUV.xy + ScreenPosToUV.zw;
  r1.xyz = SceneColorTexture.Sample(SceneColorTexture_s, r0.xz).xyz;
  o0.xyz = r1.xyz;
  r0.x = r0.y * -5.55472994 + -6.98316002;
  r0.x = r0.x * r0.y;
  r0.x = exp2(r0.x);
  r0.yz = SpecularGBufferTexture.SampleLevel(SpecularGBufferTexture_s, v0.xy, 0).yw;
  r1.xyzw = float4(1,1,1,1) + r0.yzyz;
  r2.x = 25 * r1.z;
  r2.x = saturate(r2.x);
  r0.y = -r1.x * 0.5 + r2.x;
  r0.x = r0.y * r0.x;
  r0.y = r1.w * 5 + 1;
  r0.x = r0.x / r0.y;
  r0.x = r1.x * 0.5 + r0.x;
  r0.y = saturate(-r1.y * 0.5 + 0.300000012);
  r0.y = 3.29999995 * r0.y;
  r0.y = min(1, r0.y);
  r0.x = r0.w * r0.x;
  r0.x = r0.x * r0.y;
  r0.x = saturate(4 * r0.x);
  r0.y = DiffuseGBufferTexture.SampleLevel(DiffuseGBufferTexture_s, v0.xy, 0).w;
  o0.w = r0.x * r0.y;
  return;
}