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
  float4 UniformPixelVector_1 : packoffset(c45);
  float4 UniformPixelVector_2 : packoffset(c46);
  float4 UniformPixelVector_3 : packoffset(c47);
  float4 UniformPixelScalars_0 : packoffset(c48);
  float4 UniformPixelScalars_1 : packoffset(c49);
  float4 UniformPixelScalars_2 : packoffset(c50);
  float3 TemporalAAParameters : packoffset(c51);
  float4 CameraRight : packoffset(c52);
  float4 CameraUp : packoffset(c53);
  float4 LightColorAndFalloffExponent : packoffset(c54);
  float3 DistanceFieldParameters : packoffset(c55);
  float4x4 ScreenToShadowMatrix : packoffset(c56);
  float4 ShadowBufferAndTexelSize : packoffset(c60);
  float ShadowOverrideFactor : packoffset(c61);
  bool bReceiveDynamicShadows : packoffset(c61.y);
  bool bEnableDistanceShadowFading : packoffset(c61.z);
  float2 DistanceFadeParameters : packoffset(c62);
  float4 FOWBorderSettings : packoffset(c63);
  float2 FOWBorderOpacity : packoffset(c64);
  bool bUseTranslucentFOW : packoffset(c64.z);
  float4 ExponentialFog : packoffset(c65);
  float3 OcclusionColor : packoffset(c66);
  float3 HaveSeenTintColor : packoffset(c67);
  float4 DeferredRenderingParameters : packoffset(c68);
  float2 TemporalAAParametersPS : packoffset(c69);
  bool bDynamicDirectionalLight : packoffset(c69.z);
  bool bDynamicSpotLight : packoffset(c69.w);
  float4 LightChannelMask : packoffset(c70);
  float3 SpotDirection : packoffset(c71);
  float2 SpotAngles : packoffset(c72);
  float3 UpperSkyColor : packoffset(c73);
  float3 LowerSkyColor : packoffset(c74);
  float4 AmbientColorAndSkyFactor : packoffset(c75);
}

cbuffer VSOffsetConstants : register(b1)
{
  float4x4 ViewProjectionMatrix : packoffset(c0);
  float4 CameraPositionVS : packoffset(c4);
  float4 PreViewTranslation : packoffset(c5);
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
SamplerState PixelTexture2D_1_s : register(s1);
SamplerState XComFOWVolumeTexture_s : register(s2);
Texture2D<float4> PixelTexture2D_0 : register(t0);
Texture2D<float4> PixelTexture2D_1 : register(t1);
Texture3D<float4> XComFOWVolumeTexture : register(t2);


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
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = ViewProjectionMatrix._m01_m11_m31 * v7.yyy;
  r0.xyz = ViewProjectionMatrix._m00_m10_m30 * v7.xxx + r0.xyz;
  r0.xyz = ViewProjectionMatrix._m02_m12_m32 * v7.zzz + r0.xyz;
  r0.xyz = ViewProjectionMatrix._m03_m13_m33 * v7.www + r0.xyz;
  r0.xy = r0.xy / r0.zz;
  r0.xy = r0.xy * ScreenPositionScaleBias.xy + ScreenPositionScaleBias.wz;
  r0.xy = UniformPixelVector_1.xy * r0.xy;
  r0.zw = r0.xy * float2(2,0.5) + UniformPixelVector_2.xy;
  r0.xy = r0.xy * float2(2,0.5) + UniformPixelVector_3.xy;
  r0.x = PixelTexture2D_1.SampleBias(PixelTexture2D_1_s, r0.xy, 0).x;
  r0.y = PixelTexture2D_1.SampleBias(PixelTexture2D_1_s, r0.zw, 0).x;
  r0.x = r0.y * r0.x;
  r0.x = 10 * r0.x;
  r0.y = log2(abs(OcclusionPercentage));
  r0.y = UniformPixelScalars_0.x * r0.y;
  r0.y = exp2(r0.y);
  r0.y = 1 + -r0.y;
  r0.z = cmp(abs(OcclusionPercentage) < 9.99999997e-07);
  r0.y = r0.z ? 1 : r0.y;
  r1.xyz = PixelTexture2D_0.SampleBias(PixelTexture2D_0_s, v2.xy, 0).xyz;
  r0.yzw = r1.xyz * r0.yyy;
  r0.xyz = r0.xxx * r0.yzw;
  r1.xyz = v3.www * v3.xyz;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = v4.www * r0.xyz + UniformPixelVector_0.xyz;
  r0.w = saturate(dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999)));
  r1.xyz = HaveSeenTintColor.xyz * r0.www;
  r2.xyz = CameraWorldPos.xyz + v7.xyz;
  r2.xyw = -TransLightingVolumeMin.xyz + r2.xyz;
  r3.xy = cmp(CutoutParam.xy < r2.zz);
  r4.xyz = r2.xyw * TransLightingVolumeInvSize.xyz + float3(-0.5,-0.5,-0.5);
  r2.xyz = TransLightingVolumeInvSize.xyz * r2.xyw;
  r2.x = XComFOWVolumeTexture.Sample(XComFOWVolumeTexture_s, r2.xyz).x;
  r4.xyz = float3(-0.5,-0.5,-0.75) + abs(r4.xyz);
  r4.xyz = max(float3(0,0,0), r4.xyz);
  r0.w = r4.x + r4.y;
  r0.w = r0.w + r4.z;
  r2.zw = FOWBorderSettings.xz + -r0.ww;
  r0.w = cmp(0 < r0.w);
  r4.xy = saturate(FOWBorderSettings.yw * r2.zw);
  r4.z = 1 + -r4.y;
  r2.zw = r4.xz * r4.xz;
  r2.zw = r2.zw * r2.zw;
  r5.x = r4.x * r2.z;
  r5.z = -r4.z * r2.w + 1;
  r2.y = 0;
  r2.yz = -FOWBorderOpacity.xy + r2.xy;
  r2.yz = r5.xz * r2.yz + FOWBorderOpacity.xy;
  r1.w = r2.y + r2.z;
  r0.w = r0.w ? r1.w : r2.x;
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
  r0.w = 1 + -r2.z;
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = ExponentialFog.www * r0.xyz;
  r0.xyz = v5.www * r0.xyz;
  r0.w = CutoutParam.w * CutoutParam.w;
  r0.w = r3.y ? r0.w : 1;
  r0.w = r3.x ? 0 : r0.w;
  o0.xyz = r0.xyz * r0.www;
  o0.w = 0;
  return;
}