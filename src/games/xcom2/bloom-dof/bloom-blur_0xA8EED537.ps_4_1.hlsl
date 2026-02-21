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
  float SSSEnabled : packoffset(c27);
  bool bForceLPVBilinearSampling : packoffset(c27.y);
  float3x3 LocalToWorldMatrix : packoffset(c28);
  float4x4 WorldToLocalMatrix : packoffset(c31);
  float3x3 WorldToViewMatrix : packoffset(c35);
  float3x3 ViewToWorldMatrix : packoffset(c38);
  float3x3 WorldToProjMatrix : packoffset(c41);
  float4 UniformPixelVector_0 : packoffset(c44);
  float4 UniformPixelVector_1 : packoffset(c45);
  float3 TemporalAAParameters : packoffset(c46);
  float4x3 WorldToLocal : packoffset(c47);
  float4x4 PreviousLocalToWorld : packoffset(c50);
  float3 MeshOrigin : packoffset(c54);
  float3 MeshExtension : packoffset(c55);
  float4 BoneIndexOffsetAndScale : packoffset(c56);
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
Texture2D<float4> PixelTexture2D_0 : register(t0);
Texture3D<float4> TransLightVolume_RedSH : register(t1);
Texture3D<float4> TransLightVolume_GreenSH : register(t2);
Texture3D<float4> TransLightVolume_BlueSH : register(t3);
Texture3D<float4> XComFOWVolumeTexture : register(t4);


// 3Dmigoto declarations
#define cmp -


void main(
  linear centroid float4 v0 : TEXCOORD10,
  linear centroid float4 v1 : TEXCOORD11,
  float4 v2 : COLOR0,
  float4 v3 : TEXCOORD0,
  float4 v4 : TEXCOORD4,
  float4 v5 : TEXCOORD6,
  float4 v6 : TEXCOORD7,
  float4 v7 : TEXCOORD5,
  uint v8 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(v1.xyz, v1.xyz);
  r0.x = rsqrt(r0.x);
  r0.xyz = v1.xyz * r0.xxx;
  r0.w = dot(v0.xyz, v0.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyw = v0.xyz * r0.www;
  r0.y = r1.x * r0.y;
  r0.x = r0.x * r1.y + -r0.y;
  r1.z = r0.z;
  r1.y = v1.w * r0.x;
  r0.x = dot(r1.yzw, r1.yzw);
  r0.x = rsqrt(r0.x);
  r0.xyz = r1.yzw * r0.xxx;
  r0.yzw = float3(-0.511663854,0.511663854,-0.511663854) * r0.xyz;
  r1.xyz = CameraWorldPos.xyz + v7.xyz;
  r1.xyw = -TransLightingVolumeMin.xyz + r1.xyz;
  r2.xy = cmp(CutoutParam.xy < r1.zz);
  r3.xyz = TransLightingVolumeInvSize.xyz * r1.xyw;
  r1.xyz = r1.xyw * TransLightingVolumeInvSize.xyz + float3(-0.5,-0.5,-0.5);
  r1.xyz = float3(-0.5,-0.5,-0.75) + abs(r1.xyz);
  r1.xyz = max(float3(0,0,0), r1.xyz);
  r4.xyzw = TransLightVolume_RedSH.Sample(TransLightVolume_RedSH_s, r3.xyz).xyzw;
  r0.x = 0.354491025;
  r4.x = dot(r4.xyzw, r0.xyzw);
  r5.xyzw = TransLightVolume_GreenSH.Sample(TransLightVolume_GreenSH_s, r3.xyz).xyzw;
  r4.y = dot(r5.xyzw, r0.xyzw);
  r5.xyzw = TransLightVolume_BlueSH.Sample(TransLightVolume_BlueSH_s, r3.xyz).xyzw;
  r2.z = XComFOWVolumeTexture.Sample(XComFOWVolumeTexture_s, r3.xyz).x;
  r4.z = dot(r5.xyzw, r0.xyzw);
  r0.xyz = max(float3(0,0,0), r4.xyz);
  r3.xyz = float3(1,1,1) + -UniformPixelVector_0.xyz;
  r3.xyz = UniformPixelVector_1.xyz * r3.xyz;
  r3.xyz = r3.xyz * DiffuseOverrideParameter.www + DiffuseOverrideParameter.xyz;
  r4.xyz = r3.xyz * AmbientColorAndSkyFactor.xyz + UniformPixelVector_0.xyz;
  r0.xyz = r3.xyz * r0.xyz + r4.xyz;
  r0.w = saturate(dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999)));
  r3.xyz = HaveSeenTintColor.xyz * r0.www;
  r0.w = r1.x + r1.y;
  r0.w = r0.w + r1.z;
  r1.x = cmp(0 < r0.w);
  r1.yz = FOWBorderSettings.xz + -r0.ww;
  r4.xy = saturate(FOWBorderSettings.yw * r1.yz);
  r4.z = 1 + -r4.y;
  r1.yz = r4.xz * r4.xz;
  r1.yz = r1.yz * r1.yz;
  r5.x = r4.x * r1.y;
  r5.z = -r4.z * r1.z + 1;
  r2.w = 0;
  r1.yz = -FOWBorderOpacity.xy + r2.zw;
  r1.yz = r5.xz * r1.yz + FOWBorderOpacity.xy;
  r0.w = r1.y + r1.z;
  r0.w = r1.x ? r0.w : r2.z;
  r1.x = -0.800000012 + r0.w;
  r0.w = saturate(1.25 * r0.w);
  r4.z = 1 + -r0.w;
  r4.x = saturate(5 * r1.x);
  r0.w = 1 + -r4.x;
  r0.w = r0.w + -r4.z;
  r4.y = max(0, r0.w);
  r1.xyz = bUseTranslucentFOW ? r4.xyz : float3(1,0,0);
  r3.xyz = r3.xyz * r1.yyy;
  r0.xyz = r0.xyz * r1.xxx + r3.xyz;
  r0.xyz = OcclusionColor.xyz * r1.zzz + r0.xyz;
  r0.w = 1 + -r1.z;
  r0.xyz = -ExponentialFog.xyz + r0.xyz;
  r0.xyz = ExponentialFog.www * r0.xyz + ExponentialFog.xyz;
  o0.xyz = r0.xyz * v4.www + v4.xyz;
  r0.x = CutoutParam.w * CutoutParam.w;
  r0.x = r2.y ? r0.x : 1;
  r0.x = r2.x ? 0 : r0.x;
  r0.y = PixelTexture2D_0.SampleBias(PixelTexture2D_0_s, v3.xy, 0).x;
  r0.y = r0.y * r0.w;
  o0.w = r0.y * r0.x;
  return;
}