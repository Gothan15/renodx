// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 14:02:36 2026
groupshared uint g0, g1, g2;
groupshared struct { float val[1]; } g3[682];

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
  uint4 ViewDimensions : packoffset(c31);
  float2 BufferDimensions : packoffset(c32);
  float4x4 ProjMatrix : packoffset(c33);
  float4x4 ViewMatrix : packoffset(c37);
  float4 MinZ_MaxZRatioCB : packoffset(c41);
  float3 CameraPositionCB : packoffset(c42);
  uint NumLights : packoffset(c42.w);
}

cbuffer TileDeferredLightBase : register(b8)
{

  struct
  {
    float3 ViewPosition;
    float Radius;
  } LightBufferBase[682] : packoffset(c0);

}

cbuffer TileDeferredLight : register(b9)
{

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
  } LightBuffer[682] : packoffset(c0);

}

SamplerState WorldNormalGBufferTexture_s : register(s0);
SamplerState SpecularGBufferTexture_s : register(s1);
SamplerState DiffuseGBufferTexture_s : register(s2);
SamplerState TransmissionGBufferTexture_s : register(s3);
SamplerState SceneDepthTexture_s : register(s4);
SamplerState LightAttenuationTexture_s : register(s5);
SamplerState PreIntegratedBRDFTexture_s : register(s6);
SamplerState EmissiveGBufferTexture_s : register(s7);
Texture2D<float4> WorldNormalGBufferTexture : register(t0);
Texture2D<float4> DiffuseGBufferTexture : register(t1);
Texture2D<float4> SceneDepthTexture : register(t2);
Texture2D<float4> SpecularGBufferTexture : register(t3);
Texture2D<float4> TransmissionGBufferTexture : register(t4);
Texture2D<float4> EmissiveGBufferTexture : register(t5);
Texture2D<float4> LightAttenuationTexture : register(t6);
Texture2D<float4> PreIntegratedBRDFTexture : register(t7);
Texture3D<uint> LightVolumeClippingTexture : register(t8);
Texture3D<uint> VisBlockingTexture : register(t9);
RWTexture2D<float4> OutputBuffer : register(u0);


// 3Dmigoto declarations
#define cmp -


