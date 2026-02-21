// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 11:53:35 2026
// Manual fixes applied for groupshared memory, atomics, structured access, and UAV store
groupshared uint g0;  // tile min depth (float bits as uint for atomic min)
groupshared uint g1;  // tile max depth (float bits as uint for atomic max)
groupshared uint g2;  // culled light count
groupshared uint g3[682];  // culled light indices

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
SamplerState sSHCoeffs_s : register(s6);
SamplerState PreIntegratedBRDFTexture_s : register(s7);
SamplerState EmissiveGBufferTexture_s : register(s8);
Texture2D<float4> WorldNormalGBufferTexture : register(t0);
Texture2D<float4> DiffuseGBufferTexture : register(t1);
Texture2D<float4> SceneDepthTexture : register(t2);
Texture2D<float4> SpecularGBufferTexture : register(t3);
Texture2D<float4> TransmissionGBufferTexture : register(t4);
Texture2D<float4> EmissiveGBufferTexture : register(t5);
Texture2D<float4> LightAttenuationTexture : register(t6);
Texture2D<float4> PreIntegratedBRDFTexture : register(t7);
Texture3D<float4> sSHCoeffs : register(t8);
Texture3D<uint> LightVolumeClippingTexture : register(t9);
Texture3D<uint> VisBlockingTexture : register(t10);
RWTexture2D<float4> OutputBuffer : register(u0);


// 3Dmigoto declarations
#define cmp -


