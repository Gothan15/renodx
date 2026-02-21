// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 19:58:52 2026

cbuffer _Globals : register(b0)
{
  float4x4 LocalToWorld : packoffset(c0);
  float4x4 ScreenToWorldMatrix : packoffset(c4);
  float4 SpherePositionRadius : packoffset(c8);
  bool bDecompressSceneColor : packoffset(c9);
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
  float OcclusionPercentage : packoffset(c27);
  float SSSEnabled : packoffset(c27.y);
  bool bForceLPVBilinearSampling : packoffset(c27.z);
  float3x3 LocalToWorldMatrix : packoffset(c28);
  float4x4 WorldToLocalMatrix : packoffset(c31);
  float3x3 WorldToViewMatrix : packoffset(c35);
  float3x3 ViewToWorldMatrix : packoffset(c38);
  float3x3 WorldToProjMatrix : packoffset(c41);
  float4 UniformPixelVector_0 : packoffset(c44);
  float4 UniformPixelScalars_0 : packoffset(c45);
  float3 TemporalAAParameters : packoffset(c46);
  float4 CameraRight : packoffset(c47);
  float4 CameraUp : packoffset(c48);
  float4 LightColorAndFalloffExponent : packoffset(c49);
  float3 DistanceFieldParameters : packoffset(c50);
  float4x4 ScreenToShadowMatrix : packoffset(c51);
  float4 ShadowBufferAndTexelSize : packoffset(c55);
  float ShadowOverrideFactor : packoffset(c56);
  bool bReceiveDynamicShadows : packoffset(c56.y);
  bool bEnableDistanceShadowFading : packoffset(c56.z);
  float2 DistanceFadeParameters : packoffset(c57);
  float4 FOWBorderSettings : packoffset(c58);
  float2 FOWBorderOpacity : packoffset(c59);
  bool bUseTranslucentFOW : packoffset(c59.z);
  float4 ExponentialFog : packoffset(c60);
  float3 OcclusionColor : packoffset(c61);
  float3 HaveSeenTintColor : packoffset(c62);
  float4 DeferredRenderingParameters : packoffset(c63);
  float2 TemporalAAParametersPS : packoffset(c64);
  bool bDynamicDirectionalLight : packoffset(c64.z);
  bool bDynamicSpotLight : packoffset(c64.w);
  float4 LightChannelMask : packoffset(c65);
  float3 SpotDirection : packoffset(c66);
  float2 SpotAngles : packoffset(c67);
  float3 UpperSkyColor : packoffset(c68);
  float3 LowerSkyColor : packoffset(c69);
  float4 AmbientColorAndSkyFactor : packoffset(c70);
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
Texture2D<float4> PixelTexture2D_0 : register(t0);
Texture3D<float4> XComFOWVolumeTexture : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD10,
  float4 v1 : TEXCOORD11,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD4,
  float4 v6 : TEXCOORD6,
  float4 v7 : TEXCOORD5,
  uint v8 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = CameraWorldPos.xyz + v7.xyz;
  r0.xyw = -TransLightingVolumeMin.xyz + r0.xyz;
  r1.xy = cmp(CutoutParam.xy < r0.zz);
  r2.xyz = r0.xyw * TransLightingVolumeInvSize.xyz + float3(-0.5,-0.5,-0.5);
  r0.xyz = TransLightingVolumeInvSize.xyz * r0.xyw;
  r0.x = XComFOWVolumeTexture.Sample(XComFOWVolumeTexture_s, r0.xyz).x;
  r2.xyz = float3(-0.5,-0.5,-0.75) + abs(r2.xyz);
  r2.xyz = max(float3(0,0,0), r2.xyz);
  r0.z = r2.x + r2.y;
  r0.z = r0.z + r2.z;
  r1.zw = FOWBorderSettings.xz + -r0.zz;
  r0.z = cmp(0 < r0.z);
  r2.xy = saturate(FOWBorderSettings.yw * r1.zw);
  r2.z = 1 + -r2.y;
  r1.zw = r2.xz * r2.xz;
  r1.zw = r1.zw * r1.zw;
  r3.x = r2.x * r1.z;
  r3.z = -r2.z * r1.w + 1;
  r0.y = 0;
  r0.yw = -FOWBorderOpacity.xy + r0.xy;
  r0.yw = r3.xz * r0.yw + FOWBorderOpacity.xy;
  r0.y = r0.y + r0.w;
  r0.x = r0.z ? r0.y : r0.x;
  r0.y = -0.800000012 + r0.x;
  r0.x = saturate(1.25 * r0.x);
  r2.z = 1 + -r0.x;
  r2.x = saturate(5 * r0.y);
  r0.x = 1 + -r2.x;
  r0.x = r0.x + -r2.z;
  r2.y = max(0, r0.x);
  r0.xyz = bUseTranslucentFOW ? r2.xyz : float3(1,0,0);
  r0.w = log2(abs(OcclusionPercentage));
  r0.w = UniformPixelScalars_0.x * r0.w;
  r0.w = exp2(r0.w);
  r0.zw = float2(1,1) + -r0.zw;
  r1.z = cmp(abs(OcclusionPercentage) < 9.99999997e-07);
  r0.w = r1.z ? 1 : r0.w;
  r1.z = PixelTexture2D_0.SampleBias(PixelTexture2D_0_s, v2.xy, 0).z;
  r0.w = r1.z * r0.w;
  r2.xyz = v3.www * v3.xyz;
  r2.xyz = r2.xyz * r0.www;
  r2.xyz = v4.www * r2.xyz + UniformPixelVector_0.xyz;
  r0.w = saturate(dot(r2.xyz, float3(0.300000012,0.589999974,0.109999999)));
  r3.xyz = HaveSeenTintColor.xyz * r0.www;
  r3.xyz = r3.xyz * r0.yyy;
  r0.xyw = r2.xyz * r0.xxx + r3.xyz;
  r0.xyz = r0.xyw * r0.zzz;
  r0.xyz = ExponentialFog.www * r0.xyz;
  r0.xyz = v5.www * r0.xyz;
  r0.w = CutoutParam.w * CutoutParam.w;
  r0.w = r1.y ? r0.w : 1;
  r0.w = r1.x ? 0 : r0.w;
  o0.xyz = r0.xyz * r0.www;
  o0.w = 0;
  return;
}