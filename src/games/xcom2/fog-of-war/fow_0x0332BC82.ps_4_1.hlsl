// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 14:14:51 2026

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
  float2 InvViewport : packoffset(c17.y);
  float3 LevelVolumeDimensions : packoffset(c18);
  float3 LevelVolumePosition : packoffset(c19);
  float3 VoxelSizeUVW : packoffset(c20);
  float3 CameraPosWS : packoffset(c21);
  float4 NoiseScale : packoffset(c22);
  float4x4 ScreenToWorldOffset : packoffset(c23);
  float4 FOWBorderSettings : packoffset(c27);
  float2 FOWBorderOpacity : packoffset(c28);
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
SamplerState XComFOWVolumeTexture_s : register(s1);
SamplerState RandomAngleTexture_s : register(s2);
Texture2D<float4> SceneDepthTexture : register(t0);
Texture2D<float4> RandomAngleTexture : register(t1);
Texture3D<float4> XComFOWVolumeTexture : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float3 v1 : TEXCOORD1,
  float4 v2 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  const float4 icb[] = { { 0.356658, 0.693281, 0, 0},
                              { -0.335603, 0.217944, 0, 0},
                              { 0.634882, 0.045478, 0, 0},
                              { -0.197866, 0.933725, 0, 0},
                              { 0.099419, -0.343426, 0, 0},
                              { -0.616402, -0.414059, 0, 0},
                              { 0.616187, -0.658345, 0, 0},
                              { -0.147802, -0.968243, 0, 0} };
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = SceneDepthTexture.SampleLevel(SceneDepthTexture_s, v0.xy, 0).x;
  r0.y = cmp(0.999000013 < r0.x);
  r0.x = r0.x * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r0.x = 1 / r0.x;
  r0.x = r0.y ? 1000000 : r0.x;
  r0.yzw = v1.xyz * r0.xxx + CameraPosWS.xyz;
  r0.yzw = -LevelVolumePosition.xyz + r0.yzw;
  r1.xyz = LevelVolumeDimensions.xyz * r0.yzw;
  r2.xy = NoiseScale.xy * v0.xy;
  r2.xy = RandomAngleTexture.Sample(RandomAngleTexture_s, r2.xy).xy;
  r2.xy = r2.xy * float2(2,2) + float2(-1,-1);
  r1.w = dot(r2.xy, r2.xy);
  r1.w = rsqrt(r1.w);
  r2.xy = r2.xy * r1.ww;
  r2.zw = float2(-1,1) * r2.yx;
  r3.z = 0;
  r4.xy = float2(0,0);
  r1.w = 0;
  r3.w = 0;
  while (true) {
    r4.z = cmp((int)r3.w >= 8);
    if (r4.z != 0) break;
    r3.x = dot(r2.xy, icb[r3.w+0].xy);
    r3.y = dot(r2.zw, icb[r3.w+0].xy);
    r5.xyz = r3.xyz * VoxelSizeUVW.xyz + r1.xyz;
    r3.xy = XComFOWVolumeTexture.Sample(XComFOWVolumeTexture_s, r5.xyz).xy;
    r4.z = 1 + -r3.x;
    r4.z = r4.z * 0.75 + 0.25;
    r1.w = r4.z + r1.w;
    r4.xy = r3.xy * r4.zz + r4.xy;
    r3.w = (int)r3.w + 1;
  }
  r1.xy = r4.xy / r1.ww;
  r0.yzw = r0.yzw * LevelVolumeDimensions.xyz + float3(-0.5,-0.5,-0.5);
  r0.yzw = float3(-0.5,-0.5,-0.75) + abs(r0.yzw);
  r0.yzw = max(float3(0,0,0), r0.yzw);
  r0.y = r0.y + r0.z;
  r0.y = r0.y + r0.w;
  r0.z = cmp(0 < r0.y);
  r2.xy = FOWBorderSettings.xz + -r0.yy;
  r2.xy = saturate(FOWBorderSettings.yw * r2.xy);
  r2.z = 1 + -r2.y;
  r2.yw = r2.xz * r2.xz;
  r2.yw = r2.yw * r2.yw;
  r3.x = r2.x * r2.y;
  r1.z = 0;
  r1.zw = -FOWBorderOpacity.xy + r1.xz;
  r3.z = -r2.z * r2.w + 1;
  r1.zw = r3.xz * r1.zw + FOWBorderOpacity.xy;
  r0.w = r1.z + r1.w;
  r0.w = r0.z ? r0.w : r1.x;
  r1.xz = cmp(r0.xx < float2(0,14));
  r1.y = 1 + -r1.y;
  r0.y = -r0.y * 2 + 1;
  r0.y = max(0, r0.y);
  r0.y = r1.y * r0.y;
  o0.z = r1.x ? 1 : r0.y;
  o0.x = r1.x ? 0 : r0.w;
  r0.y = r0.z ? -1 : 1;
  r0.x = r1.z ? 65504 : r0.x;
  o0.y = r0.x * r0.y;
  o0.w = 1;
  return;
}