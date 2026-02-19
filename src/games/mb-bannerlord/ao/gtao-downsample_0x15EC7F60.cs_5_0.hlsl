// ---- Created with 3Dmigoto v1.4.1 on Wed Feb 18 23:05:07 2026
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
  float4 r0;
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
  r0.xyzw = t0.Gather(s3_s, r0.xy).xyzw;
  r0.xy = max(r0.xz, r0.yw);
  r0.x = max(r0.x, r0.y);
  u0[vThreadID.xy] = r0.xxxx;
  return;
}