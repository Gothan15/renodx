// ---- Created with 3Dmigoto v1.4.1 on Thu Feb 19 06:45:29 2026
Texture2D<uint4> t33 : register(t33);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

SamplerState s1_s : register(s1);

cbuffer cb2 : register(b2)
{
  float4 cb2[16];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[85];
}

RWTexture2D<float4> u0 : register(u0);

// 3Dmigoto declarations
#define cmp -


[numthreads(8,8,1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb2[0].xy + cb2[0].xy;
  r0.zw = float2(1,1) / r0.xy;
  r0.zw = (uint2)r0.zw;
  r0.zw = (int2)r0.zw + int2(-1,-1);
  r0.zw = min((uint2)vThreadID.xy, (uint2)r0.zw);
  r0.zw = (uint2)r0.zw;
  r0.xy = r0.zw * r0.xy + cb2[0].xy;
  r0.zw = (int2)vThreadID.xy;
  r1.xy = cb2[0].zw * r0.zw;
  r1.xy = r1.xy * float2(2,2) + cb2[0].zw;
  r1.x = t2.SampleLevel(s1_s, r1.xy, 0).x;
  r1.x = cb0[83].y + r1.x;
  r1.x = cb0[83].z / r1.x;
  r1.y = saturate(0.00333333341 * r1.x);
  r1.z = 256 * r1.y;
  r1.z = floor(r1.z);
  r2.z = 0.00390625 * r1.z;
  r2.w = r1.y * 256 + -r1.z;
  r0.xy = cb0[84].zw * r0.xy;
  r3.xy = (int2)r0.xy;
  r3.zw = float2(0,0);
  r0.x = t33.Load(r3.xyz).y;
  r0.x = (int)r0.x & 15;
  r0.y = cmp((int)r0.x != 10);
  if (r0.y != 0) {
    r3.z = -r1.x;
    r0.y = -600 / r3.z;
    r1.y = cmp(1 < r0.y);
    if (r1.y != 0) {
      r4.xyzw = cmp((int4)r0.xxxx == int4(8,7,9,6));
      r0.x = (int)r4.y | (int)r4.x;
      r0.x = (int)r4.z | (int)r0.x;
      r0.x = (int)r4.w | (int)r0.x;
      r0.x = r0.x ? 0.75 : 1.5;
      r0.zw = cb2[15].xy * r0.zw;
      r0.zw = r0.zw * float2(2,2) + cb2[15].zw;
      r3.xy = r1.xx * r0.zw;
      r1.xy = vThreadID.xy;
      r1.zw = float2(0,0);
      r0.z = t3.Load(r1.xyz).x;
      r1.xy = (uint2)vThreadID.xy << int2(1,1);
      r1.zw = float2(0,0);
      r1.xy = t1.Load(r1.xyz).xy;
      r1.xy = r1.xy * float2(3.55539989,3.55539989) + float2(-1.77769995,-1.77769995);
      r1.z = 1;
      r0.w = dot(r1.xyz, r1.xyz);
      r0.w = 2 / r0.w;
      r1.xy = r0.ww * r1.xy;
      r1.z = -1 + r0.w;
      r0.w = dot(r1.xyz, r1.xyz);
      r0.w = rsqrt(r0.w);
      r1.xyz = r1.xyz * r0.www;
      r0.w = (int)vThreadID.y + (int)vThreadID.x;
      bitmask.w = ((~(-1 << 2)) << 2) & 0xffffffff;  r0.w = (((uint)r0.w << 2) & bitmask.w) | ((uint)0 & ~bitmask.w);
      bitmask.w = ((~(-1 << 2)) << 0) & 0xffffffff;  r0.w = (((uint)vThreadID.x << 0) & bitmask.w) | ((uint)r0.w & ~bitmask.w);
      r0.w = (uint)r0.w;
      r0.w = r0.w * 0.0625 + cb2[10].z;
      r0.w = 6.28318548 * r0.w;
      r1.w = 1.5 * r1.z;
      r1.w = max(0, r1.w);
      r1.w = -1 + r1.w;
      r1.w = r1.w * 0.349999994 + 1;
      r3.w = 0;
      r4.x = 0;
      while (true) {
        r4.y = cmp((int)r4.x >= 6);
        if (r4.y != 0) break;
        r4.y = (int)r4.x;
        r4.z = r4.y * r0.y;
        r4.y = r4.y * 5.23333359 + r0.w;
        sincos(r4.y, r5.x, r6.x);
        r4.y = 0.166666672 * r4.z;
        r4.y = max(0.75, r4.y);
        r4.z = log2(r4.y);
        r4.z = floor(r4.z);
        r4.z = (int)r4.z;
        r4.z = (int)r4.z + -4;
        r4.z = max(0, (int)r4.z);
        r4.z = min(5, (int)r4.z);
        r6.y = r5.x;
        r4.yw = r6.xy * r4.yy;
        r4.yw = (int2)r4.yw;
        r4.yw = (int2)r4.yw + (int2)vThreadID.xy;
        r4.yzw = (int3)r4.yzw;
        r5.xy = cb2[0].zw * r4.yw;
        r5.xy = r5.xy * float2(2,2) + cb2[0].zw;
        r4.z = t2.SampleLevel(s1_s, r5.xy, r4.z).x;
        r4.z = cb0[83].y + r4.z;
        r4.z = cb0[83].z / r4.z;
        r4.yw = cb2[15].xy * r4.yw;
        r4.yw = r4.yw * float2(2,2) + cb2[15].zw;
        r5.xy = r4.zz * r4.yw;
        r5.z = -r4.z;
        r4.yzw = r5.xyz + -r3.xyz;
        r5.x = dot(r4.yzw, r4.yzw);
        r4.y = dot(r4.yzw, r1.xyz);
        r4.z = -r5.x * 0.694444418 + 1;
        r4.y = -0.100000001 + r4.y;
        r4.w = 0.00100000005 + r5.x;
        r4.w = rsqrt(r4.w);
        r4.y = r4.y * r4.w;
        r4.yz = max(float2(0,0), r4.yz);
        r4.y = r4.z * r4.y;
        r3.w = r4.y * r1.w + r3.w;
        r4.x = (int)r4.x + 1;
      }
      r0.y = 0.166666672 * r3.w;
      r0.y = sqrt(r0.y);
      r0.y = 1 + -r0.y;
      r0.y = max(0, r0.y);
      r0.y = log2(r0.y);
      r0.x = r0.x * r0.y;
      r0.x = exp2(r0.x);
      r2.x = r0.z * r0.x;
    } else {
      r2.x = 1;
    }
    r2.y = 1;
    r2.xyzw = r2.xzwy;
  } else {
    r2.xy = float2(1,0);
  }
  u0[vThreadID.xy] = r2.xyzw;
  return;
}