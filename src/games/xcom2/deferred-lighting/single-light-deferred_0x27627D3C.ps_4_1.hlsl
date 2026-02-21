// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 12:09:38 2026

cbuffer _Globals : register(b0)
{
  float4x4 ScreenToWorldMatrix : packoffset(c0);
  float4 SpherePositionRadius : packoffset(c4);
  bool bDecompressSceneColor : packoffset(c5);
  float4 LightColorAndFalloffExponent : packoffset(c6);
  float3 DistanceFieldParameters : packoffset(c7);
  float4x4 ScreenToShadowMatrix : packoffset(c8);
  float4 ShadowBufferAndTexelSize : packoffset(c12);
  float ShadowOverrideFactor : packoffset(c13);
  bool bReceiveDynamicShadows : packoffset(c13.y);
  bool bEnableDistanceShadowFading : packoffset(c13.z);
  float2 DistanceFadeParameters : packoffset(c14);
  float4 DeferredRenderingParameters : packoffset(c15);
  float4 UVScaleBias : packoffset(c16);
  int MinZ : packoffset(c17);
  float4 ClearColor : packoffset(c18);
  float4 LevelVolumeDimensions : packoffset(c19);
  float4 LevelVolumePosition : packoffset(c20);
  float4 VoxelSizeUVW : packoffset(c21);
  float4 VoxelSizeXYZ : packoffset(c22);
  uint LightID : packoffset(c23);

  struct
  {
    float3 WorldPosition;
    float InvRadius;
    float3 Color;
    float FallOffExponent;
    float3 Direction;
    float SourceLength;
    float2 SpotAngles;
    float2 MinShadowOpacity;
    float SourceRadius;
    float MinRoughness;
    float CharacterLight;
    float InvSquaredFalloff;
    uint LightID;
    float3 Padding;
  } LightProperties : packoffset(c24);

  float LightingOptions : packoffset(c30);
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
SamplerState TransmissionGBufferTexture_s : register(s3);
SamplerState SceneDepthTexture_s : register(s4);
SamplerState LightAttenuationTexture_s : register(s5);
SamplerState PreIntegratedBRDFTexture_s : register(s6);
Texture2D<float4> LightAttenuationTexture : register(t0);
Texture2D<float4> SceneDepthTexture : register(t1);
Texture2D<float4> WorldNormalGBufferTexture : register(t2);
Texture2D<float4> DiffuseGBufferTexture : register(t3);
Texture2D<float4> TransmissionGBufferTexture : register(t4);
Texture2D<float4> SpecularGBufferTexture : register(t5);
Texture2D<float4> PreIntegratedBRDFTexture : register(t6);
Texture3D<uint> LightVolumeClippingTexture : register(t7);
Texture3D<uint> VisBlockingTexture : register(t8);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy / v0.ww;
  r0.zw = r0.xy * ScreenPositionScaleBias.xy + ScreenPositionScaleBias.wz;
  r1.xyzw = LightAttenuationTexture.SampleLevel(LightAttenuationTexture_s, r0.zw, 0).xyzw;
  r2.xyzw = r1.xyzw * r1.xyzw;
  r1.x = r2.x + r2.y;
  r1.x = r1.z * r1.z + r1.x;
  r1.x = r1.x * r2.w;
  r1.x = cmp(0 < r1.x);
  if (r1.x != 0) {
    r1.x = SceneDepthTexture.SampleLevel(SceneDepthTexture_s, r0.zw, 0).x;
    r1.y = cmp(0.999000013 < r1.x);
    r1.x = r1.x * MinZ_MaxZRatio.z + -MinZ_MaxZRatio.w;
    r1.x = 1 / r1.x;
    r1.x = r1.y ? 1000000 : r1.x;
    r0.xy = r1.xx * r0.xy;
    r1.yzw = ScreenToWorldMatrix._m01_m11_m21 * r0.yyy;
    r1.yzw = ScreenToWorldMatrix._m00_m10_m20 * r0.xxx + r1.yzw;
    r1.xyz = ScreenToWorldMatrix._m02_m12_m22 * r1.xxx + r1.yzw;
    r1.xyz = ScreenToWorldMatrix._m03_m13_m23 + r1.xyz;
    if (LightProperties.LightID != 0) {
      r3.xyz = -LevelVolumePosition.xyz + r1.xyz;
      r3.xyz = r3.xyz / LevelVolumeDimensions.xyz;
      r4.xyz = VoxelSizeXYZ.xyz * r3.xyz;
      r3.xyz = r3.xyz * VoxelSizeXYZ.xyz + float3(-0.5,-0.5,-0.5);
      r5.xyz = floor(r3.xyz);
      r5.xyz = (uint3)r5.xyz;
      r6.xyz = (uint3)r5.xyz;
      r3.xyz = saturate(-r6.xyz + r3.xyz);
      r4.xyz = floor(r4.xyz);
      r4.xyz = (uint3)r4.xyz;
      r4.w = 0;
      r0.x = VisBlockingTexture.Load(r4.xyzw).x;
      r4.xyzw = (int4)r0.xxxx & int4(2,1,8,4);
      r4.xyzw = cmp((int4)r4.xyzw != int4(0,0,0,0));
      r7.xyz = cmp(r3.xyz < float3(0.5,0.5,0.5));
      r4.xz = r4.xz ? r7.xy : 0;
      r3.xy = r4.xz ? float2(0,0) : r3.xy;
      r4.xz = cmp(float2(0.5,0.5) < r3.xy);
      r4.xy = r4.xz ? r4.yw : 0;
      r4.xy = r4.xy ? float2(1,1) : r3.xy;
      r0.xy = (int2)r0.xx & int2(32,16);
      r0.xy = cmp((int2)r0.xy != int2(0,0));
      r0.x = r7.z ? r0.x : 0;
      r0.x = r0.x ? 0 : r3.z;
      r1.w = cmp(0.5 < r0.x);
      r0.y = r0.y ? r1.w : 0;
      r4.z = r0.y ? 1 : r0.x;
      r3.xyz = float3(1,1,1) + -r4.xyz;
      r5.w = 0;
      r0.x = LightVolumeClippingTexture.Load(r5.xyzw).x;
      r0.x = (int)r0.x & (int)LightProperties.LightID;
      r5.xyz = float3(1,0,0) + r6.xyz;
      r5.xyz = (uint3)r5.xyz;
      r5.w = 0;
      r0.y = LightVolumeClippingTexture.Load(r5.xyzw).x;
      r0.y = (int)r0.y & (int)LightProperties.LightID;
      r5.xyz = float3(1,1,0) + r6.xyz;
      r5.xyz = (uint3)r5.xyz;
      r5.w = 0;
      r1.w = LightVolumeClippingTexture.Load(r5.xyzw).x;
      r1.w = (int)r1.w & (int)LightProperties.LightID;
      r5.xyz = float3(0,1,0) + r6.xyz;
      r5.xyz = (uint3)r5.xyz;
      r5.w = 0;
      r3.w = LightVolumeClippingTexture.Load(r5.xyzw).x;
      r3.w = (int)r3.w & (int)LightProperties.LightID;
      r5.xyz = float3(0,0,1) + r6.xyz;
      r5.xyz = (uint3)r5.xyz;
      r5.w = 0;
      r4.w = LightVolumeClippingTexture.Load(r5.xyzw).x;
      r4.w = (int)r4.w & (int)LightProperties.LightID;
      r5.xyz = float3(1,0,1) + r6.xyz;
      r5.xyz = (uint3)r5.xyz;
      r5.w = 0;
      r5.x = LightVolumeClippingTexture.Load(r5.xyzw).x;
      r5.x = (int)r5.x & (int)LightProperties.LightID;
      r5.yzw = float3(1,1,1) + r6.xyz;
      r7.xyz = (uint3)r5.yzw;
      r7.w = 0;
      r5.y = LightVolumeClippingTexture.Load(r7.xyzw).x;
      r5.y = (int)r5.y & (int)LightProperties.LightID;
      r6.xyz = float3(0,1,1) + r6.xyz;
      r6.xyz = (uint3)r6.xyz;
      r6.w = 0;
      r5.z = LightVolumeClippingTexture.Load(r6.xyzw).x;
      r5.z = (int)r5.z & (int)LightProperties.LightID;
      r0.x = r0.x ? r3.x : 0;
      r0.y = r0.y ? r4.x : 0;
      r0.x = r0.x + r0.y;
      r0.y = r3.w ? r3.x : 0;
      r1.w = r1.w ? r4.x : 0;
      r0.y = r1.w + r0.y;
      r0.y = r0.y * r4.y;
      r0.x = r0.x * r3.y + r0.y;
      r0.y = r4.w ? r3.x : 0;
      r1.w = r5.x ? r4.x : 0;
      r0.y = r1.w + r0.y;
      r1.w = r5.z ? r3.x : 0;
      r3.x = r5.y ? r4.x : 0;
      r1.w = r3.x + r1.w;
      r1.w = r1.w * r4.y;
      r0.y = r0.y * r3.y + r1.w;
      r0.y = r0.y * r4.z;
      r0.x = r0.x * r3.z + r0.y;
      r0.x = log2(r0.x);
      r0.x = 2.5 * r0.x;
      r0.x = exp2(r0.x);
    } else {
      r0.x = 1;
    }
    r0.y = cmp(0 < r0.x);
    if (r0.y != 0) {
      r3.xyzw = WorldNormalGBufferTexture.SampleLevel(WorldNormalGBufferTexture_s, r0.zw, 0).xyzw;
      r3.xyz = r3.xyz * float3(2,2,2) + float3(-1,-1,-1);
      r0.y = dot(r3.xyz, r3.xyz);
      r0.y = rsqrt(r0.y);
      r3.xyz = r3.xyz * r0.yyy;
      r0.y = 255 * r3.w;
      r0.y = ceil(r0.y);
      r0.y = (uint)r0.y;
      r4.xyzw = TransmissionGBufferTexture.SampleLevel(TransmissionGBufferTexture_s, r0.zw, 0).xyzw;
      r5.xy = (int2)r0.yy & int2(2,8);
      if (r5.x == 0) {
        r1.w = (int)r0.y & 4;
        if (r1.w != 0) {
          r4.xyz = r4.xyz * float3(2,2,2) + float3(-1,-1,-1);
        } else {
          r1.w = (int)r0.y & 32;
          if (r1.w != 0) {
            r4.xyz = r4.xyz * float3(2,2,2) + float3(-1,-1,-1);
          } else {
            r4.xyz = float3(0,0,0);
          }
        }
      }
      r1.w = cmp(0 < LightProperties.CharacterLight);
      r3.w = cmp((int)r5.y == 0);
      r1.w = r1.w ? r3.w : 0;
      r3.w = cmp(0 < LightProperties.InvRadius);
      if (r3.w != 0) {
        r5.yzw = LightProperties.WorldPosition.xyz + -r1.xyz;
        r3.w = dot(r5.yzw, r5.yzw);
        r6.x = rsqrt(r3.w);
        r6.xyz = r6.xxx * r5.yzw;
        r6.w = sqrt(r3.w);
        r7.x = cmp(0 < LightProperties.InvSquaredFalloff);
        r7.y = cmp(0 < LightProperties.SourceLength);
        r8.xyz = LightProperties.SourceLength * -LightProperties.Direction.xyz;
        r9.xyz = -r8.xyz * float3(0.5,0.5,0.5) + r5.yzw;
        r8.xyz = r8.xyz * float3(0.5,0.5,0.5) + r5.yzw;
        r7.z = dot(r9.xyz, r9.xyz);
        r7.w = dot(r8.xyz, r8.xyz);
        r7.zw = sqrt(r7.zw);
        r8.w = dot(r9.xyz, r8.xyz);
        r8.w = r7.z * r7.w + r8.w;
        r8.w = 9.99999975e-05 + r8.w;
        r8.w = 2 / r8.w;
        r10.y = 32000 * r8.w;
        r8.w = dot(r3.xyz, r9.xyz);
        r8.x = dot(r3.xyz, r8.xyz);
        r7.zw = r8.wx / r7.zw;
        r7.z = r7.z + r7.w;
        r10.x = saturate(0.5 * r7.z);
        r3.w = 1 + r3.w;
        r3.w = 1 / r3.w;
        r8.y = 32000 * r3.w;
        r8.x = dot(r3.xyz, r6.xyz);
        r9.xy = r7.yy ? r10.xy : r8.xy;
        r3.w = LightProperties.InvRadius * r6.w;
        r3.w = r3.w * r3.w;
        r3.w = -r3.w * r3.w + 1;
        r3.w = max(0, r3.w);
        r3.w = r3.w * r3.w;
        r9.z = r9.y * r3.w;
        r7.yzw = LightProperties.InvRadius * r5.yzw;
        r3.w = dot(r7.yzw, r7.yzw);
        r3.w = min(1, r3.w);
        r3.w = 1 + -r3.w;
        r3.w = log2(r3.w);
        r3.w = LightProperties.FallOffExponent * r3.w;
        r8.z = exp2(r3.w);
        r7.xy = r7.xx ? r9.xz : r8.xz;
        r3.w = dot(r6.xyz, LightProperties.Direction.xyz);
        r3.w = -LightProperties.SpotAngles.x + r3.w;
        r3.w = saturate(LightProperties.SpotAngles.y * r3.w);
        r3.w = r3.w * r3.w;
      } else {
        r7.x = dot(r3.xyz, LightProperties.Direction.xyz);
        r5.yzw = LightProperties.Direction.xyz;
        r7.y = 1;
        r3.w = 1;
      }
      r6.x = cmp(0 < r7.y);
      r6.y = cmp(0 < r3.w);
      r6.x = r6.y ? r6.x : 0;
      r1.w = cmp((int)r1.w == 0);
      r1.w = r1.w ? r6.x : 0;
      if (r1.w != 0) {
        r6.xyzw = DiffuseGBufferTexture.SampleLevel(DiffuseGBufferTexture_s, r0.zw, 0).xyzw;
        r1.xyz = -CameraPositionPS.xyz + r1.xyz;
        r1.w = dot(r1.xyz, r1.xyz);
        r1.w = rsqrt(r1.w);
        r1.xyz = r1.xyz * r1.www;
        r8.xyzw = SpecularGBufferTexture.SampleLevel(SpecularGBufferTexture_s, r0.zw, 0).xyzw;
        r8.xyzw = float4(1,1,1,1) + r8.xyzw;
        r9.xyzw = float4(0.5,0.5,0.5,0.5) * r8.xyzw;
        r0.z = r6.w * 0.75 + 0.25;
        r10.xyzw = r0.zzzz * r2.xyzw;
        r0.z = saturate(r0.z * r2.w + -LightProperties.MinShadowOpacity.x);
        r0.z = LightProperties.MinShadowOpacity.y * r0.z;
        r2.xyz = r9.xyz * r0.zzz;
        r0.yw = (int2)r0.yy & int2(32,4);
        r1.w = cmp(0 < LightProperties.SourceRadius);
        if (r1.w != 0) {
          r1.w = cmp(0 < LightProperties.SourceLength);
          if (r1.w != 0) {
            r1.w = dot(-LightProperties.Direction.xyz, -LightProperties.Direction.xyz);
            r1.w = rsqrt(r1.w);
            r8.xyz = -LightProperties.Direction.xyz * r1.www;
            r1.w = dot(r1.xyz, r3.xyz);
            r1.w = r1.w + r1.w;
            r11.xyz = r3.xyz * -r1.www + r1.xyz;
            r8.xyz = LightProperties.SourceLength * r8.xyz;
            r12.xyz = -r8.xyz * float3(0.5,0.5,0.5) + r5.yzw;
            r1.w = dot(r11.xyz, r8.xyz);
            r13.xyz = r1.www * r11.xyz + -r8.xyz;
            r2.w = dot(r12.xyz, r13.xyz);
            r1.w = r1.w * r1.w;
            r1.w = LightProperties.SourceLength * LightProperties.SourceLength + -r1.w;
            r1.w = saturate(r2.w / r1.w);
            r8.xyz = r1.www * r8.xyz + r12.xyz;
            r1.w = dot(r8.xyz, r11.xyz);
            r11.xyz = r1.www * r11.xyz + -r8.xyz;
            r1.w = dot(r11.xyz, r11.xyz);
            r1.w = sqrt(r1.w);
            r1.w = saturate(LightProperties.SourceRadius / r1.w);
            r8.xyz = r11.xyz * r1.www + r8.xyz;
            r1.w = dot(r8.xyz, r8.xyz);
            r1.w = sqrt(r1.w);
            r1.w = 1 / r1.w;
            r2.w = LightProperties.SourceLength * r1.w;
            r2.w = 1.57079637 * r2.w;
            r6.w = LightProperties.SourceLength * r1.w + 1;
            r2.w = r2.w / r6.w;
            r6.w = LightProperties.SourceRadius * r1.w;
            r6.w = 1.57079637 * r6.w;
            r1.w = LightProperties.SourceRadius * r1.w + 1;
            r1.w = r6.w / r1.w;
            r6.w = r9.w * r9.w;
            r2.w = r2.w * 0.333330005 + r6.w;
            r2.w = sqrt(r2.w);
            r2.w = min(1, r2.w);
            r2.w = r9.w / r2.w;
            r2.w = r2.w * r2.w;
            r1.w = r1.w * 0.333330005 + r6.w;
            r1.w = sqrt(r1.w);
            r1.w = min(1, r1.w);
            r1.w = r9.w / r1.w;
            r1.w = r1.w * r1.w;
            r1.w = r1.w * r1.w;
            r1.w = r2.w * r1.w;
          } else {
            r2.w = dot(r1.xyz, r3.xyz);
            r2.w = r2.w + r2.w;
            r11.xyz = r3.xyz * -r2.www + r1.xyz;
            r2.w = dot(r5.yzw, r11.xyz);
            r11.xyz = r2.www * r11.xyz + -r5.yzw;
            r2.w = dot(r11.xyz, r11.xyz);
            r2.w = sqrt(r2.w);
            r2.w = saturate(LightProperties.SourceRadius / r2.w);
            r8.xyz = r11.xyz * r2.www + r5.yzw;
            r2.w = dot(r8.xyz, r8.xyz);
            r2.w = sqrt(r2.w);
            r2.w = LightProperties.SourceRadius / r2.w;
            r6.w = 1.57079637 * r2.w;
            r2.w = 1 + r2.w;
            r2.w = r6.w / r2.w;
            r2.w = 0.333330005 * r2.w;
            r2.w = r9.w * r9.w + r2.w;
            r2.w = sqrt(r2.w);
            r2.w = min(1, r2.w);
            r2.w = r9.w / r2.w;
            r2.w = r2.w * r2.w;
            r1.w = r2.w * r2.w;
          }
          r2.w = r9.w;
        } else {
          r6.w = 1 + -LightProperties.MinRoughness;
          r2.w = r9.w * r6.w + LightProperties.MinRoughness;
          r8.xyz = r5.yzw;
          r1.w = 1;
        }
        r6.w = dot(r8.xyz, r8.xyz);
        r6.w = rsqrt(r6.w);
        r11.xyz = r8.xyz * r6.www;
        if (r0.y != 0) {
          r0.y = dot(r11.xyz, r4.xyz);
          r7.z = -r0.y * r0.y + 1;
          r4.z = dot(-r1.xyz, r4.xyz);
          r7.w = -r4.z * r4.z + 1;
          r7.zw = sqrt(r7.zw);
          r0.y = r4.z * r0.y;
          r0.y = saturate(r7.z * r7.w + -r0.y);
          r4.z = r2.w * r2.w;
          r4.z = r4.z * r4.z;
          r4.z = 1 / r4.z;
          r7.z = cmp(r0.y < 9.99999997e-07);
          r0.y = log2(r0.y);
          r0.y = r4.z * r0.y;
          r0.y = exp2(r0.y);
          r0.y = r7.z ? 0 : r0.y;
          r12.xyz = r0.yyy * r2.xyz;
          r12.xyz = r12.xyz * r1.www;
        } else {
          r8.xyz = r8.xyz * r6.www + -r1.xyz;
          r0.y = dot(r8.xyz, r8.xyz);
          r0.y = rsqrt(r0.y);
          r8.xyz = r8.xyz * r0.yyy;
          r0.y = saturate(dot(r3.xyz, r11.xyz));
          r4.z = saturate(dot(r3.xyz, -r1.xyz));
          r6.w = saturate(dot(r3.xyz, r8.xyz));
          r7.z = saturate(dot(-r1.xyz, r8.xyz));
          r7.w = r2.w * r2.w;
          r7.w = r7.w * r7.w;
          r8.x = r6.w * r7.w + -r6.w;
          r6.w = r8.x * r6.w + 1;
          r6.w = r6.w * r6.w;
          r6.w = r7.w / r6.w;
          r6.w = 0.318309873 * r6.w;
          r2.w = r2.w * 0.5 + 0.5;
          r2.w = r2.w * r2.w;
          r7.w = 0.5 * r2.w;
          r2.w = -r2.w * 0.5 + 1;
          r4.z = r4.z * r2.w + r7.w;
          r4.z = 1 / r4.z;
          r0.y = r0.y * r2.w + r7.w;
          r0.y = 1 / r0.y;
          r0.y = r0.y * r4.z;
          r0.y = r0.y * r6.w;
          r2.w = saturate(50 * r2.y);
          r8.xyz = -r9.xyz * r0.zzz + r2.www;
          r2.w = r7.z * -5.55472994 + -6.98316002;
          r2.w = r2.w * r7.z;
          r2.w = exp2(r2.w);
          r8.xyz = r8.xyz * r2.www + r2.xyz;
          r0.y = 0.25 * r0.y;
          r8.xyz = r0.yyy * r8.xyz;
          r12.xyz = r8.xyz * r1.www;
        }
        if (r0.w != 0) {
          r4.x = saturate(r7.x * 0.5 + 0.5);
          r8.xyz = PreIntegratedBRDFTexture.SampleLevel(PreIntegratedBRDFTexture_s, r4.xw, 0).xyz;
          r8.xyz = r8.xyz * r6.xyz;
          r7.x = saturate(r7.x);
          r11.xyz = r7.xxx * r12.xyz;
          r8.xyz = r8.xyz * float3(0.318309873,0.318309873,0.318309873) + r11.xyz;
        } else {
          if (r5.x != 0) {
            r0.y = dot(r5.yzw, r5.yzw);
            r0.y = rsqrt(r0.y);
            r11.xyz = r5.yzw * r0.yyy;
            r5.xyz = r5.yzw * r0.yyy + -r1.xyz;
            r0.y = dot(r5.xyz, r5.xyz);
            r0.y = rsqrt(r0.y);
            r5.xyz = r5.xyz * r0.yyy;
            r0.y = saturate(dot(r3.xyz, r11.xyz));
            r0.w = saturate(dot(r3.xyz, -r1.xyz));
            r1.w = saturate(dot(r3.xyz, r5.xyz));
            r2.w = saturate(dot(-r1.xyz, r5.xyz));
            r4.x = saturate(r4.x);
            r3.x = r4.x * r4.x;
            r3.x = r3.x * r3.x;
            r3.x = 2 / r3.x;
            r3.y = -2 + r3.x;
            r3.x = 0.5 * r3.x;
            r3.z = cmp(r1.w < 9.99999997e-07);
            r4.x = log2(r1.w);
            r3.y = r4.x * r3.y;
            r3.y = exp2(r3.y);
            r3.y = r3.z ? 0 : r3.y;
            r3.x = r3.x * r3.y;
            r1.x = dot(r11.xyz, -r1.xyz);
            r1.x = r1.x * 2 + 2;
            r1.x = 1 / r1.x;
            r1.y = saturate(50 * r4.y);
            r1.y = r1.y + -r4.y;
            r1.z = r2.w * -5.55472994 + -6.98316002;
            r1.z = r1.z * r2.w;
            r1.z = exp2(r1.z);
            r1.y = r1.y * r1.z + r4.y;
            r1.x = r3.x * r1.x;
            r1.x = saturate(r1.x * r1.y);
            r2.w = r9.w * r9.w;
            r2.w = r2.w * r2.w;
            r3.x = r1.w * r2.w + -r1.w;
            r1.w = r3.x * r1.w + 1;
            r1.w = r1.w * r1.w;
            r1.w = r2.w / r1.w;
            r2.w = r8.w * 0.25 + 0.5;
            r2.w = r2.w * r2.w;
            r3.x = 0.5 * r2.w;
            r2.w = -r2.w * 0.5 + 1;
            r0.w = r0.w * r2.w + r3.x;
            r0.w = 1 / r0.w;
            r0.y = r0.y * r2.w + r3.x;
            r0.y = 1 / r0.y;
            r0.y = r0.y * r0.w;
            r0.y = r0.y * r1.w;
            r0.w = saturate(50 * r2.y);
            r3.xyz = -r9.xyz * r0.zzz + r0.www;
            r2.xyz = r3.xyz * r1.zzz + r2.xyz;
            r0.y = 0.25 * r0.y;
            r0.yzw = r0.yyy * r2.xyz;
            r0.yzw = r6.xyz * float3(0.318309873,0.318309873,0.318309873) + r0.yzw;
            r1.y = 1 + -r1.y;
            r8.xyz = r0.yzw * r1.yyy + r1.xxx;
          } else {
            r0.yzw = float3(0.318309873,0.318309873,0.318309873) * r6.xyz;
            r7.x = saturate(r7.x);
            r1.x = r7.x * -r4.w + r4.w;
            r1.y = 1 + -r1.x;
            r1.yzw = r0.yzw * r1.yyy + r12.xyz;
            r0.yzw = r1.xxx * r0.yzw;
            r8.xyz = r7.xxx * r1.yzw + r0.yzw;
          }
        }
        r0.yzw = r10.www * r10.xyz;
        r1.x = r7.y * r3.w;
        r0.yzw = r1.xxx * r0.yzw;
        r0.yzw = LightProperties.Color.xyz * r0.yzw;
        r0.yzw = r8.xyz * r0.yzw;
      } else {
        r0.yzw = float3(0,0,0);
      }
      r0.xyz = r0.yzw * r0.xxx;
    } else {
      r0.xyz = float3(0,0,0);
    }
  } else {
    r0.xyz = float3(0,0,0);
  }
  o0.xyz = r0.xyz;
  o0.w = 0;
  return;
}