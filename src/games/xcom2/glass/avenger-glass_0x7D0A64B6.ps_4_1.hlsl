// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 23:29:53 2026

#include "../shared.h"

cbuffer _Globals : register(b0)
{
  float4x4 LocalToWorld : packoffset(c0);
  float4x4 ScreenToWorldMatrix : packoffset(c4);
  float4 SpherePositionRadius : packoffset(c8);
  float TwoSidedSign : packoffset(c9);
  bool bDecompressSceneColor : packoffset(c9.y);
  float4 PackedParameters : packoffset(c10);
  float4 MinMaxBlurClamp : packoffset(c11);
  float4 CutoutParam : packoffset(c12);
  float4x4 InvViewProjectionMatrix : packoffset(c13);
  float3 CameraWorldPos : packoffset(c17);
  float3 CameraWorldDirection : packoffset(c18);
  float3 DirectionalLightWorldVector : packoffset(c19);
  float4 ObjectWorldPositionAndRadius : packoffset(c20);
  float3 ObjectOrientation : packoffset(c21);
  float3 ObjectPostProjectionPosition : packoffset(c22);
  float3 ObjectNDCPosition : packoffset(c23);
  float4 ObjectMacroUVScales : packoffset(c24);
  float4 ObjectBoxExtent : packoffset(c25);
  float4 WindDirectionAndSpeed : packoffset(c26);
  float SSSEnabled : packoffset(c27);
  bool bForceLPVBilinearSampling : packoffset(c27.y);
  float3x3 LocalToWorldMatrix : packoffset(c28);
  float4x4 WorldToLocalMatrix : packoffset(c31);
  float3x3 WorldToViewMatrix : packoffset(c35);
  float3x3 ViewToWorldMatrix : packoffset(c38);
  float3x3 WorldToProjMatrix : packoffset(c41);
  float4 UniformPixelVector_0 : packoffset(c44);
  float4 UniformPixelVector_1 : packoffset(c45);
  float4 UniformPixelVector_2 : packoffset(c46);
  float4 UniformPixelScalars_0 : packoffset(c47);
  float3 TemporalAAParameters : packoffset(c48);
  float4x4 PreviousLocalToWorld : packoffset(c49);
  float LocalToWorldRotDeterminantFlip : packoffset(c53);
  float3x3 WorldToLocal : packoffset(c54);
  float4 LightmapCoordinateScaleBias : packoffset(c57);
  float4 ShadowmapCoordinateScaleBias : packoffset(c58);
  float4 LightColorAndFalloffExponent : packoffset(c59);
  float3 DistanceFieldParameters : packoffset(c60);
  float4x4 ScreenToShadowMatrix : packoffset(c61);
  float4 ShadowBufferAndTexelSize : packoffset(c65);
  float ShadowOverrideFactor : packoffset(c66);
  bool bReceiveDynamicShadows : packoffset(c66.y);
  bool bEnableDistanceShadowFading : packoffset(c66.z);
  float2 DistanceFadeParameters : packoffset(c67);
  float4 FOWBorderSettings : packoffset(c68);
  float2 FOWBorderOpacity : packoffset(c69);
  bool bUseTranslucentFOW : packoffset(c69.z);
  float4 ExponentialFog : packoffset(c70);
  float3 OcclusionColor : packoffset(c71);
  float3 HaveSeenTintColor : packoffset(c72);
  float4 DeferredRenderingParameters : packoffset(c73);
  float2 TemporalAAParametersPS : packoffset(c74);
  bool bDynamicDirectionalLight : packoffset(c74.z);
  bool bDynamicSpotLight : packoffset(c74.w);
  float4 LightChannelMask : packoffset(c75);
  float3 SpotDirection : packoffset(c76);
  float2 SpotAngles : packoffset(c77);
  float3 UpperSkyColor : packoffset(c78);
  float3 LowerSkyColor : packoffset(c79);
  float4 AmbientColorAndSkyFactor : packoffset(c80);
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

SamplerState PixelTexture2D_0_s : register(s0);
SamplerState XComFOWVolumeTexture_s : register(s1);
SamplerState TransLightVolume_RedSH_s : register(s2);
SamplerState TransLightVolume_GreenSH_s : register(s3);
SamplerState TransLightVolume_BlueSH_s : register(s4);
SamplerState AmbientCubemap_s : register(s5);
Texture2D<float4> PixelTexture2D_0 : register(t0);
Texture3D<float4> TransLightVolume_RedSH : register(t1);
Texture3D<float4> TransLightVolume_GreenSH : register(t2);
Texture3D<float4> TransLightVolume_BlueSH : register(t3);
TextureCube<float4> AmbientCubemap : register(t4);
Texture3D<float4> XComFOWVolumeTexture : register(t5);


// 3Dmigoto declarations
#define cmp -


void main(
  linear float4 v0 : TEXCOORD10,
  linear float4 v1 : TEXCOORD11,
  float4 v2 : COLOR0,
  float4 v3 : TEXCOORD0,
  float4 v4 : TEXCOORD4,
  float4 v5 : TEXCOORD6,
  float4 v6 : TEXCOORD7,
  float4 v7 : TEXCOORD5,
  uint v8 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = PixelTexture2D_0.SampleBias(PixelTexture2D_0_s, v3.xy, 0).xy;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r0.w = dot(r0.xy, r0.xy);
  r0.w = min(1, r0.w);
  r0.w = 1 + -r0.w;
  r0.z = sqrt(r0.w);
  r0.xyz = float3(0.200000003,0.200000003,1) * r0.xyz;
  r0.w = dot(r0.xyz, r0.xyz);
  r0.w = sqrt(r0.w);
  r0.xyz = r0.xyz / r0.www;
  r0.w = dot(r0.xyz, r0.xyz);
  r0.w = rsqrt(r0.w);
  r0.xyz = r0.xyz * r0.www;
  r0.w = v8.x ? 1 : -1;
  r0.w = TwoSidedSign * r0.w;
  r0.xyz = r0.xyz * r0.www;
  r0.w = dot(v1.xyz, v1.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = v1.xyz * r0.www;
  r0.w = dot(v0.xyz, v0.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = v0.xyz * r0.www;
  r3.xyz = r2.yzx * r1.zxy;
  r3.xyz = r1.yzx * r2.zxy + -r3.xyz;
  r1.y = dot(r1.xyz, r0.xyz);
  r1.x = dot(r2.xyz, r0.xyz);
  r2.xyz = v1.www * r3.xyz;
  r1.z = dot(r2.xyz, r0.xyz);
  r0.x = dot(r1.xyz, r1.xyz);
  r0.x = rsqrt(r0.x);
  r0.xyz = r1.xyz * r0.xxx;
  r0.w = dot(-v7.xyz, -v7.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = -v7.xzy * r0.www;
  r0.w = dot(r1.xyz, r0.xyz);
  r1.w = r0.w + r0.w;
  r0.w = saturate(r0.w);
  r1.xyz = r0.xyz * -r1.www + r1.xyz;
  r2.yzw = float3(-0.511663854,0.511663854,-0.511663854) * r0.zyx;
  r0.x = dot(r1.xyz, r1.xyz);
  r0.x = rsqrt(r0.x);
  r0.xyz = r1.xyz * r0.xxx;
  r0.xyz = float3(1,-1,1) * r0.xyz;
  r1.x = 7 * UniformPixelScalars_0.x;
  float cubemapMipBias = (CUSTOM_CUBEMAP_MODE >= 1) ? 0.1 : 0.0;
  float cubemapMip = r1.x + cubemapMipBias;
  float3 reflectionDir = r0.xyz;  // Save reflection direction before it gets overwritten
  r0.xyz = AmbientCubemap.SampleLevel(AmbientCubemap_s, reflectionDir, cubemapMip).xyz;

  // Separate blur: blend with a higher-mip (softer) sample of the same direction
  if (CUSTOM_CUBEMAP_MODE >= 1) {
    float3 blurred = AmbientCubemap.SampleLevel(AmbientCubemap_s, reflectionDir, cubemapMip + 1.5).xyz;
    r0.xyz = lerp(r0.xyz, blurred, 0.5);
  }
  r1.x = r0.w * -5.55472994 + -6.98316002;
  r0.w = r1.x * r0.w;
  r0.w = exp2(r0.w);
  r1.xyz = UniformPixelVector_2.xyz * SpecularOverrideParameter.www + SpecularOverrideParameter.xyz;
  r1.w = saturate(50 * r1.y);
  r1.w = r1.w + -r1.y;
  r0.w = r1.w * r0.w + r1.y;
  r0.xyz = r0.www * r0.xyz;
  r0.w = 1 + -r0.w;
  r3.xyz = CameraWorldPos.xyz + v7.xyz;
  r3.xyw = -TransLightingVolumeMin.xyz + r3.xyz;
  r4.xy = cmp(CutoutParam.xy < r3.zz);
  r5.xyz = TransLightingVolumeInvSize.xyz * r3.xyw;
  r3.xyz = r3.xyw * TransLightingVolumeInvSize.xyz + float3(-0.5,-0.5,-0.5);
  r3.xyz = float3(-0.5,-0.5,-0.75) + abs(r3.xyz);
  r3.xyz = max(float3(0,0,0), r3.xyz);
  r6.xyzw = TransLightVolume_RedSH.Sample(TransLightVolume_RedSH_s, r5.xyz).xyzw;
  r2.x = 0.354491025;
  r6.x = dot(r6.xyzw, r2.xyzw);
  r7.xyzw = TransLightVolume_GreenSH.Sample(TransLightVolume_GreenSH_s, r5.xyz).xyzw;
  r6.y = dot(r7.xyzw, r2.xyzw);
  r7.xyzw = TransLightVolume_BlueSH.Sample(TransLightVolume_BlueSH_s, r5.xyz).xyzw;
  r4.z = XComFOWVolumeTexture.Sample(XComFOWVolumeTexture_s, r5.xyz).x;
  r6.z = dot(r7.xyzw, r2.xyzw);
  r2.xyz = max(float3(0,0,0), r6.xyz);

  // Skylight luminance-based cubemap modulation (r0.xyz still holds cubemap*fresnel from above)
  if (CUSTOM_CUBEMAP_MODE >= 1) {
    float skyLightLum = max(0, dot(r2.xyz, float3(0.2126, 0.7152, 0.0722)));
    float roughness = UniformPixelScalars_0.x;
    float cubemapMod = smoothstep(0.0, 0.25, skyLightLum)
                     * lerp(0.5, 1.0, saturate(roughness));
    r0.xyz *= lerp(0.3, 1.0, cubemapMod) * 0.5;
    r0.xyz = max(0, r0.xyz);
  }

  r5.xyz = float3(1,1,1) + -UniformPixelVector_0.xyz;
  r5.xyz = UniformPixelVector_1.xyz * r5.xyz;
  r5.xyz = r5.xyz * DiffuseOverrideParameter.www + DiffuseOverrideParameter.xyz;
  r6.xyz = r5.xyz * AmbientColorAndSkyFactor.xyz + UniformPixelVector_0.xyz;
  r2.xyz = r5.xyz * r2.xyz + r6.xyz;
  r5.xyz = r2.xyz * r0.www;
  r0.xyz = r0.xyz * r1.xyz + r5.xyz;
  r0.xyz = r2.xyz + r0.xyz;
  r0.w = saturate(dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999)));
  r1.xyz = HaveSeenTintColor.xyz * r0.www;
  r0.w = r3.x + r3.y;
  r0.w = r0.w + r3.z;
  r1.w = cmp(0 < r0.w);
  r2.xy = FOWBorderSettings.xz + -r0.ww;
  r2.xy = saturate(FOWBorderSettings.yw * r2.xy);
  r2.z = 1 + -r2.y;
  r2.yw = r2.xz * r2.xz;
  r2.yw = r2.yw * r2.yw;
  r3.x = r2.x * r2.y;
  r3.z = -r2.z * r2.w + 1;
  r4.w = 0;
  r2.xy = -FOWBorderOpacity.xy + r4.zw;
  r2.xy = r3.xz * r2.xy + FOWBorderOpacity.xy;
  r0.w = r2.x + r2.y;
  r0.w = r1.w ? r0.w : r4.z;
  r1.w = -0.800000012 + r0.w;
  r0.w = saturate(1.25 * r0.w);
  r2.z = 1 + -r0.w;
  r2.x = saturate(5 * r1.w);
  r0.w = 1 + -r2.x;
  r0.w = r0.w + -r2.z;
  r2.y = max(0, r0.w);
  r2.xyz = bUseTranslucentFOW ? r2.xyz : float3(1,0,0);
  r1.xyz = r2.yyy * r1.xyz;
  r0.xyz = r0.xyz * r2.xxx + r1.xyz;
  r0.xyz = OcclusionColor.xyz * r2.zzz + r0.xyz;
  r0.w = 1 + -r2.z;
  r0.w = 0.5 * r0.w;
  r0.xyz = -ExponentialFog.xyz + r0.xyz;
  r0.xyz = ExponentialFog.www * r0.xyz + ExponentialFog.xyz;
  o0.xyz = r0.xyz * v4.www + v4.xyz;
  r0.x = CutoutParam.w * CutoutParam.w;
  r0.x = r4.y ? r0.x : 1;
  r0.x = r4.x ? 0 : r0.x;
  o0.w = r0.w * r0.x;
  return;
}