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
SamplerState AOInputTexture_s : register(s4);
SamplerState AmbientCubemap_s : register(s5);
SamplerState EnvBRDFTexture_s : register(s6);
Texture2D<float4> SceneDepthTexture : register(t0);
Texture2D<float4> WorldNormalGBufferTexture : register(t1);
Texture2D<float4> DiffuseGBufferTexture : register(t2);
Texture2D<float4> SpecularGBufferTexture : register(t3);
Texture2D<float4> AOInputTexture : register(t4);
TextureCube<float4> AmbientCubemap : register(t5);
Texture2D<float4> EnvBRDFTexture : register(t6);


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
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy / v1.ww;
  r0.zw = InvViewport.xy * v3.xy;
  r1.x = SceneDepthTexture.SampleLevel(SceneDepthTexture_s, r0.zw, 0).x;
  r1.y = r1.x * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r1.x = cmp(0.999000013 < r1.x);
  r1.y = 1 / r1.y;
  r1.x = r1.x ? 1000000 : r1.y;
  r0.xy = r1.xx * r0.xy;
  r1.yzw = ScreenToWorldMatrix._m01_m21_m11 * r0.yyy;
  r1.yzw = ScreenToWorldMatrix._m00_m20_m10 * r0.xxx + r1.yzw;
  r1.xyz = ScreenToWorldMatrix._m02_m22_m12 * r1.xxx + r1.yzw;
  r1.xyz = ScreenToWorldMatrix._m03_m23_m13 + r1.xyz;
  r1.xyz = -CameraPosWS.xzy + r1.xyz;
  r0.x = dot(r1.xyz, r1.xyz);
  r0.x = rsqrt(r0.x);
  r1.xyz = r1.xyz * r0.xxx;
  r2.xyzw = WorldNormalGBufferTexture.SampleLevel(WorldNormalGBufferTexture_s, r0.zw, 0).xyzw;
  r2.xyz = r2.xzy * float3(2,2,2) + float3(-1,-1,-1);
  r0.x = 255 * r2.w;
  r0.x = ceil(r0.x);
  r0.x = (uint)r0.x;
  r0.xy = (int2)r0.xx & int2(64,8);
  r1.w = dot(r2.xyz, r2.xyz);
  r1.w = rsqrt(r1.w);
  r2.xyz = r2.xyz * r1.www;
  r1.w = dot(r1.xyz, r2.xyz);
  r1.w = r1.w + r1.w;
  r3.xyz = r2.xyz * -r1.www + r1.xyz;
  r1.x = saturate(dot(r2.xyz, -r1.xyz));
  r2.xyz = float3(-1,1,-1) * r2.xyz;
  r2.xyz = AmbientCubemap.SampleLevel(AmbientCubemap_s, r2.xyz, AmbientIntensity.z).xyz;
  r2.xyz = AmbientIntensity.xxx * r2.xyz;
  float3 skyLight = r2.xyz;
  r3.xyz = float3(-1,1,-1) * r3.xyz;
  r4.xyzw = SpecularGBufferTexture.SampleLevel(SpecularGBufferTexture_s, r0.zw, 0).xyzw;
  r4.xyzw = float4(1,1,1,1) + r4.xyzw;
  r1.z = -r4.w * 0.5 + 1;
  r4.xyzw = float4(0.5,0.5,0.5,0.5) * r4.xyzw;
  r1.z = log2(r1.z);
  r1.z = 0.550000012 * r1.z;
  r1.z = exp2(r1.z);
  r1.z = 1 + -r1.z;
  r0.x = r0.x ? r1.z : r4.w;
  float roughness = r0.x;
  r1.z = AmbientIntensity.z * r0.x;
  r1.y = 1 + -r0.x;
  r1.xy = EnvBRDFTexture.Sample(EnvBRDFTexture_s, r1.xy).xy;
  r1.xyw = r4.xyz * r1.xxx + r1.yyy;
  r3.xyz = AmbientCubemap.SampleLevel(AmbientCubemap_s, r3.xyz, r1.z).xyz;
  r3.xyz = AmbientIntensity.yyy * r3.xyz;
  r1.xyz = r3.xyz * r1.xyw;
  r3.xyz = CharSpecAndDiffMod.yyy * r1.xyz;
  r1.xyz = r0.yyy ? r3.xyz : r1.xyz;
  r3.xyz = CharSpecAndDiffMod.xxx * r2.xyz;
  r2.xyz = r0.yyy ? r3.xyz : r2.xyz;
  r3.xyzw = DiffuseGBufferTexture.SampleLevel(DiffuseGBufferTexture_s, r0.zw, 0).xyzw;
  r0.x = AOInputTexture.SampleLevel(AOInputTexture_s, r0.zw, 0).w;
  r0.x = 1 + -r0.x;
  float aoFactor = r0.x;
  r0.yzw = r3.xyz * r2.xyz;
  r0.xyz = r0.xxx * r1.xyz + r0.yzw;
  o0.xyz = r0.xyz * r3.www;

  if (CUSTOM_CUBEMAP_MODE >= 1) {
    // Skylight luminance-based cubemap modulation:
    // Use diffuse probe luminance as incoming light intensity proxy.
    float skyLightLum = max(0, dot(skyLight, float3(0.2126, 0.7152, 0.0722)));
    float cubemapMod = smoothstep(0.0, 0.25, skyLightLum)
                     * lerp(0.5, 1.0, saturate(roughness))
                     * lerp(0.4, 1.0, saturate(aoFactor));
    o0.xyz *= lerp(0.3, 1.0, cubemapMod);
    o0.xyz = max(0, o0.xyz);
  }

  o0.w = 1;
  return;
}