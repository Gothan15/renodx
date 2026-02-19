// ---- Created with 3Dmigoto v1.4.1 on Wed Feb 18 23:05:07 2026
Texture2D<uint4> t33 : register(t33);

Texture2D<float4> t14 : register(t14);

Texture2D<float4> t13 : register(t13);

Texture2D<float4> t12 : register(t12);

Texture2D<float4> t11 : register(t11);

Texture2D<float4> t10 : register(t10);

Texture2D<float4> t8 : register(t8);

SamplerState s3_s : register(s3);

SamplerState s1_s : register(s1);

cbuffer cb2 : register(b2)
{
  float4 cb2[34];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[85];
}

RWTexture2D<float4> u0 : register(u0);

// 3Dmigoto declarations
#define cmp -


[numthreads(16,16,1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;
  r0.xy = (uint2)vThreadID.xy;
  r0.xy = float2(0.5,0.5) + r0.xy;
  r0.zw = cb2[0].xy + cb2[0].xy;
  r0.zw = float2(1,1) / r0.zw;
  r0.xy = r0.xy / r0.zw;
  r0.xy = cb2[33].xy * r0.xy;
  r1.x = t12.SampleLevel(s1_s, r0.xy, 0).x;
  r1.y = t13.SampleLevel(s1_s, r0.xy, 0).x;
  r1.x = cmp(r1.y != r1.x);
  if (r1.x != 0) {
    r1.xz = t10.SampleLevel(s3_s, r0.xy, 0).xy;
    r2.xy = r1.xz * float2(2,2) + float2(-1,-1);
    r1.x = dot(r2.xy, r2.xy);
    r1.x = 1 + -r1.x;
    r2.z = sqrt(r1.x);
    r1.x = dot(r2.xyz, r2.xyz);
    r1.x = rsqrt(r1.x);
    r1.xzw = r2.xyz * r1.xxx;
    r2.xyz = cb0[8].xyz * r1.zzz;
    r2.xyz = cb0[7].xyz * r1.xxx + r2.xyz;
    r1.xzw = cb0[9].xyz * r1.www + r2.xyz;
  } else {
    r2.x = t11.SampleLevel(s1_s, r0.xy, 0).y;
    r2.yz = t14.SampleLevel(s1_s, r0.xy, 0).xy;
    r3.xy = r2.yz * float2(3.55539989,3.55539989) + float2(-1.77769995,-1.77769995);
    r3.z = 1;
    r2.y = dot(r3.xyz, r3.xyz);
    r2.y = 2 / r2.y;
    r1.xz = r2.yy * r3.xy;
    r1.w = -1 + r2.y;
    r2.x = cmp(r2.x < 0.400000006);
    if (r2.x != 0) {
      r0.zw = float2(0,0);
      u0[vThreadID.xy] = r0.xyzw;
      return;
    }
  }
  r2.xy = (int2)vThreadID.xy & int2(1023,1023);
  r2.zw = float2(0,0);
  r0.z = t8.Load(r2.xyz).z;
  r0.z = cb2[26].y * 1.61802995 + r0.z;
  r0.z = frac(r0.z);
  r0.z = -0.5 + r0.z;
  r0.xy = r0.xy / cb2[33].xy;
  r0.x = r0.x * 2 + -1;
  r0.y = 1 + -r0.y;
  r0.y = r0.y * 2 + -1;
  r2.xyzw = cb0[44].xyzw * r0.yyyy;
  r2.xyzw = cb0[43].xyzw * r0.xxxx + r2.xyzw;
  r2.xyzw = cb0[45].xyzw * r1.yyyy + r2.xyzw;
  r2.xyzw = cb0[46].xyzw + r2.xyzw;
  r0.xyw = r2.xyz / r2.www;
  r2.xyz = cb0[8].xyz * r0.yyy;
  r2.xyz = cb0[7].xyz * r0.xxx + r2.xyz;
  r0.xyw = cb0[9].xyz * r0.www + r2.xyz;
  r0.xyw = cb0[10].xyz + r0.xyw;
  r1.y = dot(r0.xyw, r0.xyw);
  r1.y = rsqrt(r1.y);
  r2.xyz = r1.yyy * r0.xyw;
  r1.y = dot(r2.xyz, r1.xzw);
  r1.y = r1.y + r1.y;
  r1.xyz = r1.xzw * -r1.yyy + r2.xyz;
  r1.w = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(r1.w);
  r1.xyw = r1.xyz * r1.www + r0.xyw;
  r2.xyzw = cb0[12].xyzw * r0.yyyy;
  r2.xyzw = cb0[11].xyzw * r0.xxxx + r2.xyzw;
  r2.xyzw = cb0[13].xyzw * r0.wwww + r2.xyzw;
  r2.xyzw = cb0[14].xyzw + r2.xyzw;
  r0.xyw = r2.xyz / r2.www;
  r2.xyzw = cb0[12].xyzw * r1.yyyy;
  r2.xyzw = cb0[11].xyzw * r1.xxxx + r2.xyzw;
  r2.xyzw = cb0[13].xyzw * r1.wwww + r2.xyzw;
  r2.xyzw = cb0[14].xyzw + r2.xyzw;
  r1.xyw = r2.xyz / r2.www;
  r2.xyz = r0.xyw * float3(0.5,-0.5,1) + float3(0.5,0.5,0);
  r1.xyw = r1.xyw * float3(0.5,-0.5,1) + float3(0.5,0.5,0);
  r1.xyw = r1.xyw + -r2.xyz;
  r3.xyz = float3(0.03125,0.03125,0.03125) * r1.xyw;
  r0.x = dot(r1.xy, r1.xy);
  r0.x = sqrt(r0.x);
  r1.xyw = r3.xyz / r0.xxx;
  r0.xyz = r1.xyw * r0.zzz + r2.xyz;
  r2.xyz = r0.xyz;
  r3.x = r0.w;
  r3.yzw = float3(0,0,0);
  uint loopCounter = 1;
  while (true) {
    r4.x = cmp(loopCounter >= 32);
    r3.w = 0;
    if (r4.x != 0) break;
    r4.x = (uint)loopCounter;
    r4.xyz = r1.xyw * r4.xxx + r0.xyz;
    r5.xy = saturate(r4.xy);
    r5.xy = cmp(r4.xy != r5.xy);
    r4.w = (int)r5.y | (int)r5.x;
    if (r4.w != 0) {
      r3.w = -1;
      break;
    }
    r5.xy = cb2[33].xy * r4.xy;
    r5.x = t12.SampleLevel(s1_s, r5.xy, 0).x;
    r5.y = r4.z + -r1.w;
    r5.y = r5.y + -r5.x;
    r5.y = cmp(abs(r5.y) < abs(r1.w));
    if (r5.y != 0) {
      r5.y = -r5.x + r4.z;
      r5.z = r4.z + -r3.x;
      r5.z = r5.z + r1.w;
      r5.z = r5.z + -r5.y;
      r5.y = saturate(r5.y / r5.z);
      r4.xyz = r5.yyy * -r1.xyw + r4.xyz;
      r3.y = loopCounter;
      r3.w = 0;
      r2.xyz = r4.xyz;
      break;
    }
    r3.x = r5.x;
    loopCounter = loopCounter + 1;
    r3.w = r4.w;
    r3.y = 0;
  }
  r0.x = (uint)r3.y;
  r0.x = -r0.x * 0.03125 + 1;
  r2.w = saturate(4 * r0.x);
  r0.xyz = r2.xyz;
  r0.w = 0;
  r0.xyzw = r3.yyyy ? r2.xyzw : r0.xyzw;
  r0.xyzw = r3.wwww ? float4(0,0,0,0) : r0.xyzw;
  r1.x = -r1.z * 2 + 1;
  r1.x = cmp(r1.x >= 0.5);
  r1.x = r1.x ? 1.000000 : 0;
  r1.x = r1.x * r0.w;
  r1.yz = cb0[84].zw * r0.xy;
  r2.xy = (int2)r1.yz;
  r2.zw = float2(0,0);
  r1.y = t33.Load(r2.xyz).y;
  r1.y = (int)r1.y & 15;
  r1.y = cmp((int)r1.y == 10);
  r0.w = r1.y ? 0 : r1.x;
  u0[vThreadID.xy] = r0.xyzw;
  return;
}