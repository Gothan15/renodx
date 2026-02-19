// ---- Created with 3Dmigoto v1.4.1 on Wed Feb 18 23:05:07 2026
Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

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
  r0.xy = cb2[0].xy + cb2[0].xy;
  r0.zw = float2(1,1) / r0.xy;
  r0.zw = (uint2)r0.zw;
  r0.zw = (int2)r0.zw + int2(-1,-1);
  r0.zw = min((uint2)vThreadID.xy, (uint2)r0.zw);
  r0.zw = (uint2)r0.zw;
  r0.xy = r0.zw * r0.xy + cb2[0].xy;
  r0.xy = cb2[33].xy * r0.xy;
  t0.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.zw = fDest.xy;
  r1.xy = float2(1,1) / r0.zw;
  r1.zw = r1.xy * float2(0,-1) + r0.xy;
  r1.zw = max(float2(0,0), r1.zw);
  r2.xy = cb2[33].xy * r0.zw;
  r2.xy = trunc(r2.xy);
  r0.zw = r2.xy / r0.zw;
  r0.zw = -r1.xy * float2(0.5,0.5) + r0.zw;
  r1.zw = min(r1.zw, r0.zw);
  r2.xyz = t0.SampleLevel(s1_s, r1.zw, 0).xyz;
  r1.z = dot(r2.yz, float2(0.996108949,0.00389105058));
  r2.yz = max(float2(0,0), r0.xy);
  r2.yz = min(r2.yz, r0.zw);
  r2.yzw = t0.SampleLevel(s1_s, r2.yz, 0).xyz;
  r1.w = dot(r2.zw, float2(0.996108949,0.00389105058));
  r1.w = 300 * r1.w;
  r1.z = r1.z * 300 + -r1.w;
  r1.z = cmp(abs(r1.z) < 0.100000001);
  r2.z = r1.z ? 1.000000 : 0;
  r1.z = r1.z ? 0.624945998 : 0.383103013;
  r2.x = r2.x * r2.z;
  r2.x = 0.241843 * r2.x;
  r2.x = r2.y * 0.383103013 + r2.x;
  r3.xyzw = r1.xyxy * float4(0,1,0,-2) + r0.xyxy;
  r3.xyzw = max(float4(0,0,0,0), r3.xyzw);
  r3.xyzw = min(r3.xyzw, r0.zwzw);
  r2.yzw = t0.SampleLevel(s1_s, r3.xy, 0).xyz;
  r3.xyz = t0.SampleLevel(s1_s, r3.zw, 0).xyz;
  r2.z = dot(r2.zw, float2(0.996108949,0.00389105058));
  r2.z = r2.z * 300 + -r1.w;
  r2.z = cmp(abs(r2.z) < 0.100000001);
  r2.zw = r2.zz ? float2(1,0.241843) : 0;
  r2.y = r2.y * r2.z;
  r1.z = r2.w + r1.z;
  r2.x = r2.y * 0.241843 + r2.x;
  r2.y = dot(r3.yz, float2(0.996108949,0.00389105058));
  r2.y = r2.y * 300 + -r1.w;
  r2.y = cmp(abs(r2.y) < 0.100000001);
  r2.yz = r2.yy ? float2(1,0.0606260002) : 0;
  r2.y = r3.x * r2.y;
  r1.z = r2.z + r1.z;
  r2.x = r2.y * 0.0606260002 + r2.x;
  r3.xyzw = r1.xyxy * float4(0,2,0,-3) + r0.xyxy;
  r0.xy = r1.xy * float2(0,3) + r0.xy;
  r0.xy = max(float2(0,0), r0.xy);
  r0.xy = min(r0.xy, r0.zw);
  r2.yzw = t0.SampleLevel(s1_s, r0.xy, 0).xyz;
  r3.xyzw = max(float4(0,0,0,0), r3.xyzw);
  r0.xyzw = min(r3.xyzw, r0.zwzw);
  r3.xyz = t0.SampleLevel(s1_s, r0.xy, 0).xyz;
  r0.xyz = t0.SampleLevel(s1_s, r0.zw, 0).xyz;
  r0.w = dot(r3.yz, float2(0.996108949,0.00389105058));
  r0.w = r0.w * 300 + -r1.w;
  r0.w = cmp(abs(r0.w) < 0.100000001);
  r1.xy = r0.ww ? float2(1,0.0606260002) : 0;
  r0.w = r3.x * r1.x;
  r1.x = r1.z + r1.y;
  r0.w = r0.w * 0.0606260002 + r2.x;
  r0.y = dot(r0.yz, float2(0.996108949,0.00389105058));
  r0.y = r0.y * 300 + -r1.w;
  r0.y = cmp(abs(r0.y) < 0.100000001);
  r0.yz = r0.yy ? float2(1,0.0059799999) : 0;
  r0.x = r0.x * r0.y;
  r0.y = r1.x + r0.z;
  r0.x = r0.x * 0.0059799999 + r0.w;
  r0.z = dot(r2.zw, float2(0.996108949,0.00389105058));
  r0.z = r0.z * 300 + -r1.w;
  r0.z = cmp(abs(r0.z) < 0.100000001);
  r0.zw = r0.zz ? float2(1,0.0059799999) : 0;
  r0.z = r2.y * r0.z;
  r0.y = r0.y + r0.w;
  r0.x = r0.z * 0.0059799999 + r0.x;
  r0.x = r0.x / r0.y;
  u0[vThreadID.xy] = r0.xxxx;
  return;
}