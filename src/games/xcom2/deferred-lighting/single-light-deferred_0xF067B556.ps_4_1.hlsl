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
    r3.xyzw = WorldNormalGBufferTexture.SampleLevel(WorldNormalGBufferTexture_s, r0.zw, 0).xyzw;
    r3.xyz = r3.xyz * float3(2,2,2) + float3(-1,-1,-1);
    r0.x = dot(r3.xyz, r3.xyz);
    r0.x = rsqrt(r0.x);
    r3.xyz = r3.xyz * r0.xxx;
    r0.x = 255 * r3.w;
    r0.x = ceil(r0.x);
    r0.x = (uint)r0.x;
    r4.xyzw = TransmissionGBufferTexture.SampleLevel(TransmissionGBufferTexture_s, r0.zw, 0).xyzw;
    r5.xy = (int2)r0.xx & int2(2,8);
    if (r5.x == 0) {
      r0.y = (int)r0.x & 4;
      if (r0.y != 0) {
        r4.xyz = r4.xyz * float3(2,2,2) + float3(-1,-1,-1);
      } else {
        r0.y = (int)r0.x & 32;
        if (r0.y != 0) {
          r4.xyz = r4.xyz * float3(2,2,2) + float3(-1,-1,-1);
        } else {
          r4.xyz = float3(0,0,0);
        }
      }
    }
    r0.y = cmp(0 < LightProperties.CharacterLight);
    r1.w = cmp((int)r5.y == 0);
    r0.y = r0.y ? r1.w : 0;
    r1.w = cmp(0 < LightProperties.InvRadius);
    if (r1.w != 0) {
      r5.yzw = LightProperties.WorldPosition.xyz + -r1.xyz;
      r1.w = dot(r5.yzw, r5.yzw);
      r3.w = rsqrt(r1.w);
      r6.xyz = r5.yzw * r3.www;
      r3.w = sqrt(r1.w);
      r6.w = cmp(0 < LightProperties.InvSquaredFalloff);
      r7.x = cmp(0 < LightProperties.SourceLength);
      r7.yzw = LightProperties.SourceLength * -LightProperties.Direction.xyz;
      r8.xyz = -r7.yzw * float3(0.5,0.5,0.5) + r5.yzw;
      r7.yzw = r7.yzw * float3(0.5,0.5,0.5) + r5.yzw;
      r8.w = dot(r8.xyz, r8.xyz);
      r8.w = sqrt(r8.w);
      r9.x = dot(r7.yzw, r7.yzw);
      r9.x = sqrt(r9.x);
      r9.y = dot(r8.xyz, r7.yzw);
      r9.y = r8.w * r9.x + r9.y;
      r9.y = 9.99999975e-05 + r9.y;
      r9.y = 2 / r9.y;
      r10.y = 32000 * r9.y;
      r8.x = dot(r3.xyz, r8.xyz);
      r8.x = r8.x / r8.w;
      r7.y = dot(r3.xyz, r7.yzw);
      r7.y = r7.y / r9.x;
      r7.y = r8.x + r7.y;
      r10.x = saturate(0.5 * r7.y);
      r1.w = 1 + r1.w;
      r1.w = 1 / r1.w;
      r8.y = 32000 * r1.w;
      r8.x = dot(r3.xyz, r6.xyz);
      r7.xy = r7.xx ? r10.xy : r8.xy;
      r1.w = LightProperties.InvRadius * r3.w;
      r1.w = r1.w * r1.w;
      r1.w = -r1.w * r1.w + 1;
      r1.w = max(0, r1.w);
      r1.w = r1.w * r1.w;
      r7.z = r7.y * r1.w;
      r9.xyz = LightProperties.InvRadius * r5.yzw;
      r1.w = dot(r9.xyz, r9.xyz);
      r1.w = min(1, r1.w);
      r1.w = 1 + -r1.w;
      r1.w = log2(r1.w);
      r1.w = LightProperties.FallOffExponent * r1.w;
      r8.z = exp2(r1.w);
      r7.xy = r6.ww ? r7.xz : r8.xz;
      r1.w = dot(r6.xyz, LightProperties.Direction.xyz);
      r1.w = -LightProperties.SpotAngles.x + r1.w;
      r1.w = saturate(LightProperties.SpotAngles.y * r1.w);
      r1.w = r1.w * r1.w;
    } else {
      r7.x = dot(r3.xyz, LightProperties.Direction.xyz);
      r5.yzw = LightProperties.Direction.xyz;
      r7.y = 1;
      r1.w = 1;
    }
    r3.w = cmp(0 < r7.y);
    r6.x = cmp(0 < r1.w);
    r3.w = r3.w ? r6.x : 0;
    r0.y = cmp((int)r0.y == 0);
    r0.y = r0.y ? r3.w : 0;
    if (r0.y != 0) {
      r6.xyzw = DiffuseGBufferTexture.SampleLevel(DiffuseGBufferTexture_s, r0.zw, 0).xyzw;
      r1.xyz = -CameraPositionPS.xyz + r1.xyz;
      r0.y = dot(r1.xyz, r1.xyz);
      r0.y = rsqrt(r0.y);
      r1.xyz = r1.xyz * r0.yyy;
      r8.xyzw = SpecularGBufferTexture.SampleLevel(SpecularGBufferTexture_s, r0.zw, 0).xyzw;
      r8.xyzw = float4(1,1,1,1) + r8.xyzw;
      r9.xyzw = float4(0.5,0.5,0.5,0.5) * r8.xyzw;
      r0.y = r6.w * 0.75 + 0.25;
      r10.xyzw = r0.yyyy * r2.xyzw;
      r0.y = saturate(r0.y * r2.w + -LightProperties.MinShadowOpacity.x);
      r0.y = LightProperties.MinShadowOpacity.y * r0.y;
      r2.xyz = r9.xyz * r0.yyy;
      r0.xz = (int2)r0.xx & int2(32,4);
      r0.w = cmp(0 < LightProperties.SourceRadius);
      if (r0.w != 0) {
        r0.w = cmp(0 < LightProperties.SourceLength);
        if (r0.w != 0) {
          r0.w = dot(-LightProperties.Direction.xyz, -LightProperties.Direction.xyz);
          r0.w = rsqrt(r0.w);
          r8.xyz = -LightProperties.Direction.xyz * r0.www;
          r0.w = dot(r1.xyz, r3.xyz);
          r0.w = r0.w + r0.w;
          r11.xyz = r3.xyz * -r0.www + r1.xyz;
          r8.xyz = LightProperties.SourceLength * r8.xyz;
          r12.xyz = -r8.xyz * float3(0.5,0.5,0.5) + r5.yzw;
          r0.w = dot(r11.xyz, r8.xyz);
          r13.xyz = r0.www * r11.xyz + -r8.xyz;
          r2.w = dot(r12.xyz, r13.xyz);
          r0.w = r0.w * r0.w;
          r0.w = LightProperties.SourceLength * LightProperties.SourceLength + -r0.w;
          r0.w = saturate(r2.w / r0.w);
          r8.xyz = r0.www * r8.xyz + r12.xyz;
          r0.w = dot(r8.xyz, r11.xyz);
          r11.xyz = r0.www * r11.xyz + -r8.xyz;
          r0.w = dot(r11.xyz, r11.xyz);
          r0.w = sqrt(r0.w);
          r0.w = saturate(LightProperties.SourceRadius / r0.w);
          r8.xyz = r11.xyz * r0.www + r8.xyz;
          r0.w = dot(r8.xyz, r8.xyz);
          r0.w = sqrt(r0.w);
          r0.w = 1 / r0.w;
          r2.w = LightProperties.SourceLength * r0.w;
          r2.w = 1.57079637 * r2.w;
          r3.w = LightProperties.SourceLength * r0.w + 1;
          r2.w = r2.w / r3.w;
          r3.w = LightProperties.SourceRadius * r0.w;
          r3.w = 1.57079637 * r3.w;
          r0.w = LightProperties.SourceRadius * r0.w + 1;
          r0.w = r3.w / r0.w;
          r3.w = r9.w * r9.w;
          r2.w = r2.w * 0.333330005 + r3.w;
          r2.w = sqrt(r2.w);
          r2.w = min(1, r2.w);
          r2.w = r9.w / r2.w;
          r2.w = r2.w * r2.w;
          r0.w = r0.w * 0.333330005 + r3.w;
          r0.w = sqrt(r0.w);
          r0.w = min(1, r0.w);
          r0.w = r9.w / r0.w;
          r0.w = r0.w * r0.w;
          r0.w = r0.w * r0.w;
          r0.w = r2.w * r0.w;
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
          r3.w = 1.57079637 * r2.w;
          r2.w = 1 + r2.w;
          r2.w = r3.w / r2.w;
          r2.w = 0.333330005 * r2.w;
          r2.w = r9.w * r9.w + r2.w;
          r2.w = sqrt(r2.w);
          r2.w = min(1, r2.w);
          r2.w = r9.w / r2.w;
          r2.w = r2.w * r2.w;
          r0.w = r2.w * r2.w;
        }
        r2.w = r9.w;
      } else {
        r3.w = 1 + -LightProperties.MinRoughness;
        r2.w = r9.w * r3.w + LightProperties.MinRoughness;
        r8.xyz = r5.yzw;
        r0.w = 1;
      }
      r3.w = dot(r8.xyz, r8.xyz);
      r3.w = rsqrt(r3.w);
      r11.xyz = r8.xyz * r3.www;
      if (r0.x != 0) {
        r0.x = dot(r11.xyz, r4.xyz);
        r6.w = -r0.x * r0.x + 1;
        r6.w = sqrt(r6.w);
        r4.z = dot(-r1.xyz, r4.xyz);
        r7.z = -r4.z * r4.z + 1;
        r7.z = sqrt(r7.z);
        r0.x = r4.z * r0.x;
        r0.x = saturate(r6.w * r7.z + -r0.x);
        r4.z = r2.w * r2.w;
        r4.z = r4.z * r4.z;
        r4.z = 1 / r4.z;
        r6.w = cmp(r0.x < 9.99999997e-07);
        r0.x = log2(r0.x);
        r0.x = r4.z * r0.x;
        r0.x = exp2(r0.x);
        r0.x = r6.w ? 0 : r0.x;
        r12.xyz = r0.xxx * r2.xyz;
        r12.xyz = r12.xyz * r0.www;
      } else {
        r8.xyz = r8.xyz * r3.www + -r1.xyz;
        r0.x = dot(r8.xyz, r8.xyz);
        r0.x = rsqrt(r0.x);
        r8.xyz = r8.xyz * r0.xxx;
        r0.x = saturate(dot(r3.xyz, r11.xyz));
        r3.w = saturate(dot(r3.xyz, -r1.xyz));
        r4.z = saturate(dot(r3.xyz, r8.xyz));
        r6.w = saturate(dot(-r1.xyz, r8.xyz));
        r7.z = r2.w * r2.w;
        r7.z = r7.z * r7.z;
        r7.w = r4.z * r7.z + -r4.z;
        r4.z = r7.w * r4.z + 1;
        r4.z = r4.z * r4.z;
        r4.z = r7.z / r4.z;
        r4.z = 0.318309873 * r4.z;
        r2.w = r2.w * 0.5 + 0.5;
        r2.w = r2.w * r2.w;
        r7.z = 0.5 * r2.w;
        r2.w = -r2.w * 0.5 + 1;
        r3.w = r3.w * r2.w + r7.z;
        r3.w = 1 / r3.w;
        r0.x = r0.x * r2.w + r7.z;
        r0.x = 1 / r0.x;
        r0.x = r0.x * r3.w;
        r0.x = r0.x * r4.z;
        r2.w = saturate(50 * r2.y);
        r8.xyz = -r9.xyz * r0.yyy + r2.www;
        r2.w = r6.w * -5.55472994 + -6.98316002;
        r2.w = r2.w * r6.w;
        r2.w = exp2(r2.w);
        r8.xyz = r8.xyz * r2.www + r2.xyz;
        r0.x = 0.25 * r0.x;
        r8.xyz = r0.xxx * r8.xyz;
        r12.xyz = r8.xyz * r0.www;
      }
      if (r0.z != 0) {
        r4.x = saturate(r7.x * 0.5 + 0.5);
        r0.xzw = PreIntegratedBRDFTexture.SampleLevel(PreIntegratedBRDFTexture_s, r4.xw, 0).xyz;
        r0.xzw = r6.xyz * r0.xzw;
        r7.x = saturate(r7.x);
        r8.xyz = r7.xxx * r12.xyz;
        r0.xzw = r0.xzw * float3(0.318309873,0.318309873,0.318309873) + r8.xyz;
      } else {
        if (r5.x != 0) {
          r2.w = dot(r5.yzw, r5.yzw);
          r2.w = rsqrt(r2.w);
          r8.xyz = r5.yzw * r2.www;
          r5.xyz = r5.yzw * r2.www + -r1.xyz;
          r2.w = dot(r5.xyz, r5.xyz);
          r2.w = rsqrt(r2.w);
          r5.xyz = r5.xyz * r2.www;
          r2.w = saturate(dot(r3.xyz, r8.xyz));
          r3.w = saturate(dot(r3.xyz, -r1.xyz));
          r3.x = saturate(dot(r3.xyz, r5.xyz));
          r3.y = saturate(dot(-r1.xyz, r5.xyz));
          r4.x = saturate(r4.x);
          r3.z = r4.x * r4.x;
          r3.z = r3.z * r3.z;
          r3.z = 2 / r3.z;
          r4.x = -2 + r3.z;
          r3.z = 0.5 * r3.z;
          r4.z = cmp(r3.x < 9.99999997e-07);
          r5.x = log2(r3.x);
          r4.x = r5.x * r4.x;
          r4.x = exp2(r4.x);
          r4.x = r4.z ? 0 : r4.x;
          r3.z = r4.x * r3.z;
          r1.x = dot(r8.xyz, -r1.xyz);
          r1.x = r1.x * 2 + 2;
          r1.x = 1 / r1.x;
          r1.y = saturate(50 * r4.y);
          r1.y = r1.y + -r4.y;
          r1.z = r3.y * -5.55472994 + -6.98316002;
          r1.z = r1.z * r3.y;
          r1.z = exp2(r1.z);
          r1.y = r1.y * r1.z + r4.y;
          r1.x = r3.z * r1.x;
          r1.x = saturate(r1.x * r1.y);
          r3.y = r9.w * r9.w;
          r3.y = r3.y * r3.y;
          r3.z = r3.x * r3.y + -r3.x;
          r3.x = r3.z * r3.x + 1;
          r3.x = r3.x * r3.x;
          r3.x = r3.y / r3.x;
          r3.y = r8.w * 0.25 + 0.5;
          r3.y = r3.y * r3.y;
          r3.z = 0.5 * r3.y;
          r3.y = -r3.y * 0.5 + 1;
          r3.w = r3.w * r3.y + r3.z;
          r3.w = 1 / r3.w;
          r2.w = r2.w * r3.y + r3.z;
          r2.w = 1 / r2.w;
          r2.w = r2.w * r3.w;
          r2.w = r2.w * r3.x;
          r3.x = saturate(50 * r2.y);
          r3.xyz = -r9.xyz * r0.yyy + r3.xxx;
          r2.xyz = r3.xyz * r1.zzz + r2.xyz;
          r0.y = 0.25 * r2.w;
          r2.xyz = r0.yyy * r2.xyz;
          r2.xyz = r6.xyz * float3(0.318309873,0.318309873,0.318309873) + r2.xyz;
          r0.y = 1 + -r1.y;
          r0.xzw = r2.xyz * r0.yyy + r1.xxx;
        } else {
          r1.xyz = float3(0.318309873,0.318309873,0.318309873) * r6.xyz;
          r7.x = saturate(r7.x);
          r0.y = r7.x * -r4.w + r4.w;
          r2.x = 1 + -r0.y;
          r2.xyz = r1.xyz * r2.xxx + r12.xyz;
          r1.xyz = r1.xyz * r0.yyy;
          r0.xzw = r7.xxx * r2.xyz + r1.xyz;
        }
      }
      r1.xyz = r10.www * r10.xyz;
      r0.y = r7.y * r1.w;
      r1.xyz = r0.yyy * r1.xyz;
      r1.xyz = LightProperties.Color.xyz * r1.xyz;
      r0.xyz = r1.xyz * r0.xzw;
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