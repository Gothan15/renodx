// ---- Created with 3Dmigoto v1.4.1 on Wed Feb 18 23:05:07 2026
Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s1_s : register(s1);

cbuffer cb2 : register(b2)
{
  float4 cb2[34];
}

RWTexture2D<float4> u0 : register(u0);
RWTexture2D<float4> u1 : register(u1);

// 3Dmigoto declarations
#define cmp -


[numthreads(16,16,1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;
  r0.xy = (uint2)vThreadID.xy;
  r0.xy = float2(0.5,0.5) + r0.xy;
  r0.zw = cb2[0].xy + cb2[0].xy;
  r0.zw = float2(1,1) / r0.zw;
  r0.xy = r0.xy / r0.zw;
  r0.zw = float2(-1,-1) + r0.zw;
  r1.zw = float2(0,0);
  r2.xyzw = float4(0,0,0,10000);
  r3.xyzw = float4(0,0,0,-10000);
  r4.x = -1;
  while (true) {
    r4.z = cmp(1 < (int)r4.x);
    if (r4.z != 0) break;
    r5.xyz = r2.xyz;
    r6.xyz = r3.xyz;
    r4.z = r2.w;
    r4.w = r3.w;
    r4.y = -1;
    while (true) {
      r5.w = cmp(1 < (int)r4.y);
      if (r5.w != 0) break;
      r7.xy = (int2)r4.xy + (int2)vThreadID.xy;
      r7.xy = (int2)r7.xy;
      r7.xy = max(float2(0,0), r7.xy);
      r7.xy = min(r7.xy, r0.zw);
      r1.xy = (int2)r7.xy;
      r7.xyz = t0.Load(r1.xyz).xyw;
      r7.xyz = max(float3(0,0,0), r7.xyz);
      r1.xy = cb2[33].zw * r7.xy;
      r7.xyw = t2.SampleLevel(s3_s, r1.xy, 0).xyz;
      r4.z = min(r7.z, r4.z);
      r4.w = max(r7.z, r4.w);
      r5.xyz = r7.xyw + r5.xyz;
      r6.xyz = r7.xyw * r7.xyw + r6.xyz;
      r4.y = (int)r4.y + 2;
    }
    r2.xyz = r5.xyz;
    r3.xyz = r6.xyz;
    r2.w = r4.z;
    r3.w = r4.w;
    r4.x = (int)r4.x + 2;
  }
  r1.xyz = float3(0.111111112,0.111111112,0.111111112) * r2.xyz;
  r1.xyz = r1.xyz * r1.xyz;
  r1.xyz = r3.xyz * float3(0.111111112,0.111111112,0.111111112) + -r1.xyz;
  r1.xyz = sqrt(abs(r1.xyz));
  r1.xyz = r1.xyz + r1.xyz;
  r3.xyz = r2.xyz * float3(0.111111112,0.111111112,0.111111112) + -r1.xyz;
  r1.xyz = r2.xyz * float3(0.111111112,0.111111112,0.111111112) + r1.xyz;
  r2.xyz = t0.SampleLevel(s1_s, r0.xy, 0).xyw;
  r0.zw = r2.xy + r0.xy;
  r0.zw = cb2[33].xy * r0.zw;
  r0.zw = float2(0.5,0.5) * r0.zw;
  r0.zw = t1.SampleLevel(s3_s, r0.zw, 0).xy;
  r4.xy = r2.xy + -r0.zw;
  r4.xy = cb2[33].zw * r4.xy;
  r4.xyz = t2.SampleLevel(s3_s, r4.xy, 0).xyz;
  r0.xy = r0.xy / cb2[33].xy;
  r0.xy = r0.xy * cb2[33].zw + -r0.zw;
  r0.z = dot(r0.zw, r0.zw);
  r0.z = sqrt(r0.z);
  r5.x = sqrt(r0.z);
  r5.yzw = float3(0,0,0);
  u1[vThreadID.xy] = r5.xyzw;
  r5.xy = cb2[33].zw * r2.xy;
  r0.w = t3.SampleLevel(s3_s, r5.xy, 0).x;
  r0.z = -r0.w * r0.w + r0.z;
  r0.z = sqrt(abs(r0.z));
  r0.z = -r0.z * 2 + 1;
  r5.xy = r2.xy * float2(2,2) + float2(-1,-1);
  r0.w = dot(r5.xy, r5.xy);
  r0.w = 1 + -r0.w;
  r0.zw = max(float2(0,0), r0.zw);
  r0.w = 10 * r0.w;
  r0.w = min(1, r0.w);
  r1.w = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r1.w * r0.w;
  r5.xyzw = t4.SampleLevel(s3_s, r0.xy, 0).xyzw;
  r1.w = max(r5.w, r2.w);
  r6.w = min(r1.w, r3.w);
  r7.xyz = r1.xyz + r3.xyz;
  r6.xyz = float3(0.5,0.5,0.5) * r7.xyz;
  r1.xyz = r1.xyz + -r3.xyz;
  r1.xyz = r1.xyz * float3(0.5,0.5,0.5) + float3(0.00100000005,0.00100000005,0.00100000005);
  r3.xyzw = -r6.xyzw + r5.xyzw;
  r1.xyz = r3.xyz / r1.xyz;
  r1.y = max(abs(r1.y), abs(r1.z));
  r1.x = max(abs(r1.x), r1.y);
  r1.y = cmp(1 < r1.x);
  r3.xyzw = r3.xyzw / r1.xxxx;
  r3.xyzw = r6.xyzw + r3.xyzw;
  r1.xyzw = r1.yyyy ? r3.xyzw : r5.xyzw;
  r0.z = r0.z * r0.w;
  r3.xy = saturate(r0.xy);
  r0.xy = cmp(r0.xy != r3.xy);
  r0.x = (int)r0.y | (int)r0.x;
  r0.y = 0.800000012 * r0.z;
  r0.y = min(1, r0.y);
  r0.x = r0.x ? 0 : r0.y;
  r4.w = r2.z;
  r1.xyzw = -r4.xyzw + r1.xyzw;
  r0.xyzw = r0.xxxx * r1.xyzw + r4.xyzw;
  r1.xy = saturate(r2.xy);
  r1.xy = cmp(r1.xy != r2.xy);
  r1.x = (int)r1.y | (int)r1.x;
  r1.x = r1.x ? 0 : 1;
  r0.w = r1.x * r0.w;
  r1.xyz = (int3)r0.xyz & int3(0x7f800000,0x7f800000,0x7f800000);
  r1.xyz = cmp((int3)r1.xyz != int3(0x7f800000,0x7f800000,0x7f800000));
  r1.xyz = r1.xyz ? r0.xyz : 0;
  r0.x = (int)r0.w & 0x7f800000;
  r0.x = cmp((int)r0.x != 0x7f800000);
  r1.w = r0.x ? r0.w : 0;
  u0[vThreadID.xy] = r1.xyzw;
  return;
}