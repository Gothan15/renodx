// ---- Created with 3Dmigoto v1.4.1 on Wed Feb 18 23:05:07 2026
Texture2D<float4> t4 : register(t4);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

cbuffer cb2 : register(b2)
{
  float4 cb2[34];
}

RWTexture2D<float4> u0 : register(u0);

// 3Dmigoto declarations
#define cmp -


[numthreads(8,8,1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;
  r0.xy = (uint2)vThreadID.xy;
  r0.zw = cb2[0].xy + cb2[0].xy;
  r1.xy = float2(1,1) / r0.zw;
  r1.xy = float2(-1,-1) + r1.xy;
  r0.xy = min(r1.xy, r0.xy);
  r0.xy = (uint2)r0.xy;
  r0.xy = (uint2)r0.xy;
  r0.xy = r0.xy * r0.zw + cb2[0].xy;
  r1.x = r0.x;
  r2.x = cb2[0].z * 1.5 + r1.x;
  r1.y = cb2[0].w * 1.5 + r0.y;
  r2.y = r1.y;
  r0.zw = cb2[33].xy * r2.xy;
  r0.zw = max(float2(0,0), r0.zw);
  t0.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r1.zw = fDest.xy;
  r2.xy = cb2[33].xy * r1.zw;
  r2.xy = trunc(r2.xy);
  r2.xy = r2.xy / r1.zw;
  r1.zw = float2(1,1) / r1.zw;
  r1.zw = -r1.zw * float2(0.5,0.5) + r2.xy;
  r0.zw = min(r1.zw, r0.zw);
  r0.z = t0.SampleLevel(s3_s, r0.zw, 0).x;
  r2.xy = float2(1.5,1.5) * cb2[0].zw;
  r2.yz = -r2.yx;
  r2.xw = float2(-0,-0);
  r1.xy = r2.zw + r1.xy;
  r1.xy = cb2[33].xy * r1.xy;
  r1.xy = max(float2(0,0), r1.xy);
  r1.xy = min(r1.xy, r1.zw);
  r0.w = t0.SampleLevel(s3_s, r1.xy, 0).x;
  r1.x = min(r0.w, r0.z);
  r0.z = max(r0.w, r0.z);
  r3.xy = cb2[33].xy * r0.xy;
  r3.xy = max(float2(0,0), r3.xy);
  r3.zw = min(r3.xy, r1.zw);
  r0.w = t0.SampleLevel(s3_s, r3.zw, 0).x;
  r1.x = min(r0.w, r1.x);
  r2.xy = r2.xy + r0.xy;
  r2.zw = r2.xy + r2.zw;
  r2.zw = cb2[33].xy * r2.zw;
  r2.zw = max(float2(0,0), r2.zw);
  r2.zw = min(r2.zw, r1.zw);
  r1.y = t0.SampleLevel(s3_s, r2.zw, 0).x;
  r2.x = cb2[0].z * 1.5 + r2.x;
  r2.xy = cb2[33].xy * r2.xy;
  r2.xy = max(float2(0,0), r2.xy);
  r2.xy = min(r2.xy, r1.zw);
  r2.x = t0.SampleLevel(s3_s, r2.xy, 0).x;
  r1.x = min(r2.x, r1.x);
  r1.x = min(r1.y, r1.x);
  r0.z = max(r0.w, r0.z);
  r0.z = max(r2.x, r0.z);
  r0.z = max(r1.y, r0.z);
  r1.y = r0.z + -r1.x;
  t1.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r2.xy = fDest.xy;
  r2.zw = cb2[33].xy * r2.xy;
  r2.zw = trunc(r2.zw);
  r2.zw = r2.zw / r2.xy;
  r2.xy = float2(1,1) / r2.xy;
  r2.xy = -r2.xy * float2(0.5,0.5) + r2.zw;
  r2.xy = min(r3.xy, r2.xy);
  r2.xy = t1.SampleLevel(s3_s, r2.xy, 0).xy;
  r3.xyzw = -r2.xyxy + r0.xyxy;
  r0.x = dot(r2.xy, r2.xy);
  r0.x = sqrt(r0.x);
  r2.xyzw = cb2[33].zwxy * r3.xyzw;
  r2.xyzw = max(float4(0,0,0,0), r2.xyzw);
  t4.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r3.xy = fDest.xy;
  r3.zw = cb2[33].zw * r3.xy;
  r3.zw = trunc(r3.zw);
  r3.zw = r3.zw / r3.xy;
  r3.xy = float2(1,1) / r3.xy;
  r3.xy = -r3.xy * float2(0.5,0.5) + r3.zw;
  r2.xy = min(r3.xy, r2.xy);
  r1.zw = min(r2.zw, r1.zw);
  r3.yz = t0.SampleLevel(s3_s, r1.zw, 0).yz;
  r1.zw = t4.SampleLevel(s3_s, r2.xy, 0).xw;
  r0.y = -r1.w * r1.w + r0.x;
  r3.w = sqrt(r0.x);
  r0.x = sqrt(abs(r0.y));
  r0.x = -r0.x * 30 + 1;
  r0.x = max(0, r0.x);
  r0.x = r0.x * r1.y;
  r0.y = -r0.x * 0.850000024 + r1.x;
  r0.x = r0.x * 0.850000024 + r0.z;
  r0.y = max(r1.z, r0.y);
  r0.x = min(r0.y, r0.x);
  r0.x = r0.x + -r0.w;
  r3.x = r0.x * 0.850000024 + r0.w;
  u0[vThreadID.xy] = r3.xyzw;
  return;
}