// ---- Created with 3Dmigoto v1.4.1 on Thu Feb 19 06:45:28 2026
Texture2D<uint4> t33 : register(t33);

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
    r3.xyzw = cmp((int4)r0.xxxx == int4(8,7,9,6));
    r0.x = (int)r3.y | (int)r3.x;
    r0.x = (int)r3.z | (int)r0.x;
    r0.x = (int)r3.w | (int)r0.x;
    if (r0.x == 0) {
      r3.z = -r1.x;
      r0.x = -22 / r3.z;
      r0.y = cmp(1 < r0.x);
      if (r0.y != 0) {
        r0.yz = cb2[15].xy * r0.zw;
        r0.yz = r0.yz * float2(2,2) + cb2[15].zw;
        r3.xy = r1.xx * r0.yz;
        r1.xy = (uint2)vThreadID.xy << int2(1,1);
        r1.zw = float2(0,0);
        r0.yz = t1.Load(r1.xyz).xy;
        r1.xy = r0.yz * float2(3.55539989,3.55539989) + float2(-1.77769995,-1.77769995);
        r1.z = 1;
        r0.y = dot(r1.xyz, r1.xyz);
        r0.y = 2 / r0.y;
        r1.xy = r0.yy * r1.xy;
        r1.z = -1 + r0.y;
        r0.y = dot(r1.xyz, r1.xyz);
        r0.y = rsqrt(r0.y);
        r0.yzw = r1.xyz * r0.yyy;
        r1.x = (int)vThreadID.y + (int)vThreadID.x;
        bitmask.x = ((~(-1 << 2)) << 2) & 0xffffffff;  r1.x = (((uint)r1.x << 2) & bitmask.x) | ((uint)0 & ~bitmask.x);
        bitmask.x = ((~(-1 << 2)) << 0) & 0xffffffff;  r1.x = (((uint)vThreadID.x << 0) & bitmask.x) | ((uint)r1.x & ~bitmask.x);
        r1.x = (uint)r1.x;
        r1.x = r1.x * 0.0625 + cb2[10].z;
        r1.x = 6.28318548 * r1.x;
        r1.y = 1.5 * r0.w;
        r1.y = max(0, r1.y);
        r1.y = -1 + r1.y;
        r1.y = r1.y * 0.349999994 + 1;
        r1.zw = float2(0,0);
        while (true) {
          r3.w = cmp((int)r1.w >= 6);
          if (r3.w != 0) break;
          r3.w = (int)r1.w;
          r4.x = r3.w * r0.x;
          r3.w = r3.w * 5.23333359 + r1.x;
          sincos(r3.w, r5.x, r6.x);
          r3.w = 0.166666672 * r4.x;
          r3.w = max(0.75, r3.w);
          r4.x = log2(r3.w);
          r4.x = floor(r4.x);
          r4.x = (int)r4.x;
          r4.x = (int)r4.x + -4;
          r4.x = max(0, (int)r4.x);
          r4.x = min(5, (int)r4.x);
          r6.y = r5.x;
          r4.yz = r6.xy * r3.ww;
          r4.yz = (int2)r4.yz;
          r4.yz = (int2)r4.yz + (int2)vThreadID.xy;
          r4.yz = (int2)r4.yz;
          r5.xy = cb2[0].zw * r4.yz;
          r5.xy = r5.xy * float2(2,2) + cb2[0].zw;
          r3.w = (int)r4.x;
          r3.w = t2.SampleLevel(s1_s, r5.xy, r3.w).x;
          r3.w = cb0[83].y + r3.w;
          r3.w = cb0[83].z / r3.w;
          r4.xy = cb2[15].xy * r4.yz;
          r4.xy = r4.xy * float2(2,2) + cb2[15].zw;
          r4.xy = r4.xy * r3.ww;
          r4.z = -r3.w;
          r4.xyz = r4.xyz + -r3.xyz;
          r3.w = dot(r4.xyz, r4.xyz);
          r4.x = dot(r4.xyz, r0.yzw);
          r4.y = -r3.w * 516.528931 + 1;
          r4.y = max(0, r4.y);
          r4.x = -0.0104999999 + r4.x;
          r3.w = 0.00100000005 + r3.w;
          r3.w = rsqrt(r3.w);
          r3.w = r4.x * r3.w;
          r3.w = max(0, r3.w);
          r3.w = r4.y * r3.w;
          r1.z = r3.w * r1.y + r1.z;
          r1.w = (int)r1.w + 1;
        }
        r0.x = 0.166666672 * r1.z;
        r0.x = log2(r0.x);
        r0.x = 0.0400000028 * r0.x;
        r0.x = exp2(r0.x);
        r0.x = 1 + -r0.x;
        r2.x = max(0, r0.x);
      } else {
        r2.x = 1;
      }
      r2.y = 1;
      r2.xyzw = r2.xzwy;
    } else {
      r2.x = 1;
      r2.xyzw = r2.xxzw;
    }
  } else {
    r2.xy = float2(1,0);
  }
  u0[vThreadID.xy] = r2.xyzw;
  return;
}