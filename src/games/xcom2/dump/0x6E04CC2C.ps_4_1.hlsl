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
  float3 TemporalAAParameters : packoffset(c45);
  float4 CameraWorldPosition : packoffset(c46);
  float4 CameraRight : packoffset(c47);
  float4 CameraUp : packoffset(c48);
  float4 ScreenAlignment : packoffset(c49);
  float NormalsType : packoffset(c50);
  float4 NormalsSphereCenter : packoffset(c51);
  float4 NormalsCylinderUnitDirection : packoffset(c52);
  float AxisRotationVectorSourceIndex : packoffset(c53);
  float4 AxisRotationVectors[2] : packoffset(c54);
  float3 ParticleUpRightResultScalars : packoffset(c56);
  float4 LightColorAndFalloffExponent : packoffset(c57);
  float3 DistanceFieldParameters : packoffset(c58);
  float4x4 ScreenToShadowMatrix : packoffset(c59);
  float4 ShadowBufferAndTexelSize : packoffset(c63);
  float ShadowOverrideFactor : packoffset(c64);
  bool bReceiveDynamicShadows : packoffset(c64.y);
  bool bEnableDistanceShadowFading : packoffset(c64.z);
  float2 DistanceFadeParameters : packoffset(c65);
  float4 FOWBorderSettings : packoffset(c66);
  float2 FOWBorderOpacity : packoffset(c67);
  bool bUseTranslucentFOW : packoffset(c67.z);
  float4 ExponentialFog : packoffset(c68);
  float3 OcclusionColor : packoffset(c69);
  float3 HaveSeenTintColor : packoffset(c70);
  float4 DeferredRenderingParameters : packoffset(c71);
  float2 TemporalAAParametersPS : packoffset(c72);
  bool bDynamicDirectionalLight : packoffset(c72.z);
  bool bDynamicSpotLight : packoffset(c72.w);
  float4 LightChannelMask : packoffset(c73);
  float3 SpotDirection : packoffset(c74);
  float2 SpotAngles : packoffset(c75);
  float3 UpperSkyColor : packoffset(c76);
  float3 LowerSkyColor : packoffset(c77);
  float4 AmbientColorAndSkyFactor : packoffset(c78);
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