[numthreads(16,16,1)]
void main(uint3 vThreadGroupID : SV_GroupID, uint3 vThreadIDInGroup : SV_GroupThreadID, uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,r21,r22,r23,r24;
  uint4 bitmask, uiDest;
  float4 fDest;
  r0.xy = (int2)vThreadID.xy + (int2)ViewDimensions.zw;
  r0.xy = (uint2)r0.xy;
  r0.xy = float2(0.5,0.5) + r0.xy;
  r0.zw = rcp(BufferDimensions.xy);
  r0.xy = r0.xy * r0.zw;
  r0.z = SceneDepthTexture.SampleLevel(SceneDepthTexture_s, r0.xy, 0).x;
  r0.z = min(0.999000013, r0.z);
  r0.z = r0.z * MinZ_MaxZRatioCB.z + -MinZ_MaxZRatioCB.w;
  r0.z = 1 / r0.z;
  r0.w = min(2.13909504e+09, r0.z);
  r1.x = max(0, r0.z);
  r1.y = mad((int)vThreadIDInGroup.y, 16, (int)vThreadIDInGroup.x);
  if (r1.y == 0) {
    g0 = asuint(r0.w);
    g1 = asuint(r1.x);
    g2 = 0;
  }
  GroupMemoryBarrierWithGroupSync();
  r1.z = cmp(r1.x >= r0.w);
  if (r1.z != 0) {
    InterlockedMin(g0, asuint(r0.w));
    InterlockedMax(g1, asuint(r1.x));
  }
  GroupMemoryBarrierWithGroupSync();
  r0.w = asfloat(g0);
  r2.y = asfloat(g1);
  r1.xz = (uint2)ViewDimensions.xy;
  r2.zw = float2(0.03125,0.03125) * r1.xz;
  r3.xy = (uint2)vThreadGroupID.xy;
  r3.zw = r1.xz * float2(0.03125,0.03125) + -r3.xy;
  r3.y = ProjMatrix._m00 * r2.z;
  r3.x = -ProjMatrix._m11 * r2.w;
  r4.xyzw = float4(0,1,0,1) + -r3.yzxw;
  r3.xyzw = float4(0,1,0,1) + r3.yzxw;
  r5.w = -r0.w;
  r0.w = dot(r4.xy, r4.xy);
  r0.w = sqrt(r0.w);
  r0.w = rcp(r0.w);
  r2.zw = r4.xy * r0.ww;
  r0.w = dot(r3.xy, r3.xy);
  r0.w = sqrt(r0.w);
  r0.w = rcp(r0.w);
  r3.xy = r3.xy * r0.ww;
  r0.w = dot(r4.zw, r4.zw);
  r0.w = sqrt(r0.w);
  r0.w = rcp(r0.w);
  r4.xy = r4.zw * r0.ww;
  r0.w = dot(r3.zw, r3.zw);
  r0.w = sqrt(r0.w);
  r0.w = rcp(r0.w);
  r3.zw = r3.zw * r0.ww;
  r0.w = r1.y;
  while (true) {
    r1.w = cmp((uint)r0.w >= NumLights);
    if (r1.w != 0) break;
    r5.x = abs(LightBufferBase[r0.w].ViewPosition.z);
    r5.yz = LightBufferBase[r0.w].ViewPosition.xy;
    r1.w = dot(r2.wz, r5.xy);
    r1.w = cmp(r1.w >= -LightBufferBase[r0.w].Radius);
    r4.z = dot(r3.yx, r5.xy);
    r4.z = cmp(r4.z >= -LightBufferBase[r0.w].Radius);
    r1.w = r1.w ? r4.z : 0;
    r4.z = dot(r4.yx, r5.xz);
    r4.z = cmp(r4.z >= -LightBufferBase[r0.w].Radius);
    r1.w = r1.w ? r4.z : 0;
    r4.z = dot(r3.wz, r5.xz);
    r4.z = cmp(r4.z >= -LightBufferBase[r0.w].Radius);
    r1.w = r1.w ? r4.z : 0;
    r4.z = dot(float2(1,1), r5.xw);
    r4.z = cmp(r4.z >= -LightBufferBase[r0.w].Radius);
    r1.w = r1.w ? r4.z : 0;
    r2.x = r5.x;
    r2.x = dot(float2(-1,1), r2.xy);
    r2.x = cmp(r2.x >= -LightBufferBase[r0.w].Radius);
    r1.w = r1.w ? r2.x : 0;
    if (r1.w != 0) {
      uint g2Orig;
      InterlockedAdd(g2, 1, g2Orig);
      g3[g2Orig].val[0] = r0.w;
    }
    r0.w = (int)r0.w + 256;
  }
  GroupMemoryBarrierWithGroupSync();
  r0.w = g2;
  r1.yw = (uint2)vThreadID.xy;
  r1.yw = float2(0.5,0.5) + r1.yw;
  r1.xz = rcp(r1.xz);
  r1.xy = r1.yw * r1.xz + float2(-0.5,-0.5);
  r1.xy = r1.xy * r0.zz;
  r2.xyzw = WorldNormalGBufferTexture.SampleLevel(WorldNormalGBufferTexture_s, r0.xy, 0).xyzw;
  r2.xyz = r2.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r3.xyzw = DiffuseGBufferTexture.SampleLevel(DiffuseGBufferTexture_s, r0.xy, 0).xyzw;
  r4.xyzw = SpecularGBufferTexture.SampleLevel(SpecularGBufferTexture_s, r0.xy, 0).xyzw;
  r4.xyzw = float4(1,1,1,1) + r4.xyzw;
  r5.xyzw = float4(0.5,0.5,0.5,0.5) * r4.xyzw;
  r1.z = 255 * r2.w;
  r1.z = ceil(r1.z);
  r1.z = (uint)r1.z;
  r6.xyzw = TransmissionGBufferTexture.SampleLevel(TransmissionGBufferTexture_s, r0.xy, 0).xyzw;
  r7.xyzw = LightAttenuationTexture.SampleLevel(LightAttenuationTexture_s, r0.xy, 0).xyzw;
  r7.xyzw = r7.xyzw * r7.xyzw;
  r8.xyzw = (int4)r1.zzzz & int4(36,8,32,4);
  r4.xyz = r6.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r4.xyz = r8.xxx ? r4.xyz : r6.xyz;
  r1.xy = float2(2,-2) * r1.xy;
  r6.xyz = ScreenToWorldMatrix._m01_m11_m21 * r1.yyy;
  r1.xyw = ScreenToWorldMatrix._m00_m10_m20 * r1.xxx + r6.xyz;
  r1.xyw = ScreenToWorldMatrix._m02_m12_m22 * r0.zzz + r1.xyw;
  r1.xyw = ScreenToWorldMatrix._m03_m13_m23 + r1.xyw;
  r6.xyz = -CameraPositionCB.xyz + r1.xyw;
  r0.z = dot(r6.xyz, r6.xyz);
  r0.z = rsqrt(r0.z);
  r6.xyz = r6.xyz * r0.zzz;
  r0.z = dot(r2.xyz, r2.xyz);
  r0.z = rsqrt(r0.z);
  r2.xyz = r2.xyz * r0.zzz;
  r9.xyz = float3(0.318309873,0.318309873,0.318309873) * r3.xyz;
  r10.xyz = -LevelVolumePosition.xyz + r1.xyw;
  r10.xyz = r10.xyz / LevelVolumeDimensions.xyz;
  r11.xyz = VoxelSizeXYZ.xyz * r10.xyz;
  r10.xyz = r10.xyz * VoxelSizeXYZ.xyz + float3(-0.5,-0.5,-0.5);
  r12.xyz = floor(r10.xyz);
  r12.xyz = (uint3)r12.xyz;
  r13.xyz = (uint3)r12.xyz;
  r10.xyz = saturate(-r13.xyz + r10.xyz);
  r11.xyz = floor(r11.xyz);
  r11.xyz = (uint3)r11.xyz;
  r11.w = 0;
  r0.z = VisBlockingTexture.Load(r11.xyzw).x;
  r11.xyzw = (int4)r0.zzzz & int4(2,1,8,4);
  r11.xyzw = cmp((int4)r11.xyzw != int4(0,0,0,0));
  r14.xyz = cmp(r10.xyz < float3(0.5,0.5,0.5));
  r11.xz = r11.xz ? r14.xy : 0;
  r10.xy = r11.xz ? float2(0,0) : r10.xy;
  r11.xz = cmp(float2(0.5,0.5) < r10.xy);
  r11.xy = r11.xz ? r11.yw : 0;
  r11.xy = r11.xy ? float2(1,1) : r10.xy;
  r10.xy = (int2)r0.zz & int2(32,16);
  r10.xy = cmp((int2)r10.xy != int2(0,0));
  r0.z = r14.z ? r10.x : 0;
  r0.z = r0.z ? 0 : r10.z;
  r2.w = cmp(0.5 < r0.z);
  r2.w = r2.w ? r10.y : 0;
  r11.z = r2.w ? 1 : r0.z;
  r10.xyz = float3(1,1,1) + -r11.xyz;
  r12.w = 0;
  r0.z = LightVolumeClippingTexture.Load(r12.xyzw).x;
  r12.xyz = float3(1,0,0) + r13.xyz;
  r12.xyz = (uint3)r12.xyz;
  r12.w = 0;
  r2.w = LightVolumeClippingTexture.Load(r12.xyzw).x;
  r12.xyz = float3(1,1,0) + r13.xyz;
  r12.xyz = (uint3)r12.xyz;
  r12.w = 0;
  r8.x = LightVolumeClippingTexture.Load(r12.xyzw).x;
  r12.xyz = float3(0,1,0) + r13.xyz;
  r12.xyz = (uint3)r12.xyz;
  r12.w = 0;
  r9.w = LightVolumeClippingTexture.Load(r12.xyzw).x;
  r12.xyz = float3(0,0,1) + r13.xyz;
  r12.xyz = (uint3)r12.xyz;
  r12.w = 0;
  r10.w = LightVolumeClippingTexture.Load(r12.xyzw).x;
  r12.xyz = float3(1,0,1) + r13.xyz;
  r12.xyz = (uint3)r12.xyz;
  r12.w = 0;
  r11.w = LightVolumeClippingTexture.Load(r12.xyzw).x;
  r12.xyz = float3(1,1,1) + r13.xyz;
  r12.xyz = (uint3)r12.xyz;
  r12.w = 0;
  r12.x = LightVolumeClippingTexture.Load(r12.xyzw).x;
  r12.yzw = float3(0,1,1) + r13.xyz;
  r13.xyz = (uint3)r12.yzw;
  r13.w = 0;
  r12.y = LightVolumeClippingTexture.Load(r13.xyzw).x;
  r3.w = r3.w * 0.75 + 0.25;
  r8.y = cmp((int)r8.y == 0);
  r12.z = dot(-r6.xyz, r4.xyz);
  r12.w = dot(r6.xyz, r2.xyz);
  r12.w = r12.w + r12.w;
  r13.xyz = r2.xyz * -r12.www + r6.xyz;
  r12.w = r5.w * r5.w;
  r13.w = -r12.z * r12.z + 1;
  r13.w = sqrt(r13.w);
  r14.x = saturate(dot(r2.xyz, -r6.xyz));
  r1.z = (int)r1.z & 2;
  r14.y = saturate(r4.x);
  r14.y = r14.y * r14.y;
  r14.y = r14.y * r14.y;
  r14.y = 2 / r14.y;
  r14.z = -2 + r14.y;
  r14.y = 0.5 * r14.y;
  r14.w = saturate(50 * r4.y);
  r14.w = r14.w + -r4.y;
  r15.x = r12.w * r12.w;
  r4.w = r4.w * 0.25 + 0.5;
  r4.w = r4.w * r4.w;
  r15.y = 0.5 * r4.w;
  r4.w = -r4.w * 0.5 + 1;
  r15.z = r14.x * r4.w + r15.y;
  r15.z = 1 / r15.z;
  r15.z = 0.25 * r15.z;
  r16.y = r6.w;
  r17.xyz = float3(0,0,0);
  r15.w = 0;
  while (true) {
    r16.z = cmp((uint)r15.w >= (uint)r0.w);
    if (r16.z != 0) break;
    r16.z = g3[r15.w].val[0];
    r16.z = (int)r16.z;
    if (LightBuffer[r16.z].LightID != 0) {
      r16.w = (int)r0.z & (int)LightBuffer[r16.z].LightID;
      r17.w = (int)r2.w & (int)LightBuffer[r16.z].LightID;
      r18.x = (int)r8.x & (int)LightBuffer[r16.z].LightID;
      r18.y = (int)r9.w & (int)LightBuffer[r16.z].LightID;
      r18.z = (int)r10.w & (int)LightBuffer[r16.z].LightID;
      r18.w = (int)r11.w & (int)LightBuffer[r16.z].LightID;
      r19.xy = (int2)r12.xy & (int)LightBuffer[r16.z].LightID;
      r16.w = r16.w ? r10.x : 0;
      r17.w = r17.w ? r11.x : 0;
      r16.w = r17.w + r16.w;
      r17.w = r18.y ? r10.x : 0;
      r18.x = r18.x ? r11.x : 0;
      r17.w = r18.x + r17.w;
      r17.w = r17.w * r11.y;
      r16.w = r16.w * r10.y + r17.w;
      r17.w = r18.z ? r10.x : 0;
      r18.x = r18.w ? r11.x : 0;
      r17.w = r18.x + r17.w;
      r18.x = r19.y ? r10.x : 0;
      r18.y = r19.x ? r11.x : 0;
      r18.x = r18.x + r18.y;
      r18.x = r18.x * r11.y;
      r17.w = r17.w * r10.y + r18.x;
      r17.w = r17.w * r11.z;
      r16.w = r16.w * r10.z + r17.w;
      r16.w = log2(r16.w);
      r16.w = 2.5 * r16.w;
      r16.w = exp2(r16.w);
    } else {
      r16.w = 1;
    }
    r17.w = cmp(0 < LightBuffer[r16.z].CharacterLight);
    r17.w = r8.y ? r17.w : 0;
    r18.x = cmp(0 < LightBuffer[r16.z].InvRadius);
    if (r18.x != 0) {
      r18.xyz = LightBuffer[r16.z].WorldPosition.xyz + -r1.xyw;
      r18.w = dot(r18.xyz, r18.xyz);
      r19.x = rsqrt(r18.w);
      r19.xyz = r19.xxx * r18.xyz;
      r19.w = sqrt(r18.w);
      r20.x = cmp(0 < LightBuffer[r16.z].InvSquaredFalloff);
      r20.y = cmp(0 < LightBuffer[r16.z].SourceLength);
      r21.xyz = LightBuffer[r16.z].Direction.xyz * float3(-0.5,-0.5,-0.5);
      r22.xyz = -r21.xyz * LightBuffer[r16.z].SourceLength + r18.xyz;
      r21.xyz = r21.xyz * LightBuffer[r16.z].SourceLength + r18.xyz;
      r20.z = dot(r22.xyz, r22.xyz);
      r20.w = dot(r21.xyz, r21.xyz);
      r20.zw = sqrt(r20.zw);
      r21.w = dot(r22.xyz, r21.xyz);
      r21.w = r20.z * r20.w + r21.w;
      r21.w = 9.99999975e-05 + r21.w;
      r21.w = 2 / r21.w;
      r23.y = 32000 * r21.w;
      r21.w = dot(r2.xyz, r22.xyz);
      r21.x = dot(r2.xyz, r21.xyz);
      r20.zw = r21.wx / r20.zw;
      r20.z = r20.z + r20.w;
      r23.x = saturate(0.5 * r20.z);
      r18.w = 1 + r18.w;
      r18.w = 1 / r18.w;
      r21.y = 32000 * r18.w;
      r21.x = dot(r2.xyz, r19.xyz);
      r22.xy = r20.yy ? r23.xy : r21.xy;
      r18.w = LightBuffer[r16.z].InvRadius * r19.w;
      r18.w = r18.w * r18.w;
      r18.w = -r18.w * r18.w + 1;
      r18.w = max(0, r18.w);
      r18.w = r18.w * r18.w;
      r22.z = r22.y * r18.w;
      r20.yzw = LightBuffer[r16.z].InvRadius * r18.xyz;
      r18.w = dot(r20.yzw, r20.yzw);
      r18.w = min(1, r18.w);
      r18.w = 1 + -r18.w;
      r18.w = log2(r18.w);
      r18.w = LightBuffer[r16.z].FallOffExponent * r18.w;
      r21.z = exp2(r18.w);
      r20.xy = r20.xx ? r22.xz : r21.xz;
      r18.w = dot(r19.xyz, LightBuffer[r16.z].Direction.xyz);
      r18.w = -LightBuffer[r16.z].SpotAngles.x + r18.w;
      r18.w = saturate(LightBuffer[r16.z].SpotAngles.y * r18.w);
      r18.w = r18.w * r18.w;
    } else {
      r20.x = dot(r2.xyz, LightBuffer[r16.z].Direction.xyz);
      r18.xyz = LightBuffer[r16.z].Direction.xyz;
      r20.y = 1;
      r18.w = 1;
    }
    r19.x = cmp(0 < r20.y);
    r19.y = cmp(0 < r18.w);
    r19.x = r19.y ? r19.x : 0;
    r17.w = cmp((int)r17.w == 0);
    r17.w = r17.w ? r19.x : 0;
    if (r17.w != 0) {
      r17.w = cmp(LightBuffer[r16.z].InvRadius == 0.000000);
      r19.xyzw = r17.wwww ? r7.xyzw : float4(1,1,1,1);
      r21.xyzw = r19.xyzw * r3.wwww;
      r17.w = saturate(r3.w * r19.w + -LightBuffer[r16.z].MinShadowOpacity.x);
      r17.w = LightBuffer[r16.z].MinShadowOpacity.y * r17.w;
      r19.xyz = r17.www * r5.xyz;
      r19.w = cmp(0 < LightBuffer[r16.z].SourceRadius);
      if (r19.w != 0) {
        r19.w = cmp(0 < LightBuffer[r16.z].SourceLength);
        if (r19.w != 0) {
          r19.w = dot(-LightBuffer[r16.z].Direction.xyz, -LightBuffer[r16.z].Direction.xyz);
          r19.w = rsqrt(r19.w);
          r22.xyz = -LightBuffer[r16.z].Direction.xyz * r19.www;
          r23.xyz = float3(0.5,0.5,0.5) * r22.xyz;
          r23.xyz = -r23.xyz * LightBuffer[r16.z].SourceLength + r18.xyz;
          r22.xyz = LightBuffer[r16.z].SourceLength * r22.xyz;
          r19.w = dot(r13.xyz, r22.xyz);
          r24.xyz = r19.www * r13.xyz + -r22.xyz;
          r20.z = dot(r23.xyz, r24.xyz);
          r19.w = r19.w * r19.w;
          r19.w = LightBuffer[r16.z].SourceLength * LightBuffer[r16.z].SourceLength + -r19.w;
          r19.w = saturate(r20.z / r19.w);
          r22.xyz = r19.www * r22.xyz + r23.xyz;
          r19.w = dot(r22.xyz, r13.xyz);
          r23.xyz = r19.www * r13.xyz + -r22.xyz;
          r19.w = dot(r23.xyz, r23.xyz);
          r19.w = sqrt(r19.w);
          r19.w = saturate(LightBuffer[r16.z].SourceRadius / r19.w);
          r22.xyz = r23.xyz * r19.www + r22.xyz;
          r19.w = dot(r22.xyz, r22.xyz);
          r19.w = sqrt(r19.w);
          r19.w = 1 / r19.w;
          r20.z = LightBuffer[r16.z].SourceLength * r19.w;
          r20.z = 1.57079637 * r20.z;
          r20.w = LightBuffer[r16.z].SourceLength * r19.w + 1;
          r20.z = r20.z / r20.w;
          r20.w = LightBuffer[r16.z].SourceRadius * r19.w;
          r20.w = 1.57079637 * r20.w;
          r19.w = LightBuffer[r16.z].SourceRadius * r19.w + 1;
          r19.w = r20.w / r19.w;
          r20.z = r20.z * 0.333330005 + r12.w;
          r20.z = sqrt(r20.z);
          r20.z = min(1, r20.z);
          r20.z = r5.w / r20.z;
          r20.z = r20.z * r20.z;
          r19.w = r19.w * 0.333330005 + r12.w;
          r19.w = sqrt(r19.w);
          r19.w = min(1, r19.w);
          r19.w = r5.w / r19.w;
          r19.w = r19.w * r19.w;
          r19.w = r19.w * r19.w;
          r19.w = r20.z * r19.w;
        } else {
          r20.z = dot(r18.xyz, r13.xyz);
          r23.xyz = r20.zzz * r13.xyz + -r18.xyz;
          r20.z = dot(r23.xyz, r23.xyz);
          r20.z = sqrt(r20.z);
          r20.z = saturate(LightBuffer[r16.z].SourceRadius / r20.z);
          r22.xyz = r23.xyz * r20.zzz + r18.xyz;
          r20.z = dot(r22.xyz, r22.xyz);
          r20.z = sqrt(r20.z);
          r20.z = LightBuffer[r16.z].SourceRadius / r20.z;
          r20.w = 1.57079637 * r20.z;
          r20.z = 1 + r20.z;
          r20.z = r20.w / r20.z;
          r20.z = r20.z * 0.333330005 + r12.w;
          r20.z = sqrt(r20.z);
          r20.z = min(1, r20.z);
          r20.z = r5.w / r20.z;
          r20.z = r20.z * r20.z;
          r19.w = r20.z * r20.z;
        }
        r20.z = r5.w;
      } else {
        r20.w = -LightBuffer[r16.z].MinRoughness + 1;
        r20.z = r5.w * r20.w + LightBuffer[r16.z].MinRoughness;
        r22.xyz = r18.xyz;
        r19.w = 1;
      }
      r20.w = dot(r22.xyz, r22.xyz);
      r20.w = rsqrt(r20.w);
      r23.xyz = r22.xyz * r20.www;
      if (r8.z != 0) {
        r22.w = dot(r23.xyz, r4.xyz);
        r23.w = -r22.w * r22.w + 1;
        r23.w = sqrt(r23.w);
        r22.w = r22.w * r12.z;
        r22.w = saturate(r23.w * r13.w + -r22.w);
        r23.w = r20.z * r20.z;
        r23.w = r23.w * r23.w;
        r23.w = 1 / r23.w;
        r24.x = cmp(r22.w < 9.99999997e-07);
        r22.w = log2(r22.w);
        r22.w = r23.w * r22.w;
        r22.w = exp2(r22.w);
        r22.w = r24.x ? 0 : r22.w;
        r24.xyz = r22.www * r19.xyz;
        r24.xyz = r24.xyz * r19.www;
      } else {
        r22.xyz = r22.xyz * r20.www + -r6.xyz;
        r20.w = dot(r22.xyz, r22.xyz);
        r20.w = rsqrt(r20.w);
        r22.xyz = r22.xyz * r20.www;
        r20.w = saturate(dot(r2.xyz, r23.xyz));
        r22.w = saturate(dot(r2.xyz, r22.xyz));
        r22.x = saturate(dot(-r6.xyz, r22.xyz));
        r22.y = r20.z * r20.z;
        r22.y = r22.y * r22.y;
        r22.z = r22.w * r22.y + -r22.w;
        r22.z = r22.z * r22.w + 1;
        r22.z = r22.z * r22.z;
        r22.y = r22.y / r22.z;
        r22.y = 0.318309873 * r22.y;
        r20.z = r20.z * 0.5 + 0.5;
        r20.z = r20.z * r20.z;
        r22.z = 0.5 * r20.z;
        r20.z = -r20.z * 0.5 + 1;
        r22.w = r14.x * r20.z + r22.z;
        r22.w = 1 / r22.w;
        r20.z = r20.w * r20.z + r22.z;
        r20.z = 1 / r20.z;
        r20.z = r20.z * r22.w;
        r20.z = r20.z * r22.y;
        r20.w = saturate(50 * r19.y);
        r22.yzw = -r5.xyz * r17.www + r20.www;
        r20.w = r22.x * -5.55472994 + -6.98316002;
        r20.w = r20.w * r22.x;
        r20.w = exp2(r20.w);
        r22.xyz = r22.yzw * r20.www + r19.xyz;
        r20.z = 0.25 * r20.z;
        r22.xyz = r20.zzz * r22.xyz;
        r24.xyz = r22.xyz * r19.www;
      }
      if (r8.w != 0) {
        r16.x = saturate(r20.x * 0.5 + 0.5);
        r22.xyz = PreIntegratedBRDFTexture.SampleLevel(PreIntegratedBRDFTexture_s, r16.xy, 0).xyz;
        r20.x = saturate(r20.x);
        r23.xyz = r20.xxx * r24.xyz;
        r22.xyz = r22.xyz * r9.xyz + r23.xyz;
      } else {
        if (r1.z != 0) {
          r16.x = dot(r18.xyz, r18.xyz);
          r16.x = rsqrt(r16.x);
          r23.xyz = r18.xyz * r16.xxx;
          r18.xyz = r18.xyz * r16.xxx + -r6.xyz;
          r16.x = dot(r18.xyz, r18.xyz);
          r16.x = rsqrt(r16.x);
          r18.xyz = r18.xyz * r16.xxx;
          r16.x = saturate(dot(r2.xyz, r23.xyz));
          r19.w = saturate(dot(r2.xyz, r18.xyz));
          r18.x = saturate(dot(-r6.xyz, r18.xyz));
          r18.y = cmp(r19.w < 9.99999997e-07);
          r18.z = log2(r19.w);
          r18.z = r18.z * r14.z;
          r18.z = exp2(r18.z);
          r18.y = r18.y ? 0 : r18.z;
          r18.y = r18.y * r14.y;
          r18.z = dot(r23.xyz, -r6.xyz);
          r18.z = r18.z * 2 + 2;
          r18.z = 1 / r18.z;
          r20.z = r18.x * -5.55472994 + -6.98316002;
          r18.x = r20.z * r18.x;
          r18.x = exp2(r18.x);
          r20.z = r14.w * r18.x + r4.y;
          r18.y = r18.y * r18.z;
          r18.y = saturate(r18.y * r20.z);
          r18.z = r19.w * r15.x + -r19.w;
          r18.z = r18.z * r19.w + 1;
          r18.z = r18.z * r18.z;
          r18.z = r15.x / r18.z;
          r16.x = r16.x * r4.w + r15.y;
          r16.x = 1 / r16.x;
          r16.x = r16.x * r15.z;
          r19.w = saturate(50 * r19.y);
          r23.xyz = -r5.xyz * r17.www + r19.www;
          r19.xyz = r23.xyz * r18.xxx + r19.xyz;
          r16.x = r18.z * r16.x;
          r19.xyz = r16.xxx * r19.xyz;
          r19.xyz = r3.xyz * float3(0.318309873,0.318309873,0.318309873) + r19.xyz;
          r16.x = 1 + -r20.z;
          r22.xyz = r19.xyz * r16.xxx + r18.yyy;
        } else {
          r20.x = saturate(r20.x);
          r16.x = r20.x * -r6.w + r6.w;
          r17.w = 1 + -r16.x;
          r18.xyz = r9.xyz * r17.www + r24.xyz;
          r19.xyz = r16.xxx * r9.xyz;
          r22.xyz = r20.xxx * r18.xyz + r19.xyz;
        }
      }
      r18.xyz = r21.www * r21.xyz;
      r16.x = r20.y * r18.w;
      r18.xyz = r16.xxx * r18.xyz;
      r18.xyz = LightBuffer[r16.z].Color.xyz * r18.xyz;
      r18.xyz = r22.xyz * r18.xyz;
    } else {
      r18.xyz = float3(0,0,0);
    }
    r17.xyz = r18.xyz * r16.www + r17.xyz;
    r15.w = (int)r15.w + 1;
  }
  r0.zw = cmp((uint2)vThreadID.xy < (uint2)ViewDimensions.xy);
  r0.z = r0.w ? r0.z : 0;
  if (r0.z != 0) {
    r0.xyz = EmissiveGBufferTexture.SampleLevel(EmissiveGBufferTexture_s, r0.xy, 0).xyz;
    r0.xyz = r17.xyz + r0.xyz;
    r0.w = 0;
    OutputBuffer[vThreadID.xy] = r0;
  }
  return;
}