[numthreads(16, 16, 1)]
void main(uint3 vThreadGroupID : SV_GroupID, uint3 vThreadIDInGroup : SV_GroupThreadID, uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,r21,r22,r23,r24,r25,r26,r27;
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
      uint lightSlot;
      InterlockedAdd(g2, 1, lightSlot);
      g3[lightSlot] = (uint)r0.w;
    }
    r0.w = (int)r0.w + 256;
  }
  GroupMemoryBarrierWithGroupSync();
  r0.w = (float)g2;
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
  r12.xyz = r10.xyz * VoxelSizeXYZ.xyz + float3(-0.5,-0.5,-0.5);
  r13.xyz = floor(r12.xyz);
  r13.xyz = (uint3)r13.xyz;
  r14.xyz = (uint3)r13.xyz;
  r12.xyz = saturate(-r14.xyz + r12.xyz);
  r15.xyz = floor(r11.xyz);
  r16.xyz = (uint3)r15.xyz;
  r16.w = 0;
  r0.z = VisBlockingTexture.Load(r16.xyzw).x;
  r16.xyzw = (int4)r0.zzzz & int4(2,1,8,4);
  r16.xyzw = cmp((int4)r16.xyzw != int4(0,0,0,0));
  r17.xyz = cmp(r12.xyz < float3(0.5,0.5,0.5));
  r16.xz = r16.xz ? r17.xy : 0;
  r12.xy = r16.xz ? float2(0,0) : r12.xy;
  r16.xz = cmp(float2(0.5,0.5) < r12.xy);
  r16.xy = r16.xz ? r16.yw : 0;
  r16.xy = r16.xy ? float2(1,1) : r12.xy;
  r12.xy = (int2)r0.zz & int2(32,16);
  r12.xy = cmp((int2)r12.xy != int2(0,0));
  r0.z = r17.z ? r12.x : 0;
  r0.z = r0.z ? 0 : r12.z;
  r2.w = cmp(0.5 < r0.z);
  r2.w = r2.w ? r12.y : 0;
  r16.z = r2.w ? 1 : r0.z;
  r12.xyz = float3(1,1,1) + -r16.xyz;
  r13.w = 0;
  r0.z = LightVolumeClippingTexture.Load(r13.xyzw).x;
  r13.xyz = float3(1,0,0) + r14.xyz;
  r13.xyz = (uint3)r13.xyz;
  r13.w = 0;
  r2.w = LightVolumeClippingTexture.Load(r13.xyzw).x;
  r13.xyz = float3(1,1,0) + r14.xyz;
  r13.xyz = (uint3)r13.xyz;
  r13.w = 0;
  r8.x = LightVolumeClippingTexture.Load(r13.xyzw).x;
  r13.xyz = float3(0,1,0) + r14.xyz;
  r13.xyz = (uint3)r13.xyz;
  r13.w = 0;
  r9.w = LightVolumeClippingTexture.Load(r13.xyzw).x;
  r13.xyz = float3(0,0,1) + r14.xyz;
  r13.xyz = (uint3)r13.xyz;
  r13.w = 0;
  r10.w = LightVolumeClippingTexture.Load(r13.xyzw).x;
  r13.xyz = float3(1,0,1) + r14.xyz;
  r13.xyz = (uint3)r13.xyz;
  r13.w = 0;
  r11.w = LightVolumeClippingTexture.Load(r13.xyzw).x;
  r13.xyz = float3(1,1,1) + r14.xyz;
  r13.xyz = (uint3)r13.xyz;
  r13.w = 0;
  r12.w = LightVolumeClippingTexture.Load(r13.xyzw).x;
  r13.xyz = float3(0,1,1) + r14.xyz;
  r13.xyz = (uint3)r13.xyz;
  r13.w = 0;
  r13.x = LightVolumeClippingTexture.Load(r13.xyzw).x;
  r13.y = r3.w * 0.75 + 0.25;
  r8.y = cmp((int)r8.y == 0);
  r13.z = dot(-r6.xyz, r4.xyz);
  r13.w = dot(r6.xyz, r2.xyz);
  r13.w = r13.w + r13.w;
  r14.xyz = r2.xyz * -r13.www + r6.xyz;
  r13.w = r5.w * r5.w;
  r14.w = -r13.z * r13.z + 1;
  r14.w = sqrt(r14.w);
  r15.w = saturate(dot(r2.xyz, -r6.xyz));
  r17.xy = (int2)r1.zz & int2(2,16);
  r1.z = saturate(r4.x);
  r1.z = r1.z * r1.z;
  r1.z = r1.z * r1.z;
  r1.z = 2 / r1.z;
  r16.w = -2 + r1.z;
  r1.z = 0.5 * r1.z;
  r17.z = saturate(50 * r4.y);
  r17.z = r17.z + -r4.y;
  r17.w = r13.w * r13.w;
  r4.w = r4.w * 0.25 + 0.5;
  r4.w = r4.w * r4.w;
  r18.x = 0.5 * r4.w;
  r4.w = -r4.w * 0.5 + 1;
  r18.y = r15.w * r4.w + r18.x;
  r18.y = 1 / r18.y;
  r18.y = 0.25 * r18.y;
  r19.y = r6.w;
  r20.xyz = float3(0,0,0);
  r18.z = 0;
  while (true) {
    r18.w = cmp((uint)r18.z >= (uint)r0.w);
    if (r18.w != 0) break;
    r18.w = (float)g3[(uint)r18.z];
    if (LightBuffer[r18.w].LightID != 0) {
      r19.z = (int)r0.z & (int)LightBuffer[(uint)r18.w].LightID;
      r19.w = (int)r2.w & (int)LightBuffer[(uint)r18.w].LightID;
      r20.w = (int)r8.x & (int)LightBuffer[(uint)r18.w].LightID;
      r21.x = (int)r9.w & (int)LightBuffer[(uint)r18.w].LightID;
      r21.y = (int)r10.w & (int)LightBuffer[(uint)r18.w].LightID;
      r21.z = (int)r11.w & (int)LightBuffer[(uint)r18.w].LightID;
      r21.w = (int)r12.w & (int)LightBuffer[(uint)r18.w].LightID;
      r22.x = (int)r13.x & (int)LightBuffer[(uint)r18.w].LightID;
      r19.z = r19.z ? r12.x : 0;
      r19.w = r19.w ? r16.x : 0;
      r19.z = r19.z + r19.w;
      r19.w = r21.x ? r12.x : 0;
      r20.w = r20.w ? r16.x : 0;
      r19.w = r20.w + r19.w;
      r19.w = r19.w * r16.y;
      r19.z = r19.z * r12.y + r19.w;
      r19.w = r21.y ? r12.x : 0;
      r20.w = r21.z ? r16.x : 0;
      r19.w = r20.w + r19.w;
      r20.w = r22.x ? r12.x : 0;
      r21.x = r21.w ? r16.x : 0;
      r20.w = r21.x + r20.w;
      r20.w = r20.w * r16.y;
      r19.w = r19.w * r12.y + r20.w;
      r19.w = r19.w * r16.z;
      r19.z = r19.z * r12.z + r19.w;
      r19.z = log2(r19.z);
      r19.z = 2.5 * r19.z;
      r19.z = exp2(r19.z);
    } else {
      r19.z = 1;
    }
    r19.w = cmp(0 < LightBuffer[r18.w].CharacterLight);
    r19.w = r8.y ? r19.w : 0;
    r20.w = cmp(0 < LightBuffer[r18.w].InvRadius);
    if (r20.w != 0) {
      r21.xyz = LightBuffer[r18.w].WorldPosition.xyz + -r1.xyw;
      r20.w = dot(r21.xyz, r21.xyz);
      r21.w = rsqrt(r20.w);
      r22.xyz = r21.xyz * r21.www;
      r21.w = sqrt(r20.w);
      r22.w = cmp(0 < LightBuffer[r18.w].InvSquaredFalloff);
      r23.x = cmp(0 < LightBuffer[r18.w].SourceLength);
      r23.yzw = LightBuffer[r18.w].Direction.xyz * float3(-0.5,-0.5,-0.5);
      r24.xyz = -r23.yzw * LightBuffer[r18.w].SourceLength + r21.xyz;
      r23.yzw = r23.yzw * LightBuffer[r18.w].SourceLength + r21.xyz;
      r24.w = dot(r24.xyz, r24.xyz);
      r24.w = sqrt(r24.w);
      r25.x = dot(r23.yzw, r23.yzw);
      r25.x = sqrt(r25.x);
      r25.y = dot(r24.xyz, r23.yzw);
      r25.y = r24.w * r25.x + r25.y;
      r25.y = 9.99999975e-05 + r25.y;
      r25.y = 2 / r25.y;
      r26.y = 32000 * r25.y;
      r24.x = dot(r2.xyz, r24.xyz);
      r24.x = r24.x / r24.w;
      r23.y = dot(r2.xyz, r23.yzw);
      r23.y = r23.y / r25.x;
      r23.y = r24.x + r23.y;
      r26.x = saturate(0.5 * r23.y);
      r20.w = 1 + r20.w;
      r20.w = 1 / r20.w;
      r24.y = 32000 * r20.w;
      r24.x = dot(r2.xyz, r22.xyz);
      r23.xy = r23.xx ? r26.xy : r24.xy;
      r20.w = LightBuffer[r18.w].InvRadius * r21.w;
      r20.w = r20.w * r20.w;
      r20.w = -r20.w * r20.w + 1;
      r20.w = max(0, r20.w);
      r20.w = r20.w * r20.w;
      r23.z = r23.y * r20.w;
      r25.xyz = LightBuffer[r18.w].InvRadius * r21.xyz;
      r20.w = dot(r25.xyz, r25.xyz);
      r20.w = min(1, r20.w);
      r20.w = 1 + -r20.w;
      r20.w = log2(r20.w);
      r20.w = LightBuffer[r18.w].FallOffExponent * r20.w;
      r24.z = exp2(r20.w);
      r23.xy = r22.ww ? r23.xz : r24.xz;
      r20.w = dot(r22.xyz, LightBuffer[r18.w].Direction.xyz);
      r20.w = -LightBuffer[r18.w].SpotAngles.x + r20.w;
      r20.w = saturate(LightBuffer[r18.w].SpotAngles.y * r20.w);
      r20.w = r20.w * r20.w;
    } else {
      r23.x = dot(r2.xyz, LightBuffer[r18.w].Direction.xyz);
      r21.xyz = LightBuffer[r18.w].Direction.xyz;
      r23.y = 1;
      r20.w = 1;
    }
    r21.w = cmp(0 < r23.y);
    r22.x = cmp(0 < r20.w);
    r21.w = r21.w ? r22.x : 0;
    r19.w = cmp((int)r19.w == 0);
    r19.w = r19.w ? r21.w : 0;
    if (r19.w != 0) {
      r19.w = cmp(LightBuffer[r18.w].InvRadius == 0.000000);
      r22.xyzw = r19.wwww ? r7.xyzw : float4(1,1,1,1);
      r24.xyzw = r22.xyzw * r13.yyyy;
      r19.w = saturate(r13.y * r22.w + -LightBuffer[r18.w].MinShadowOpacity.x);
      r19.w = LightBuffer[r18.w].MinShadowOpacity.y * r19.w;
      r22.xyz = r19.www * r5.xyz;
      r21.w = cmp(0 < LightBuffer[r18.w].SourceRadius);
      if (r21.w != 0) {
        r21.w = cmp(0 < LightBuffer[r18.w].SourceLength);
        if (r21.w != 0) {
          r21.w = dot(-LightBuffer[r18.w].Direction.xyz, -LightBuffer[r18.w].Direction.xyz);
          r21.w = rsqrt(r21.w);
          r25.xyz = -LightBuffer[r18.w].Direction.xyz * r21.www;
          r26.xyz = float3(0.5,0.5,0.5) * r25.xyz;
          r26.xyz = -r26.xyz * LightBuffer[r18.w].SourceLength + r21.xyz;
          r25.xyz = LightBuffer[r18.w].SourceLength * r25.xyz;
          r21.w = dot(r14.xyz, r25.xyz);
          r27.xyz = r21.www * r14.xyz + -r25.xyz;
          r22.w = dot(r26.xyz, r27.xyz);
          r21.w = r21.w * r21.w;
          r21.w = LightBuffer[r18.w].SourceLength * LightBuffer[r18.w].SourceLength + -r21.w;
          r21.w = saturate(r22.w / r21.w);
          r25.xyz = r21.www * r25.xyz + r26.xyz;
          r21.w = dot(r25.xyz, r14.xyz);
          r26.xyz = r21.www * r14.xyz + -r25.xyz;
          r21.w = dot(r26.xyz, r26.xyz);
          r21.w = sqrt(r21.w);
          r21.w = saturate(LightBuffer[r18.w].SourceRadius / r21.w);
          r25.xyz = r26.xyz * r21.www + r25.xyz;
          r21.w = dot(r25.xyz, r25.xyz);
          r21.w = sqrt(r21.w);
          r21.w = 1 / r21.w;
          r22.w = LightBuffer[r18.w].SourceLength * r21.w;
          r22.w = 1.57079637 * r22.w;
          r23.z = LightBuffer[r18.w].SourceLength * r21.w + 1;
          r22.w = r22.w / r23.z;
          r23.z = LightBuffer[r18.w].SourceRadius * r21.w;
          r23.z = 1.57079637 * r23.z;
          r21.w = LightBuffer[r18.w].SourceRadius * r21.w + 1;
          r21.w = r23.z / r21.w;
          r22.w = r22.w * 0.333330005 + r13.w;
          r22.w = sqrt(r22.w);
          r22.w = min(1, r22.w);
          r22.w = r5.w / r22.w;
          r22.w = r22.w * r22.w;
          r21.w = r21.w * 0.333330005 + r13.w;
          r21.w = sqrt(r21.w);
          r21.w = min(1, r21.w);
          r21.w = r5.w / r21.w;
          r21.w = r21.w * r21.w;
          r21.w = r21.w * r21.w;
          r21.w = r22.w * r21.w;
        } else {
          r22.w = dot(r21.xyz, r14.xyz);
          r26.xyz = r22.www * r14.xyz + -r21.xyz;
          r22.w = dot(r26.xyz, r26.xyz);
          r22.w = sqrt(r22.w);
          r22.w = saturate(LightBuffer[r18.w].SourceRadius / r22.w);
          r25.xyz = r26.xyz * r22.www + r21.xyz;
          r22.w = dot(r25.xyz, r25.xyz);
          r22.w = sqrt(r22.w);
          r22.w = LightBuffer[r18.w].SourceRadius / r22.w;
          r23.z = 1.57079637 * r22.w;
          r22.w = 1 + r22.w;
          r22.w = r23.z / r22.w;
          r22.w = r22.w * 0.333330005 + r13.w;
          r22.w = sqrt(r22.w);
          r22.w = min(1, r22.w);
          r22.w = r5.w / r22.w;
          r22.w = r22.w * r22.w;
          r21.w = r22.w * r22.w;
        }
        r22.w = r5.w;
      } else {
        r23.z = -LightBuffer[r18.w].MinRoughness + 1;
        r22.w = r5.w * r23.z + LightBuffer[r18.w].MinRoughness;
        r25.xyz = r21.xyz;
        r21.w = 1;
      }
      r23.z = dot(r25.xyz, r25.xyz);
      r23.z = rsqrt(r23.z);
      r26.xyz = r25.xyz * r23.zzz;
      if (r8.z != 0) {
        r23.w = dot(r26.xyz, r4.xyz);
        r25.w = -r23.w * r23.w + 1;
        r25.w = sqrt(r25.w);
        r23.w = r23.w * r13.z;
        r23.w = saturate(r25.w * r14.w + -r23.w);
        r25.w = r22.w * r22.w;
        r25.w = r25.w * r25.w;
        r25.w = 1 / r25.w;
        r26.w = cmp(r23.w < 9.99999997e-07);
        r23.w = log2(r23.w);
        r23.w = r25.w * r23.w;
        r23.w = exp2(r23.w);
        r23.w = r26.w ? 0 : r23.w;
        r27.xyz = r23.www * r22.xyz;
        r27.xyz = r27.xyz * r21.www;
      } else {
        r25.xyz = r25.xyz * r23.zzz + -r6.xyz;
        r23.z = dot(r25.xyz, r25.xyz);
        r23.z = rsqrt(r23.z);
        r25.xyz = r25.xyz * r23.zzz;
        r23.z = saturate(dot(r2.xyz, r26.xyz));
        r23.w = saturate(dot(r2.xyz, r25.xyz));
        r25.x = saturate(dot(-r6.xyz, r25.xyz));
        r25.y = r22.w * r22.w;
        r25.y = r25.y * r25.y;
        r25.z = r23.w * r25.y + -r23.w;
        r23.w = r25.z * r23.w + 1;
        r23.w = r23.w * r23.w;
        r23.w = r25.y / r23.w;
        r23.w = 0.318309873 * r23.w;
        r22.w = r22.w * 0.5 + 0.5;
        r22.w = r22.w * r22.w;
        r25.y = 0.5 * r22.w;
        r22.w = -r22.w * 0.5 + 1;
        r25.z = r15.w * r22.w + r25.y;
        r25.z = 1 / r25.z;
        r22.w = r23.z * r22.w + r25.y;
        r22.w = 1 / r22.w;
        r22.w = r22.w * r25.z;
        r22.w = r22.w * r23.w;
        r23.z = saturate(50 * r22.y);
        r25.yzw = -r5.xyz * r19.www + r23.zzz;
        r23.z = r25.x * -5.55472994 + -6.98316002;
        r23.z = r23.z * r25.x;
        r23.z = exp2(r23.z);
        r25.xyz = r25.yzw * r23.zzz + r22.xyz;
        r22.w = 0.25 * r22.w;
        r25.xyz = r22.www * r25.xyz;
        r27.xyz = r25.xyz * r21.www;
      }
      if (r8.w != 0) {
        r19.x = saturate(r23.x * 0.5 + 0.5);
        r25.xyz = PreIntegratedBRDFTexture.SampleLevel(PreIntegratedBRDFTexture_s, r19.xy, 0).xyz;
        r23.x = saturate(r23.x);
        r26.xyz = r23.xxx * r27.xyz;
        r25.xyz = r25.xyz * r9.xyz + r26.xyz;
      } else {
        if (r17.x != 0) {
          r19.x = dot(r21.xyz, r21.xyz);
          r19.x = rsqrt(r19.x);
          r26.xyz = r21.xyz * r19.xxx;
          r21.xyz = r21.xyz * r19.xxx + -r6.xyz;
          r19.x = dot(r21.xyz, r21.xyz);
          r19.x = rsqrt(r19.x);
          r21.xyz = r21.xyz * r19.xxx;
          r19.x = saturate(dot(r2.xyz, r26.xyz));
          r21.w = saturate(dot(r2.xyz, r21.xyz));
          r21.x = saturate(dot(-r6.xyz, r21.xyz));
          r21.y = cmp(r21.w < 9.99999997e-07);
          r21.z = log2(r21.w);
          r21.z = r21.z * r16.w;
          r21.z = exp2(r21.z);
          r21.y = r21.y ? 0 : r21.z;
          r21.y = r21.y * r1.z;
          r21.z = dot(r26.xyz, -r6.xyz);
          r21.z = r21.z * 2 + 2;
          r21.z = 1 / r21.z;
          r22.w = r21.x * -5.55472994 + -6.98316002;
          r21.x = r22.w * r21.x;
          r21.x = exp2(r21.x);
          r22.w = r17.z * r21.x + r4.y;
          r21.y = r21.y * r21.z;
          r21.y = saturate(r21.y * r22.w);
          r21.z = r21.w * r17.w + -r21.w;
          r21.z = r21.z * r21.w + 1;
          r21.z = r21.z * r21.z;
          r21.z = r17.w / r21.z;
          r19.x = r19.x * r4.w + r18.x;
          r19.x = 1 / r19.x;
          r19.x = r19.x * r18.y;
          r21.w = saturate(50 * r22.y);
          r26.xyz = -r5.xyz * r19.www + r21.www;
          r22.xyz = r26.xyz * r21.xxx + r22.xyz;
          r19.x = r21.z * r19.x;
          r21.xzw = r19.xxx * r22.xyz;
          r21.xzw = r3.xyz * float3(0.318309873,0.318309873,0.318309873) + r21.xzw;
          r19.x = 1 + -r22.w;
          r25.xyz = r21.xzw * r19.xxx + r21.yyy;
        } else {
          r23.x = saturate(r23.x);
          r19.x = r23.x * -r6.w + r6.w;
          r19.w = 1 + -r19.x;
          r21.xyz = r9.xyz * r19.www + r27.xyz;
          r22.xyz = r19.xxx * r9.xyz;
          r25.xyz = r23.xxx * r21.xyz + r22.xyz;
        }
      }
      r21.xyz = r24.www * r24.xyz;
      r19.x = r23.y * r20.w;
      r21.xyz = r19.xxx * r21.xyz;
      r21.xyz = LightBuffer[r18.w].Color.xyz * r21.xyz;
      r21.xyz = r25.xyz * r21.xyz;
    } else {
      r21.xyz = float3(0,0,0);
    }
    r20.xyz = r21.xyz * r19.zzz + r20.xyz;
    r18.z = (int)r18.z + 1;
  }
  if (r17.y == 0) {
    r1.xyz = (int3)r11.xyz;
    r1.w = 0;
    r0.z = VisBlockingTexture.Load(r1.xyzw).x;
  } else {
    r0.z = 0;
  }
  r1.xy = cmp((uint2)vThreadID.xy < (uint2)ViewDimensions.xy);
  r0.w = r1.y ? r1.x : 0;
  if (r0.w != 0) {
    r0.xyw = EmissiveGBufferTexture.SampleLevel(EmissiveGBufferTexture_s, r0.xy, 0).xyz;
    r1.xyz = float3(0.5,0.5,0.5) + r15.xyz;
    r1.xyz = r1.xyz / VoxelSizeXYZ.xyz;
    r2.xyzw = (int4)r0.zzzz & int4(2,1,8,4);
    r2.xyzw = r2.xyzw ? float4(1,1,1,1) : float4(0,0,0,0);
    r3.xy = (int2)r0.zz & int2(32,16);
    r3.xy = r3.xy ? float2(1,1) : float2(0,0);
    r4.xyz = cmp(r10.xyz < r1.xyz);
    r2.xy = r4.xy ? r2.yw : r2.xz;
    r1.xyz = r1.xyz + -r10.xyz;
    r2.xy = r2.xy * r1.xy + r10.xy;
    r0.z = r4.z ? r3.y : r3.x;
    r2.z = r0.z * r1.z + r10.z;
    r1.xyz = sSHCoeffs.SampleLevel(sSHCoeffs_s, r2.xyz, 0).xyz;
    r1.xyz = r1.xyz * r9.xyz;
    r1.xyz = r1.xyz * r3.www + r20.xyz;
    r0.xyz = r1.xyz + r0.xyw;
    r0.w = 0;
    OutputBuffer[vThreadID.xy] = r0;
  }
  return;
}