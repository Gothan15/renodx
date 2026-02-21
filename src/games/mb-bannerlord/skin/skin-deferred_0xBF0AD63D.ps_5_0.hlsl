// ---- Created with 3Dmigoto v1.4.1 on Thu Feb 19 09:05:46 2026
struct t84_t {
  float val[120];
};
StructuredBuffer<t84_t> t84 : register(t84);

struct t83_t {
  float val[28];
};
StructuredBuffer<t83_t> t83 : register(t83);

Buffer<uint4> t81 : register(t81);

struct t76_t {
  float val[24];
};
StructuredBuffer<t76_t> t76 : register(t76);

Buffer<uint4> t73 : register(t73);

TextureCube<float4> t37 : register(t37);

Texture2D<float4> t35 : register(t35);

TextureCubeArray<float4> t31 : register(t31);

Texture2D<float4> t28 : register(t28);

Texture2D<float4> t27 : register(t27);

Texture2D<float4> t26 : register(t26);

Texture2D<float4> t25 : register(t25);

Texture2D<float4> t24 : register(t24);

Texture2D<float4> t16 : register(t16);

Texture2D<float4> t8 : register(t8);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

SamplerComparisonState s8_s : register(s8);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[108];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[105].xy * v2.xy;
  r0.x = t16.Sample(s0_s, r0.xy).x;
  r0.y = v2.x * 2 + -1;
  r0.z = 1 + -v2.y;
  r0.z = r0.z * 2 + -1;
  r1.xyzw = cb0[44].xyzw * r0.zzzz;
  r1.xyzw = cb0[43].xyzw * r0.yyyy + r1.xyzw;
  r0.xyzw = cb0[45].xyzw * r0.xxxx + r1.xyzw;
  r0.xyzw = cb0[46].xyzw + r0.xyzw;
  r0.xyz = r0.xyz / r0.www;
  r1.xy = cb0[65].zw * v0.xy;
  r1.xy = cb0[105].xy * r1.xy;
  r2.xyz = cb0[1].xyz + -r0.xyz;
  r1.z = dot(r2.xyz, r2.xyz);
  r1.z = sqrt(r1.z);
  r2.xyw = r2.xyz / r1.zzz;
  r3.xy = (int2)v0.xy;
  r3.zw = float2(0,0);
  r4.xy = t1.Load(r3.xyw).xy;
  r4.xy = r4.xy * float2(3.55539989,3.55539989) + float2(-1.77769995,-1.77769995);
  r4.z = 1;
  r1.w = dot(r4.xyz, r4.xyz);
  r1.w = 2 / r1.w;
  r4.xy = r1.ww * r4.xy;
  r1.w = -1 + r1.w;
  r4.yzw = cb0[59].xyz * r4.yyy;
  r4.xyz = cb0[58].xyz * r4.xxx + r4.yzw;
  r4.xyz = cb0[60].xyz * r1.www + r4.xyz;
  r5.xyz = t3.Load(r3.xyw).xyz;
  r6.xyz = r5.xyz * float3(0.305306017,0.305306017,0.305306017) + float3(0.682171106,0.682171106,0.682171106);
  r6.xyz = r5.xyz * r6.xyz + float3(0.0125228781,0.0125228781,0.0125228781);
  r5.xyz = r6.xyz * r5.xyz;
  r3.xyz = t2.Load(r3.xyz).xyz;
  r1.w = t24.SampleLevel(s2_s, r1.xy, 0).x;
  r1.w = r3.z * r1.w;
  r1.w = max(0.0500000007, r1.w);
  r3.z = t26.Sample(s0_s, r1.xy).x;
  r3.z = -1 + r3.z;
  r3.z = cb0[102].x * r3.z + 1;
  r6.xyz = t8.Sample(s1_s, r1.xy).xyz;
  r5.xyz = r6.xyz * r5.xyz;
  r3.w = cmp(0 != cb0[101].x);
  if (r3.w != 0) {
    r4.w = t28.SampleLevel(s1_s, float2(0.5,0.5), 0).x;
  } else {
    r4.w = cb0[107].y;
  }
  r5.xyz = r5.xyz / r4.www;
  r6.xz = float2(2.5,5) * r3.yx;
  r7.x = -r3.y * 0.25 + 1;
  r3.x = 7 * r7.x;
  r7.x = saturate(r7.x);
  r7.y = saturate(dot(r2.xyw, r4.xyz));
  r8.xyz = -r2.xwy;
  r4.w = dot(r8.xzy, r4.xyz);
  r4.w = r4.w + r4.w;
  r9.xyz = r4.xzy * -r4.www + r8.xyz;
  r4.w = cmp(0 < cb0[107].w);
  if (r4.w != 0) {
    r6.yw = saturate(r1.xy);
    r7.zw = float2(0.0625,0.0625) * cb0[84].zw;
    r7.zw = ceil(r7.zw);
    r7.zw = (uint2)r7.zw;
    r10.xy = cb0[84].zw * r6.yw;
    r10.xy = r10.xy / cb0[105].xy;
    r10.xy = float2(0.0625,0.0625) * r10.xy;
    r10.xy = (uint2)r10.xy;
    r10.zw = (int2)r7.zw + int2(-1,-1);
    r10.xy = min((uint2)r10.xy, (uint2)r10.zw);
    r4.w = mad((int)r7.z, (int)r10.y, (int)r10.x);
    r4.w = (uint)r4.w << 4;
    r5.w = t73.Load(r4.w).x;
    r0.w = 1;
    r7.z = 0;
    r7.w = r4.w;
    r8.w = r5.w;
    r10.xyzw = float4(0,0,0,0);
    while (true) {
      r11.x = cmp((int)r8.w != 255);
      r11.y = cmp((int)r10.w < 16);
      r11.x = r11.y ? r11.x : 0;
      if (r11.x == 0) break;
      r10.w = (int)r10.w + 1;
      r11.x = t76[r8.w].val[32/4];
      r11.y = t76[r8.w].val[32/4+1];
      r11.z = t76[r8.w].val[32/4+2];
      r12.x = t76[r8.w].val[48/4];
      r12.y = t76[r8.w].val[48/4+1];
      r12.w = t76[r8.w].val[48/4+2];
      r13.x = t76[r8.w].val[0/4];
      r13.y = t76[r8.w].val[0/4+1];
      r13.z = t76[r8.w].val[0/4+2];
      r13.w = t76[r8.w].val[0/4+3];
      r14.x = t76[r8.w].val[16/4];
      r14.y = t76[r8.w].val[16/4+1];
      r14.z = t76[r8.w].val[16/4+2];
      r14.w = t76[r8.w].val[16/4+3];
      r15.x = r13.x;
      r15.y = r14.x;
      r15.z = r11.x;
      r15.w = r12.x;
      r16.x = dot(r15.xyzw, r0.xyzw);
      r17.x = r13.y;
      r17.y = r14.y;
      r17.z = r11.y;
      r17.w = r12.y;
      r16.y = dot(r17.xyzw, r0.xyzw);
      r12.x = r13.z;
      r12.y = r14.z;
      r12.z = r11.z;
      r16.z = dot(r12.xyzw, r0.xyzw);
      r11.xyz = min(float3(1,1,1), abs(r16.xyz));
      r11.w = max(r11.x, r11.y);
      r11.w = max(r11.w, r11.z);
      r11.w = 0.00100000005 + r11.w;
      r13.xyz = r11.xyz / r11.www;
      r11.x = dot(r11.xyz, r11.xyz);
      r11.y = dot(r13.xyz, r13.xyz);
      r11.xy = sqrt(r11.xy);
      r11.x = r11.x / r11.y;
      r11.x = min(1, r11.x);
      r11.x = log2(r11.x);
      r11.x = r13.w * r11.x;
      r11.x = exp2(r11.x);
      r11.x = 1 + -r11.x;
      r13.x = t76[r8.w].val[64/4];
      r13.y = t76[r8.w].val[64/4+1];
      r13.z = t76[r8.w].val[64/4+2];
      r13.w = t76[r8.w].val[64/4+3];
      r11.y = cmp(0.5 < r13.w);
      r11.z = dot(r15.xzy, r9.xyz);
      r11.w = dot(r17.xzy, r9.xyz);
      r12.x = dot(r12.xzy, r9.xyz);
      r14.x = 1 / r11.z;
      r14.y = 1 / r11.w;
      r14.z = 1 / r12.x;
      r11.z = cmp(r11.z < 0);
      r15.x = r11.z ? 1 : -1;
      r11.z = cmp(r11.w < 0);
      r15.y = r11.z ? 1 : -1;
      r11.z = cmp(r12.x < 0);
      r15.z = r11.z ? 1 : -1;
      r12.xyz = -r16.xyz + r15.xyz;
      r12.xyz = r12.xyz * r14.xyz;
      r15.xyz = -r16.xyz + -r15.xyz;
      r14.xyz = r15.xyz * r14.xyz;
      r12.xyz = max(r14.xyz, r12.xyz);
      r11.z = min(r12.x, r12.y);
      r11.z = min(r11.z, r12.z);
      r12.xyz = r9.xyz * r11.zzz + r0.xzy;
      r12.xyz = r12.xyz + -r13.xzy;
      r12.xyz = r11.yyy ? r12.xyz : r9.xyz;
      r12.w = (uint)r8.w;
      r11.yzw = t31.SampleLevel(s2_s, r12.xyzw, r3.x).xyz;
      r11.yzw = cb0[82].xyz * r11.yzw;
      r11.yzw = r11.yzw * r11.xxx;
      r11.yzw = r11.yzw * r14.www;
      r11.yzw = r11.yzw / cb0[107].xxx;
      r10.xyz = r11.yzw + r10.xyz;
      r7.z = r11.x + r7.z;
      r7.w = (int)r7.w + 1;
      r8.w = t73.Load(r7.w).x;
    }
    r0.w = 9.99999975e-05 + r7.z;
    r10.xyz = r10.xyz / r0.www;
  } else {
    r10.xyz = float3(0,0,0);
    r6.yw = r1.xy;
    r7.z = 0;
  }
  r0.w = cmp(r7.z < 1);
  if (r0.w != 0) {
    r9.w = 0;
    r9.xyz = t31.SampleLevel(s2_s, r9.xyzw, r3.x).xyz;
    r9.xyz = cb0[82].xyz * r9.xyz;
    r9.xyz = r9.xyz / cb0[107].xxx;
    r0.w = 1 + -r7.z;
    r9.xyz = r9.xyz + -r10.xyz;
    r10.xyz = r0.www * r9.xyz + r10.xyz;
  }
  if (r3.w != 0) {
    r0.w = t28.SampleLevel(s1_s, float2(0.5,0.5), 0).x;
  } else {
    r0.w = cb0[107].y;
  }
  r7.zw = cb0[105].xy * r4.xy;
  r6.yw = r7.zw * float2(0.00999999978,0.00999999978) + r6.yw;
  r6.yw = r6.yw / cb0[105].xy;
  r9.xyzw = t27.SampleLevel(s3_s, r6.yw, 0).wxyz;
  r9.yzw = r9.yzw / r0.www;
  r9.x = saturate(r9.x);
  r0.w = cmp(0.100000001 < r9.x);
  r0.w = r0.w ? r9.x : 0;
  r9.xyz = r9.yzw + -r10.xyz;
  r9.xyz = r0.www * r9.xyz + r10.xyz;
  r6.yw = t25.SampleLevel(s3_s, r7.xy, 0).xy;
  r0.w = r6.y * 0.0399999991 + r6.w;
  r7.xyz = r9.xyz * r0.www;
  r6.x = saturate(r6.x);
  r0.w = max(0.100000001, r6.x);
  r6.xyw = r7.xyz * r0.www;
  r5.xyz = r6.xyw * r1.www + r5.xyz;
  r0.w = dot(r4.xyz, r4.xyz);
  r0.w = rsqrt(r0.w);
  r4.xyz = r4.xyz * r0.www;
  r0.w = dot(-cb0[2].xyz, -cb0[2].xyz);
  r0.w = rsqrt(r0.w);
  r6.xyw = -cb0[2].xyz * r0.www;
  r1.w = saturate(1 + -r3.y);
  r1.w = max(0.0500000007, r1.w);
  r7.xyz = -cb0[2].xyz * r0.www + r2.xyw;
  r0.w = dot(r7.xyz, r7.xyz);
  r3.x = rsqrt(r0.w);
  r7.xyz = r7.xyz * r3.xxx;
  r3.x = dot(r4.xyz, r6.xyw);
  r3.y = dot(r4.xyz, r7.xyz);
  r3.xy = max(float2(0,9.99999975e-05), r3.xy);
  r4.w = r3.y * r3.y;
  r3.y = r3.y * r3.y + -1;
  r3.y = r3.y / r4.w;
  r1.w = r1.w * r1.w;
  r5.w = 3.14159274 * r1.w;
  r4.w = r4.w * r4.w;
  r4.w = r4.w * r5.w;
  r3.y = r3.y / r1.w;
  r3.y = 1.44269502 * r3.y;
  r3.y = exp2(r3.y);
  r3.y = r3.y / r4.w;
  r4.w = dot(r2.xyw, r7.xyz);
  r4.w = 1 + -r4.w;
  r4.w = max(9.99999997e-07, r4.w);
  r6.x = r4.w * r4.w;
  r6.x = r6.x * r6.x;
  r6.y = r6.x * r4.w;
  r4.w = -r4.w * r6.x + 1;
  r4.w = r4.w * 0.0280000009 + r6.y;
  r4.w = -0.25 + r4.w;
  r4.w = r4.w * 0.819999993 + 0.25;
  r3.y = r4.w * r3.y;
  r0.w = max(0.00999999978, r0.w);
  r0.w = r3.y / r0.w;
  r0.w = max(0, r0.w);
  r0.w = r3.x * r0.w;
  r0.w = r0.w * r6.z;
  r0.w = r0.w * r3.z;
  r3.xyz = cb0[52].xyz * r0.www;
  r3.xyz = r3.xyz * float3(0.318309873,0.318309873,0.318309873) + r5.xyz;
  r0.w = cmp(0 < cb0[57].x);
  if (r0.w != 0) {
    r1.xy = saturate(r1.xy);
    r5.xy = float2(0.0625,0.0625) * cb0[84].zw;
    r5.xy = ceil(r5.xy);
    r5.xy = (uint2)r5.xy;
    r1.xy = cb0[84].zw * r1.xy;
    r1.xy = r1.xy / cb0[105].xy;
    r1.xy = float2(0.0625,0.0625) * r1.xy;
    r1.xy = (uint2)r1.xy;
    r5.yz = (int2)r5.xy + int2(-1,-1);
    r1.xy = min((uint2)r5.yz, (uint2)r1.xy);
    r0.w = mad((int)r5.x, (int)r1.y, (int)r1.x);
    r0.w = (uint)r0.w << 7;
    r1.x = t81.Load(r0.w).x;
    r7.xyz = r4.xyz * float3(0.00159999996,0.00159999996,0.00159999996) + r0.xyz;
    r7.w = 1;
    r9.xyz = r7.xyz;
    r9.w = 1;
    r5.xyz = float3(0,0,0);
    r1.y = r0.w;
    r4.w = r1.x;
    r6.x = 0;
    while (true) {
      r6.y = cmp((int)r4.w != 0x0000ffff);
      r6.w = cmp((uint)r6.x < 128);
      r6.y = r6.w ? r6.y : 0;
      if (r6.y == 0) break;
      r10.x = t83[r4.w].val[0/4];
      r10.y = t83[r4.w].val[0/4+1];
      r10.z = t83[r4.w].val[0/4+2];
      r10.xyzw = r10.yzxz + -r0.yzxz;
      r6.y = dot(r10.xzw, r10.xzw);
      r6.w = sqrt(r6.y);
      r8.w = t83[r4.w].val[28/4];
      r11.x = r6.w / r8.w;
      r11.x = cmp(1 >= r11.x);
      if (r11.x != 0) {
        r11.x = t83[r4.w].val[48/4];
        r11.x = cmp(0 != r11.x);
        r11.yzw = r10.zxw / r6.www;
        r12.x = t83[r4.w].val[16/4];
        r12.y = t83[r4.w].val[16/4+1];
        r12.z = t83[r4.w].val[16/4+2];
        if (r11.x != 0) {
          r11.x = 1 + r6.y;
          r11.x = 1 / r11.x;
          r12.w = r8.w + -r6.w;
          r13.x = 0.300000012 * r8.w;
          r12.w = saturate(r12.w / r13.x);
          r11.x = r12.w * r11.x;
          r13.x = t83[r4.w].val[52/4];
          r13.y = t83[r4.w].val[52/4+1];
          r14.x = t83[r4.w].val[60/4];
          r14.y = t83[r4.w].val[60/4+1];
          r14.z = t83[r4.w].val[60/4+2];
          r13.z = r14.x;
          r12.w = dot(-r13.xyz, -r13.xyz);
          r12.w = rsqrt(r12.w);
          r13.xyz = -r13.xyz * r12.www;
          r12.w = rsqrt(r6.y);
          r15.xyz = r12.www * r10.zxw;
          r12.w = saturate(dot(r15.xyz, r13.xyz));
          r12.w = r12.w + -r14.y;
          r13.x = r14.z + -r14.y;
          r13.x = 0.00100000005 + r13.x;
          r12.w = saturate(r12.w / r13.x);
          r11.x = r12.w * r11.x;
          r12.w = t83[r4.w].val[44/4];
          r12.w = cmp(0 < r12.w);
          if (r12.w != 0) {
            r12.w = t83[r4.w].val[96/4];
            r13.x = t84[r12.w].val[96/4];
            r13.y = t84[r12.w].val[96/4+1];
            r13.z = t84[r12.w].val[96/4+2];
            r13.w = t84[r12.w].val[96/4+3];
            r14.x = t84[r12.w].val[112/4];
            r14.y = t84[r12.w].val[112/4+1];
            r14.z = t84[r12.w].val[112/4+2];
            r14.w = t84[r12.w].val[112/4+3];
            r15.x = t84[r12.w].val[128/4];
            r15.y = t84[r12.w].val[128/4+1];
            r15.z = t84[r12.w].val[128/4+2];
            r15.w = t84[r12.w].val[128/4+3];
            r16.x = t84[r12.w].val[144/4];
            r16.y = t84[r12.w].val[144/4+1];
            r16.z = t84[r12.w].val[144/4+2];
            r16.w = t84[r12.w].val[144/4+3];
            r17.x = r13.x;
            r17.y = r14.x;
            r17.z = r15.x;
            r17.w = r16.x;
            r17.x = dot(r17.xyzw, r7.xyzw);
            r18.x = r13.y;
            r18.y = r14.y;
            r18.z = r15.y;
            r18.w = r16.y;
            r17.y = dot(r18.xyzw, r7.xyzw);
            r18.x = r13.z;
            r18.y = r14.z;
            r18.z = r15.z;
            r18.w = r16.z;
            r17.z = dot(r18.xyzw, r7.xyzw);
            r16.x = r13.w;
            r16.y = r14.w;
            r16.z = r15.w;
            r13.x = dot(r16.xyzw, r7.xyzw);
            r13.xyz = r17.xyz / r13.xxx;
            r14.xy = r13.xy * float2(0.5,0.5) + float2(0.5,0.5);
            r15.x = t84[r12.w].val[0/4];
            r15.y = t84[r12.w].val[0/4+1];
            r15.z = t84[r12.w].val[0/4+2];
            r15.w = t84[r12.w].val[0/4+3];
            r14.z = 1 + -r14.y;
            r13.xy = r14.xz * r15.zw + r15.xy;
            r12.w = -9.99999975e-05 + r13.z;
            r13.z = t35.SampleCmpLevelZero(s8_s, r13.xy, r12.w, int2(-1, -1)).x;
            r13.w = t35.SampleCmpLevelZero(s8_s, r13.xy, r12.w, int2(-1, 0)).x;
            r13.z = r13.z + r13.w;
            r13.w = t35.SampleCmpLevelZero(s8_s, r13.xy, r12.w, int2(-1, 1)).x;
            r13.z = r13.z + r13.w;
            r13.w = t35.SampleCmpLevelZero(s8_s, r13.xy, r12.w, int2(0, -1)).x;
            r13.z = r13.z + r13.w;
            r13.w = t35.SampleCmpLevelZero(s8_s, r13.xy, r12.w, int2(0, 0)).x;
            r13.z = r13.z + r13.w;
            r13.w = t35.SampleCmpLevelZero(s8_s, r13.xy, r12.w, int2(0, 1)).x;
            r13.z = r13.z + r13.w;
            r13.w = t35.SampleCmpLevelZero(s8_s, r13.xy, r12.w, int2(1, -1)).x;
            r13.z = r13.z + r13.w;
            r13.w = t35.SampleCmpLevelZero(s8_s, r13.xy, r12.w, int2(1, 0)).x;
            r13.z = r13.z + r13.w;
            r12.w = t35.SampleCmpLevelZero(s8_s, r13.xy, r12.w, int2(1, 1)).x;
            r12.w = r13.z + r12.w;
            r12.w = 0.111111112 * r12.w;
          } else {
            r12.w = 1;
          }
        } else {
          r6.y = 1 + r6.y;
          r6.y = 1 / r6.y;
          r6.w = r8.w + -r6.w;
          r6.w = saturate(r6.w / r8.w);
          r6.w = r6.w * r6.w;
          r11.x = r6.y * r6.w;
          r6.y = t83[r4.w].val[44/4];
          r6.y = cmp(0 < r6.y);
          if (r6.y != 0) {
            r13.xyzw = cmp(abs(r10.xyzw) < abs(r10.zzxx));
            r14.xyz = cmp(-r10.zxw >= float3(0,0,0));
            r6.yw = r13.yw ? r13.xz : 0;
            r13.xyz = r14.xyz ? float3(0,2,4) : float3(1,3,5);
            r6.w = r6.w ? r13.y : r13.z;
            r6.y = r6.y ? r13.x : r6.w;
            r6.w = t83[r4.w].val[96/4];
            r13.xy = (uint2)r6.yy << int2(6,4);
            r14.xyzw = (int4)r13.xxxx + int4(96,112,128,144);
            r15.x = t84[r6.w].val[r14.x/4];
            r15.y = t84[r6.w].val[r14.x/4+1];
            r15.z = t84[r6.w].val[r14.x/4+2];
            r15.w = t84[r6.w].val[r14.x/4+3];
            r16.x = t84[r6.w].val[r14.y/4];
            r16.y = t84[r6.w].val[r14.y/4+1];
            r16.z = t84[r6.w].val[r14.y/4+2];
            r16.w = t84[r6.w].val[r14.y/4+3];
            r17.x = t84[r6.w].val[r14.z/4];
            r17.y = t84[r6.w].val[r14.z/4+1];
            r17.z = t84[r6.w].val[r14.z/4+2];
            r17.w = t84[r6.w].val[r14.z/4+3];
            r14.x = t84[r6.w].val[r14.w/4];
            r14.y = t84[r6.w].val[r14.w/4+1];
            r14.z = t84[r6.w].val[r14.w/4+2];
            r14.w = t84[r6.w].val[r14.w/4+3];
            r18.x = r15.x;
            r18.y = r16.x;
            r18.z = r17.x;
            r18.w = r14.x;
            r18.x = dot(r18.xyzw, r9.xyzw);
            r19.x = r15.y;
            r19.y = r16.y;
            r19.z = r17.y;
            r19.w = r14.y;
            r18.y = dot(r19.xyzw, r9.xyzw);
            r19.x = r15.z;
            r19.y = r16.z;
            r19.z = r17.z;
            r19.w = r14.z;
            r18.z = dot(r19.xyzw, r9.xyzw);
            r14.x = r15.w;
            r14.y = r16.w;
            r14.z = r17.w;
            r6.y = dot(r14.xyzw, r9.xyzw);
            r13.xzw = r18.xyz / r6.yyy;
            r14.xy = r13.xz * float2(0.5,0.5) + float2(0.5,0.5);
            r6.y = t83[r4.w].val[40/4];
            r8.w = 1 / r6.y;
            r8.w = -9 + r8.w;
            r8.w = r8.w * r6.y;
            r6.y = 4.5 * r6.y;
            r14.z = 1 + -r14.y;
            r13.xz = r14.xz * r8.ww + r6.yy;
            r14.x = t84[r6.w].val[r13.y/4];
            r14.y = t84[r6.w].val[r13.y/4+1];
            r14.z = t84[r6.w].val[r13.y/4+2];
            r14.w = t84[r6.w].val[r13.y/4+3];
            r6.yw = r13.xz * r14.zw + r14.xy;
            r8.w = dot(-r10.xzw, -r10.xzw);
            r8.w = sqrt(r8.w);
            r8.w = 9.99999975e-05 + r8.w;
            r10.x = t83[r4.w].val[32/4];
            r10.y = cmp(r8.w < r10.x);
            if (r10.y != 0) {
              r10.y = -0.00200000009 + r13.w;
              r10.z = t35.SampleCmpLevelZero(s8_s, r6.yw, r10.y, int2(-1, -1)).x;
              r10.w = t35.SampleCmpLevelZero(s8_s, r6.yw, r10.y, int2(-1, 0)).x;
              r10.z = r10.z + r10.w;
              r10.w = t35.SampleCmpLevelZero(s8_s, r6.yw, r10.y, int2(-1, 1)).x;
              r10.z = r10.z + r10.w;
              r10.w = t35.SampleCmpLevelZero(s8_s, r6.yw, r10.y, int2(0, -1)).x;
              r10.z = r10.z + r10.w;
              r10.w = t35.SampleCmpLevelZero(s8_s, r6.yw, r10.y, int2(0, 0)).x;
              r10.z = r10.z + r10.w;
              r10.w = t35.SampleCmpLevelZero(s8_s, r6.yw, r10.y, int2(0, 1)).x;
              r10.z = r10.z + r10.w;
              r10.w = t35.SampleCmpLevelZero(s8_s, r6.yw, r10.y, int2(1, -1)).x;
              r10.z = r10.z + r10.w;
              r10.w = t35.SampleCmpLevelZero(s8_s, r6.yw, r10.y, int2(1, 0)).x;
              r10.z = r10.z + r10.w;
              r6.y = t35.SampleCmpLevelZero(s8_s, r6.yw, r10.y, int2(1, 1)).x;
              r6.y = r10.z + r6.y;
              r6.y = 0.111111112 * r6.y;
            } else {
              r6.y = 1;
            }
            r6.w = 0.350000024 * r10.x;
            r8.w = -r10.x * 0.649999976 + r8.w;
            r8.w = max(0, r8.w);
            r6.w = saturate(r8.w / r6.w);
            r8.w = 1 + -r6.y;
            r12.w = r6.w * r8.w + r6.y;
          } else {
            r12.w = 1;
          }
        }
        r6.y = dot(r11.yzw, r11.yzw);
        r6.y = rsqrt(r6.y);
        r10.xyz = r11.yzw * r6.yyy;
        r11.yzw = r11.yzw * r6.yyy + r2.xyw;
        r6.y = dot(r11.yzw, r11.yzw);
        r6.w = rsqrt(r6.y);
        r11.yzw = r11.yzw * r6.www;
        r6.w = dot(r4.xyz, r10.xyz);
        r8.w = dot(r4.xyz, r11.yzw);
        r8.w = max(9.99999975e-05, r8.w);
        r10.x = r8.w * r8.w;
        r8.w = r8.w * r8.w + -1;
        r8.w = r8.w / r10.x;
        r10.x = r10.x * r10.x;
        r10.x = r10.x * r5.w;
        r8.w = r8.w / r1.w;
        r8.w = 1.44269502 * r8.w;
        r8.w = exp2(r8.w);
        r8.w = r8.w / r10.x;
        r10.x = dot(r2.xyw, r11.yzw);
        r10.x = 1 + -r10.x;
        r10.x = max(9.99999997e-07, r10.x);
        r10.y = r10.x * r10.x;
        r10.y = r10.y * r10.y;
        r10.z = r10.x * r10.y;
        r10.x = -r10.x * r10.y + 1;
        r10.x = r10.x * 0.0280000009 + r10.z;
        r10.x = -0.25 + r10.x;
        r10.x = r10.x * 0.819999993 + 0.25;
        r8.w = r10.x * r8.w;
        r6.yw = max(float2(0.00999999978,0), r6.yw);
        r6.y = r8.w / r6.y;
        r6.y = max(0, r6.y);
        r6.y = r6.w * r6.y;
        r6.y = r6.y * r6.z;
        r6.y = r6.y * r12.w;
        r10.xyz = r6.yyy * r12.xyz;
        r10.xyz = r10.xyz * r11.xxx;
        r10.xyz = float3(0.318309873,0.318309873,0.318309873) * r10.xyz;
      } else {
        r10.xyz = float3(0,0,0);
      }
      r5.xyz = r10.xyz + r5.xyz;
      r1.y = (int)r1.y + 1;
      r6.x = (int)r6.x + 1;
      r4.w = t81.Load(r1.y).x;
    }
    r3.xyz = r5.xyz + r3.xyz;
  }
  r0.x = -cb0[77].x + r1.z;
  r0.x = max(0, r0.x);
  r0.x = cb0[101].w * r0.x;
  r0.y = cb0[56].y * 0.00999999978 + 9.99999975e-05;
  r0.z = -cb0[57].w + cb0[1].z;
  r0.z = -r0.y * r0.z;
  r0.z = 1.44269502 * r0.z;
  r0.z = exp2(r0.z);
  r0.x = max(0, r0.x);
  r0.z = r0.x * r0.z;
  r0.w = cmp(0.00999999978 < abs(r2.z));
  r0.y = r0.y * -r2.z;
  r1.x = -1.44269502 * r0.y;
  r1.x = exp2(r1.x);
  r1.x = 1 + -r1.x;
  r0.y = r1.x / r0.y;
  r0.y = r0.z * r0.y;
  r0.y = r0.w ? r0.y : r0.z;
  r0.y = -cb0[51].w * r0.y;
  r0.y = 0.000721347576 * r0.y;
  r0.y = exp2(r0.y);
  r0.z = 1 + -cb0[57].z;
  r0.y = saturate(min(r0.y, r0.z));
  r0.z = cb0[100].y * -r0.x;
  r0.xz = float2(-0.00595833035,1.44269497e-05) * r0.xz;
  r0.z = exp2(r0.z);
  r0.z = min(1, r0.z);
  r0.w = 7 * r0.z;
  r1.xyz = t37.SampleLevel(s2_s, r8.xyz, r0.w).xyz;
  r1.xyz = r1.xyz / cb0[107].xxx;
  r2.xyz = r3.xyz + -r1.xyz;
  r1.xyz = r0.zzz * r2.xyz + r1.xyz;
  r2.xyz = t37.SampleLevel(s2_s, r8.xyz, 2).xyz;
  r2.xyz = r2.xyz / cb0[107].xxx;
  r0.z = dot(r2.xyz, float3(0.412400007,0.357600003,0.180500001));
  r0.w = dot(r2.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r1.w = dot(r2.xyz, float3(0.0193000007,0.119199999,0.950500011));
  r2.x = r0.z + r0.w;
  r1.w = r2.x + r1.w;
  r1.w = 9.99999975e-06 + r1.w;
  r0.z = r0.z / r1.w;
  r1.w = r0.w / r1.w;
  r2.x = 9.99999975e-06 + r1.w;
  r2.x = r0.w / r2.x;
  r2.y = r2.x * r0.z;
  r0.z = 1 + -r0.z;
  r0.z = r0.z + -r1.w;
  r0.z = r0.z * r2.x;
  r2.xzw = float3(-1.53719997,1.87580001,-0.203999996) * r0.www;
  r2.xyz = r2.yyy * float3(3.24060011,-0.968900025,0.0557000004) + r2.xzw;
  r2.xyz = r0.zzz * float3(-0.498600006,0.0414999984,1.05700004) + r2.xyz;
  r0.x = exp2(r0.x);
  r0.x = 1 + -r0.x;
  r0.x = cb0[100].x * r0.x;
  r2.xyz = -cb0[51].xyz + r2.xyz;
  r0.xzw = r0.xxx * r2.xyz + cb0[51].xyz;
  r1.xyz = r1.xyz + -r0.xzw;
  r0.xyz = r0.yyy * r1.xyz + r0.xzw;
  if (r3.w != 0) {
    r0.w = t28.SampleLevel(s1_s, float2(0.5,0.5), 0).x;
  } else {
    r0.w = cb0[107].y;
  }
  o0.xyz = r0.xyz * r0.www;
  o0.w = 1;
  return;
}