SamplerState SceneDepthTexture_s : register(s0);
SamplerState PixelTexture2D_0_s : register(s1);
SamplerState PixelTexture2D_1_s : register(s2);
SamplerState XComFOWVolumeTexture_s : register(s3);
SamplerState TransLightVolume_RedSH_s : register(s4);
SamplerState TransLightVolume_GreenSH_s : register(s5);
SamplerState TransLightVolume_BlueSH_s : register(s6);
Texture2D<float4> PixelTexture2D_0 : register(t0);
Texture2D<float4> PixelTexture2D_1 : register(t1);
Texture2D<float4> SceneDepthTexture : register(t2);
Texture3D<float4> TransLightVolume_RedSH : register(t3);
Texture3D<float4> TransLightVolume_GreenSH : register(t4);
Texture3D<float4> TransLightVolume_BlueSH : register(t5);
Texture3D<float4> XComFOWVolumeTexture : register(t6);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD10,
  float4 v1 : TEXCOORD11,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD3,
  float4 v6 : TEXCOORD4,
  float4 v7 : TEXCOORD6,
  float4 v8 : TEXCOORD7,
  float4 v9 : TEXCOORD5,
  uint v10 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v5.zz * v2.xy;
  r0.zw = float2(0.713940024,1) * v5.xx;
  r0.xy = r0.xy * float2(2,2) + r0.zw;
  r0.xy = v5.yy * float2(0.100000001,0.0299999993) + r0.xy;
  r0.x = PixelTexture2D_0.SampleBias(PixelTexture2D_0_s, r0.xy, 0).x;
  r0.xyz = v3.xyz * r0.xxx;
  r1.xyz = float3(1,1,1) + -UniformPixelVector_0.xyz;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = r0.xyz * DiffuseOverrideParameter.www + DiffuseOverrideParameter.xyz;
  r1.xyz = r0.xyz * AmbientColorAndSkyFactor.xyz + UniformPixelVector_0.xyz;
  r2.xyz = CameraWorldPos.xyz + v9.xyz;
  r3.xyz = -TransLightingVolumeMin.xyz + r2.xyz;
  r4.xyz = TransLightingVolumeInvSize.xyz * r3.xyz;
  r3.xyz = r3.xyz * TransLightingVolumeInvSize.xyz + float3(-0.5,-0.5,-0.5);
  r3.xyz = float3(-0.5,-0.5,-0.75) + abs(r3.xyz);
  r3.xyz = max(float3(0,0,0), r3.xyz);
  r0.w = TransLightVolume_RedSH.Sample(TransLightVolume_RedSH_s, r4.xyz).x;
  r5.x = 0.886226952 * r0.w;
  r0.w = TransLightVolume_GreenSH.Sample(TransLightVolume_GreenSH_s, r4.xyz).x;
  r5.y = 0.886226952 * r0.w;
  r0.w = TransLightVolume_BlueSH.Sample(TransLightVolume_BlueSH_s, r4.xyz).x;
  r4.x = XComFOWVolumeTexture.Sample(XComFOWVolumeTexture_s, r4.xyz).x;
  r5.z = 0.886226952 * r0.w;
  r5.xyz = max(float3(0,0,0), r5.xyz);
  r0.xyz = r0.xyz * r5.xyz + r1.xyz;
  r0.w = saturate(dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999)));
  r1.xyz = HaveSeenTintColor.xyz * r0.www;
  r0.w = r3.x + r3.y;
  r0.w = r0.w + r3.z;
  r3.xy = FOWBorderSettings.xz + -r0.ww;
  r0.w = cmp(0 < r0.w);
  r3.xy = saturate(FOWBorderSettings.yw * r3.xy);
  r3.z = 1 + -r3.y;
  r3.yw = r3.xz * r3.xz;
  r3.yw = r3.yw * r3.yw;
  r5.x = r3.x * r3.y;
  r5.z = -r3.z * r3.w + 1;
  r4.y = 0;
  r3.xy = -FOWBorderOpacity.xy + r4.xy;
  r3.xy = r5.xz * r3.xy + FOWBorderOpacity.xy;
  r1.w = r3.x + r3.y;
  r0.w = r0.w ? r1.w : r4.x;
  r1.w = -0.800000012 + r0.w;
  r0.w = saturate(1.25 * r0.w);
  r3.z = 1 + -r0.w;
  r3.x = saturate(5 * r1.w);
  r0.w = 1 + -r3.x;
  r0.w = r0.w + -r3.z;
  r3.y = max(0, r0.w);
  r3.xyz = bUseTranslucentFOW ? r3.xyz : float3(1,0,0);
  r1.xyz = r3.yyy * r1.xyz;
  r0.xyz = r0.xyz * r3.xxx + r1.xyz;
  r0.xyz = OcclusionColor.xyz * r3.zzz + r0.xyz;
  r0.w = 1 + -r3.z;
  r0.xyz = -ExponentialFog.xyz + r0.xyz;
  r0.xyz = ExponentialFog.www * r0.xyz + ExponentialFog.xyz;
  o0.xyz = r0.xyz * v6.www + v6.xyz;
  r0.xyz = ViewProjectionMatrix._m01_m11_m31 * v9.yyy;
  r0.xyz = ViewProjectionMatrix._m00_m10_m30 * v9.xxx + r0.xyz;
  r0.xyz = ViewProjectionMatrix._m02_m12_m32 * v9.zzz + r0.xyz;
  r0.xyz = ViewProjectionMatrix._m03_m13_m33 * v9.www + r0.xyz;
  r0.xy = r0.xy / r0.zz;
  r0.xy = r0.xy * ScreenPositionScaleBias.xy + ScreenPositionScaleBias.wz;
  r0.x = SceneDepthTexture.SampleLevel(SceneDepthTexture_s, r0.xy, 0).x;
  r0.y = r0.x * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
  r0.x = cmp(0.999000013 < r0.x);
  r0.y = 1 / r0.y;
  r0.x = r0.x ? 1000000 : r0.y;
  r0.x = r0.x + -r0.z;
  r0.y = saturate(0.00499999989 * r0.z);
  r0.x = saturate(r0.x / v5.w);
  r1.xyz = -ObjectWorldPositionAndRadius.xyz + CameraWorldPos.xyz;
  r0.z = dot(r1.xyz, r1.xyz);
  r0.z = sqrt(r0.z);
  r0.z = -r0.z * 0.000285714283 + 1;
  r0.z = saturate(3 * r0.z);
  r0.y = r0.y * r0.z;
  r0.x = r0.x * r0.y;
  r0.y = PixelTexture2D_1.SampleBias(PixelTexture2D_1_s, v2.xy, 0).z;
  r0.y = saturate(v3.w * r0.y);
  r0.x = r0.x * r0.y;
  r1.xyz = -ObjectWorldPositionAndRadius.xyz + r2.xyz;
  r0.yz = cmp(CutoutParam.xy < r2.zz);
  r1.xyz = min(v4.xyz, abs(r1.xyz));
  r1.xyz = v4.xyz + -r1.xyz;
  r1.xyz = r1.xyz / v4.www;
  r1.x = r1.x * r1.y;
  r1.x = saturate(r1.x * r1.z);
  r0.x = r1.x * r0.x;
  r0.x = r0.x * r0.w;
  r0.w = CutoutParam.w * CutoutParam.w;
  r0.z = r0.z ? r0.w : 1;
  r0.y = r0.y ? 0 : r0.z;
  o0.w = r0.x * r0.y;
  return;
}