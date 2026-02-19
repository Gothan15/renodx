// ---- Created with 3Dmigoto v1.4.1 on Wed Feb 18 23:07:38 2026
groupshared struct { float val[4]; } g0[136];
Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

cbuffer cb2 : register(b2)
{
  float4 cb2[1];
}

RWTexture2D<float4> u0 : register(u0);

// 3Dmigoto declarations
#define cmp -


[numthreads(128,1,1)]
void main(uint3 vThreadIDInGroup : SV_GroupThreadID, uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;
  r0.x = cmp((uint)vThreadIDInGroup.x < 4);
  if (r0.x != 0) {
    r0.xy = (uint2)vThreadID.xy << int2(1,1);
    r0.xy = (int2)r0.xy + int2(-8,0);
    r0.xy = (int2)r0.xy + int2(1,1);
    r0.xy = (uint2)r0.xy;
    r0.xy = cb2[0].zw * r0.xy;
    t0.GetDimensions(0, fDest.x, fDest.y, fDest.z);
    r0.zw = fDest.xy;
    r0.zw = float2(1,1) / r0.zw;
    r0.zw = -r0.zw * float2(0.5,0.5) + float2(1,1);
    r0.xy = max(float2(0,0), r0.xy);
    r0.xy = min(r0.xy, r0.zw);
    r0.xyzw = t0.SampleLevel(s3_s, r0.xy, 0).xyzw;
    g0[vThreadIDInGroup.x].val[0/4] = r0.x;
    g0[vThreadIDInGroup.x].val[0/4+1] = r0.y;
    g0[vThreadIDInGroup.x].val[0/4+2] = r0.z;
    g0[vThreadIDInGroup.x].val[0/4+3] = r0.w;
  }
  r0.x = cmp((uint)vThreadIDInGroup.x >= 124);
  if (r0.x != 0) {
    r0.x = (int)vThreadIDInGroup.x + 8;
    r0.yz = (uint2)vThreadID.xy << int2(1,1);
    r0.yz = (int2)r0.yz + int2(8,0);
    r0.yz = (int2)r0.yz + int2(1,1);
    r0.yz = (uint2)r0.yz;
    r0.yz = cb2[0].zw * r0.yz;
    t0.GetDimensions(0, fDest.x, fDest.y, fDest.z);
    r1.xy = fDest.xy;
    r1.xy = float2(1,1) / r1.xy;
    r1.xy = -r1.xy * float2(0.5,0.5) + float2(1,1);
    r0.yz = max(float2(0,0), r0.yz);
    r0.yz = min(r0.yz, r1.xy);
    r1.xyzw = t0.SampleLevel(s3_s, r0.yz, 0).xyzw;
    g0[r0.x].val[0/4] = r1.x;
    g0[r0.x].val[0/4+1] = r1.y;
    g0[r0.x].val[0/4+2] = r1.z;
    g0[r0.x].val[0/4+3] = r1.w;
  }
  r0.x = (int)vThreadIDInGroup.x + 4;
  r0.yz = mad((int2)vThreadID.xy, int2(2,2), int2(1,1));
  r0.yz = (uint2)r0.yz;
  r0.yz = cb2[0].zw * r0.yz;
  t0.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r1.xy = fDest.xy;
  r1.xy = float2(1,1) / r1.xy;
  r1.xy = -r1.xy * float2(0.5,0.5) + float2(1,1);
  r0.yz = max(float2(0,0), r0.yz);
  r0.yz = min(r0.yz, r1.xy);
  r1.xyzw = t0.SampleLevel(s3_s, r0.yz, 0).xyzw;
  g0[r0.x].val[0/4] = r1.x;
  g0[r0.x].val[0/4+1] = r1.y;
  g0[r0.x].val[0/4+2] = r1.z;
  g0[r0.x].val[0/4+3] = r1.w;
  GroupMemoryBarrierWithGroupSync();
  r1.xyzw = float4(0,0,0,0);
  r0.y = -4;
  while (true) {
    r0.z = cmp(4 < (int)r0.y);
    if (r0.z != 0) break;
    r0.z = (int)r0.y + (int)r0.x;
    r2.x = g0[r0.z].val[0/4];
    r2.y = g0[r0.z].val[0/4+1];
    r2.z = g0[r0.z].val[0/4+2];
    r2.w = g0[r0.z].val[0/4+3];
    r1.xyzw = r2.xyzw + r1.xyzw;
    r0.y = (int)r0.y + 1;
  }
  r0.xyzw = float4(0.111111112,0.111111112,0.111111112,0.111111112) * r1.xyzw;
  u0[vThreadID.xy] = r0.xyzw;
  return;
}