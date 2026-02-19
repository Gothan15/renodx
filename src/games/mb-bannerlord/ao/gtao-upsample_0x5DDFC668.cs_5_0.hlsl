// ---- Created with 3Dmigoto v1.4.1 on Wed Feb 18 23:05:07 2026
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

cbuffer cb2 : register(b2)
{
  float4 cb2[34];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[84];
}

RWTexture2D<float4> u0 : register(u0);

// 3Dmigoto declarations
#define cmp -


[numthreads(8,8,1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;
  r0.xy = cb2[0].xy + cb2[0].xy;
  r0.xy = float2(1,1) / r0.xy;
  r0.zw = (uint2)vThreadID.xy;
  r0.xy = cmp(r0.zw < r0.xy);
  r0.x = r0.y ? r0.x : 0;
  if (r0.x != 0) {
    r0.xy = cb2[0].xy * r0.zw;
    r0.xy = r0.xy * float2(2,2) + cb2[0].xy;
    t1.GetDimensions(0, fDest.x, fDest.y, fDest.z);
    r0.zw = fDest.xy;
    r1.xy = float2(1,1) / r0.zw;
    r1.zw = cb2[33].xy * r0.zw;
    r1.zw = trunc(r1.zw);
    r0.zw = r1.zw / r0.zw;
    r0.xy = cb2[33].xy * r0.xy;
    r0.zw = -r1.xy * float2(0.5,0.5) + r0.zw;
    r1.xy = max(float2(0,0), r0.xy);
    r0.zw = min(r1.xy, r0.zw);
    r0.z = t1.SampleLevel(s1_s, r0.zw, 0).x;
    r0.z = cb0[83].y + r0.z;
    r0.z = cb0[83].z / r0.z;
    r1.xyzw = t0.Gather(s1_s, r0.xy).xyzw;
    r2.xyzw = t2.Gather(s1_s, r0.xy).xyzw;
    r2.xyzw = cb0[83].yyyy + r2.xyzw;
    r2.xyzw = cb0[83].zzzz / r2.xyzw;
    r0.xyzw = r2.xyzw + -r0.zzzz;
    r0.xyzw = cmp(float4(0.100000001,0.100000001,0.100000001,0.100000001) >= abs(r0.xyzw));
    r0.xyzw = r0.xyzw ? float4(1,1,1,1) : 0;
    r2.x = r0.x + r0.y;
    r2.x = r2.x + r0.z;
    r2.x = r2.x + r0.w;
    r2.y = cmp(r2.x < 9.99999997e-07);
    if (r2.y != 0) {
      r2.y = r1.x + r1.y;
      r2.y = r2.y + r1.z;
      r2.y = r2.y + r1.w;
      r2.y = 0.25 * r2.y;
      u0[vThreadID.xy] = r2.yyyy;
    } else {
      r0.xy = r1.xy * r0.xy;
      r0.x = r0.x + r0.y;
      r0.x = r1.z * r0.z + r0.x;
      r0.x = r1.w * r0.w + r0.x;
      r0.x = r0.x / r2.x;
      u0[vThreadID.xy] = r0.xxxx;
    }
  }
  return;
}