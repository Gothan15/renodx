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

SamplerState TransShadowDepthTexture_s : register(s0);
Texture2D<float4> TransShadowDepthTexture : register(t0);


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
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = (uint)v2.x;
  r0.x = r0.x * VoxelSizeWS.z + TranslucencyLightingVolumeMin.z;
  r0.x = VoxelSizeWS.z * 0.5 + r0.x;
  r0.yz = v0.xy / TranslucencyLightingVolumeInvSize.xy;
  r0.yz = TranslucencyLightingVolumeMin.xy + r0.yz;
  r0.yz = -TranslucencyLightingVolumeInvSize.xy * float2(0.5,0.5) + r0.yz;
  r0.w = dot(LightDirection.xyz, LightDirection.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = LightDirection.yzx * r0.www;
  r2.xyzw = WorldToShadowMatrix._m01_m11_m21_m31 * r0.zzzz;
  r2.xyzw = WorldToShadowMatrix._m00_m10_m20_m30 * r0.yyyy + r2.xyzw;
  r0.xyzw = WorldToShadowMatrix._m02_m12_m22_m32 * r0.xxxx + r2.xyzw;
  r0.xyzw = WorldToShadowMatrix._m03_m13_m23_m33 + r0.xyzw;
  r0.xy = r0.xy / r0.ww;
  r2.xy = cmp(r0.xy >= ShadowmapMinMax.xy);
  r2.zw = cmp(ShadowmapMinMax.zw >= r0.xy);
  r2.xy = r2.zw ? r2.xy : 0;
  r0.w = r2.y ? r2.x : 0;
  if (r0.w != 0) {
    r2.xy = ShadowBufferSizeInvSize.xy * r0.xy;
    r2.xy = frac(r2.xy);
    r0.xy = r0.xy * ShadowBufferSizeInvSize.xy + float2(-1,-1);
    r0.xy = floor(r0.xy);
    r3.xyzw = float4(0.5,0.5,0.5,1.5) + r0.xyxy;
    r3.xyzw = ShadowBufferSizeInvSize.zwzw * r3.xyzw;
    r0.w = TransShadowDepthTexture.SampleLevel(TransShadowDepthTexture_s, r3.xy, 0).x;
    r0.w = cmp(r0.z < r0.w);
    r4.x = r0.w ? 1.000000 : 0;
    r0.w = TransShadowDepthTexture.SampleLevel(TransShadowDepthTexture_s, r3.zw, 0).x;
    r0.w = cmp(r0.z < r0.w);
    r4.y = r0.w ? 1.000000 : 0;
    r3.xyzw = float4(0.5,2.5,1.5,0.5) + r0.xyxy;
    r3.xyzw = ShadowBufferSizeInvSize.zwzw * r3.xyzw;
    r0.w = TransShadowDepthTexture.SampleLevel(TransShadowDepthTexture_s, r3.xy, 0).x;
    r0.w = cmp(r0.z < r0.w);
    r4.z = r0.w ? 1.000000 : 0;
    r0.w = TransShadowDepthTexture.SampleLevel(TransShadowDepthTexture_s, r3.zw, 0).x;
    r0.w = cmp(r0.z < r0.w);
    r3.x = r0.w ? 1.000000 : 0;
    r5.xyzw = float4(1.5,1.5,1.5,2.5) + r0.xyxy;
    r5.xyzw = ShadowBufferSizeInvSize.zwzw * r5.xyzw;
    r0.w = TransShadowDepthTexture.SampleLevel(TransShadowDepthTexture_s, r5.xy, 0).x;
    r0.w = cmp(r0.z < r0.w);
    r3.y = r0.w ? 1.000000 : 0;
    r0.w = TransShadowDepthTexture.SampleLevel(TransShadowDepthTexture_s, r5.zw, 0).x;
    r0.w = cmp(r0.z < r0.w);
    r3.z = r0.w ? 1.000000 : 0;
    r5.xyzw = float4(2.5,0.5,2.5,1.5) + r0.xyxy;
    r5.xyzw = ShadowBufferSizeInvSize.zwzw * r5.xyzw;
    r0.w = TransShadowDepthTexture.SampleLevel(TransShadowDepthTexture_s, r5.xy, 0).x;
    r0.w = cmp(r0.z < r0.w);
    r6.x = r0.w ? 1.000000 : 0;
    r0.w = TransShadowDepthTexture.SampleLevel(TransShadowDepthTexture_s, r5.zw, 0).x;
    r0.w = cmp(r0.z < r0.w);
    r6.y = r0.w ? 1.000000 : 0;
    r0.xy = float2(2.5,2.5) + r0.xy;
    r0.xy = ShadowBufferSizeInvSize.zw * r0.xy;
    r0.x = TransShadowDepthTexture.SampleLevel(TransShadowDepthTexture_s, r0.xy, 0).x;
    r0.x = cmp(r0.z < r0.x);
    r6.z = r0.x ? 1.000000 : 0;
    r0.xyzw = r3.xyyz + -r4.xyyz;
    r0.xyzw = r2.xxxx * r0.xyzw + r4.xyyz;
    r0.yw = r0.yw + -r0.xz;
    r0.xy = r2.yy * r0.yw + r0.xz;
    r4.xyzw = r6.xyyz + -r3.xyyz;
    r3.xyzw = r2.xxxx * r4.xyzw + r3.xyyz;
    r0.zw = r3.yw + -r3.xz;
    r0.zw = r2.yy * r0.zw + r3.xz;
    r0.x = r0.x + r0.y;
    r0.x = r0.x + r0.z;
    r0.x = r0.x + r0.w;
    r0.x = saturate(0.25 * r0.x);
    r0.y = 1 + -MinShadowOpacity;
    r0.x = r0.x * r0.y + MinShadowOpacity;
  } else {
    r0.x = 1;
  }
  r0.x = saturate(r0.x);
  r0.xyz = LightColorAndFalloff.xyz * r0.xxx;
  r1.yzw = float3(-0.488602996,0.488602996,-0.488602996) * r1.xyz;
  r1.x = 0.282094985;
  o0.xyzw = r1.xyzw * r0.xxxx;
  o1.xyzw = r1.xyzw * r0.yyyy;
  o2.xyzw = r1.xyzw * r0.zzzz;
  return;
}