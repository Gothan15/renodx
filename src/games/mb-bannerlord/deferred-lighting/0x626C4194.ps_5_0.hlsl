// ---- Created with 3Dmigoto v1.4.1 on Thu Feb 19 03:00:43 2026
cbuffer cb13 : register(b13) {
  float custom_ao_debug : packoffset(c9.y);
  float custom_ao_bypass : packoffset(c9.z);
}

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

Texture2D<float4> t35 : register(t35);

TextureCubeArray<float4> t31 : register(t31);

Texture2D<float4> t28 : register(t28);

Texture2D<float4> t26 : register(t26);

Texture2D<float4> t24 : register(t24);

Texture2D<float4> t16 : register(t16);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

SamplerComparisonState s8_s : register(s8);

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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14;
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
  r2.xy = (int2)v0.xy;
  r2.zw = float2(0,0);
  r1.zw = t1.Load(r2.xyw).xy;
  r3.xy = r1.zw * float2(3.55539989,3.55539989) + float2(-1.77769995,-1.77769995);
  r3.z = 1;
  r1.z = dot(r3.xyz, r3.xyz);
  r1.z = 2 / r1.z;
  r3.xy = r1.zz * r3.xy;
  r1.z = -1 + r1.z;
  r3.yzw = cb0[59].xzy * r3.yyy;
  r3.xyz = cb0[58].xzy * r3.xxx + r3.yzw;
  r3.xyz = cb0[60].xzy * r1.zzz + r3.xyz;
  r1.z = t2.Load(r2.xyz).z;
  r1.w = t24.SampleLevel(s2_s, r1.xy, 0).x;
  float ao_value = r1.w; // store raw AO for debug view
  r1.z = r1.z * r1.w;
  r1.z = max(0.0500000007, r1.z);
  if (custom_ao_bypass) r1.z = 1.0;
  r1.w = t26.Sample(s0_s, r1.xy).x;
  r1.w = -1 + r1.w;
  r1.w = cb0[102].x * r1.w + 1;
  r2.x = cmp(0 < cb0[107].w);
  if (r2.x != 0) {
    r2.xy = saturate(r1.xy);
    r2.zw = float2(0.0625,0.0625) * cb0[84].zw;
    r2.zw = ceil(r2.zw);
    r2.xy = cb0[84].zw * r2.xy;
    r2.xy = r2.xy / cb0[105].xy;
    r2.xy = float2(0.0625,0.0625) * r2.xy;
    r2.xyzw = (uint4)r2.xyzw;
    r4.xy = (int2)r2.zw + int2(-1,-1);
    r2.xy = min((uint2)r4.xy, (uint2)r2.xy);
    r2.x = mad((int)r2.z, (int)r2.y, (int)r2.x);
    r2.x = (uint)r2.x << 4;
    r2.y = t73.Load(r2.x).x;
    r0.w = 1;
    r4.xyz = float3(0,0,0);
    r2.z = 0;
    r2.w = r2.x;
    r4.w = r2.y;
    r5.x = 0;
    while (true) {
      r5.y = cmp((int)r4.w != 255);
      r5.z = cmp((int)r5.x < 16);
      r5.y = r5.z ? r5.y : 0;
      if (r5.y == 0) break;
      r5.x = (int)r5.x + 1;
      r5.y = t76[r4.w].val[32/4];
      r5.z = t76[r4.w].val[32/4+1];
      r5.w = t76[r4.w].val[32/4+2];
      r6.x = t76[r4.w].val[48/4];
      r6.y = t76[r4.w].val[48/4+1];
      r6.w = t76[r4.w].val[48/4+2];
      r7.x = t76[r4.w].val[0/4];
      r7.y = t76[r4.w].val[0/4+1];
      r7.z = t76[r4.w].val[0/4+2];
      r7.w = t76[r4.w].val[0/4+3];
      r8.x = t76[r4.w].val[16/4];
      r8.y = t76[r4.w].val[16/4+1];
      r8.z = t76[r4.w].val[16/4+2];
      r8.w = t76[r4.w].val[16/4+3];
      r9.x = r7.x;
      r9.y = r8.x;
      r9.z = r5.y;
      r9.w = r6.x;
      r9.x = dot(r9.xyzw, r0.xyzw);
      r10.x = r7.y;
      r10.y = r8.y;
      r10.z = r5.z;
      r10.w = r6.y;
      r9.y = dot(r10.xyzw, r0.xyzw);
      r6.x = r7.z;
      r6.y = r8.z;
      r6.z = r5.w;
      r9.z = dot(r6.xyzw, r0.xyzw);
      r5.yzw = min(float3(1,1,1), abs(r9.xyz));
      r6.x = max(r5.y, r5.z);
      r6.x = max(r6.x, r5.w);
      r6.x = 0.00100000005 + r6.x;
      r6.xyz = r5.yzw / r6.xxx;
      r5.y = dot(r5.yzw, r5.yzw);
      r5.z = dot(r6.xyz, r6.xyz);
      r5.yz = sqrt(r5.yz);
      r5.y = r5.y / r5.z;
      r5.y = min(1, r5.y);
      r5.y = log2(r5.y);
      r5.y = r7.w * r5.y;
      r5.y = exp2(r5.y);
      r5.y = 1 + -r5.y;
      r3.w = (uint)r4.w;
      r6.xyz = t31.SampleLevel(s2_s, r3.xyzw, 8).xyz;
      r6.xyz = cb0[82].xyz * r6.xyz;
      r6.xyz = r6.xyz * r5.yyy;
      r6.xyz = r6.xyz * r8.www;
      r6.xyz = r6.xyz / cb0[107].xxx;
      r4.xyz = r6.xyz + r4.xyz;
      r2.z = r5.y + r2.z;
      r2.w = (int)r2.w + 1;
      r4.w = t73.Load(r2.w).x;
    }
    r2.x = 9.99999975e-05 + r2.z;
    r2.xyw = r4.xyz / r2.xxx;
  } else {
    r2.xyzw = float4(0,0,0,0);
  }
  r4.x = cmp(r2.z < 1);
  if (r4.x != 0) {
    r3.w = 0;
    r4.xyz = t31.SampleLevel(s2_s, r3.xyzw, 8).xyz;
    r4.xyz = cb0[82].xyz * r4.xyz;
    r4.xyz = r4.xyz / cb0[107].xxx;
    r2.z = 1 + -r2.z;
    r4.xyz = r4.xyz + -r2.xyw;
    r2.xyw = r2.zzz * r4.xyz + r2.xyw;
  }
  r2.z = dot(float3(0.270000011,0.670000017,0.0599999987), r2.xyw);
  r2.xyw = r2.xyw / r2.zzz;
  r2.z = max(cb0[104].w, r2.z);
  r2.xyz = r2.xyw * r2.zzz;
  r2.xyz = max(float3(0,0,0), r2.xyz);
  r2.w = dot(r3.xyz, r3.xyz);
  r2.w = rsqrt(r2.w);
  r3.xyz = r3.xzy * r2.www;
  r2.w = saturate(dot(r3.xyz, -cb0[2].xyz));
  r1.w = r2.w * r1.w;
  r4.xyz = cb0[52].xyz * r1.www;
  r4.xyz = float3(0.318309873,0.318309873,0.318309873) * r4.xyz;
  r2.xyz = r2.xyz * r1.zzz + r4.xyz;
  r1.z = cmp(0 < cb0[57].x);
  if (r1.z != 0) {
    r1.xy = saturate(r1.xy);
    r1.zw = float2(0.0625,0.0625) * cb0[84].zw;
    r1.zw = ceil(r1.zw);
    r1.xy = cb0[84].zw * r1.xy;
    r1.xy = r1.xy / cb0[105].xy;
    r1.xy = float2(0.0625,0.0625) * r1.xy;
    r1.xyzw = (uint4)r1.xyzw;
    r4.xy = (int2)r1.zw + int2(-1,-1);
    r1.xy = min((uint2)r4.xy, (uint2)r1.xy);
    r1.x = mad((int)r1.z, (int)r1.y, (int)r1.x);
    r1.x = (uint)r1.x << 7;
    r1.y = t81.Load(r1.x).x;
    r4.xyz = r0.xyz;
    r4.w = 1;
    r0.w = 1;
    r5.xyz = float3(0,0,0);
    r1.zw = r1.xy;
    r2.w = 0;
    while (true) {
      r3.w = cmp((int)r1.w != 0x0000ffff);
      r5.w = cmp((uint)r2.w < 128);
      r3.w = r3.w ? r5.w : 0;
      if (r3.w == 0) break;
      r6.x = t83[r1.w].val[0/4];
      r6.y = t83[r1.w].val[0/4+1];
      r6.z = t83[r1.w].val[0/4+2];
      r6.xyz = r6.xyz + -r0.xyz;
      r3.w = dot(r6.xyz, r6.xyz);
      r5.w = sqrt(r3.w);
      r6.w = t83[r1.w].val[28/4];
      r7.x = r5.w / r6.w;
      r7.y = t83[r1.w].val[76/4];
      r7.y = cmp(0 != r7.y);
      r7.y = ~(int)r7.y;
      r7.x = cmp(1 < r7.x);
      r7.x = r7.x ? r7.y : 0;
      if (r7.x == 0) {
        r7.x = t83[r1.w].val[48/4];
        r7.x = cmp(0 != r7.x);
        r7.y = t83[r1.w].val[16/4];
        r7.z = t83[r1.w].val[16/4+1];
        r7.w = t83[r1.w].val[16/4+2];
        if (r7.x != 0) {
          r7.x = 1 + r3.w;
          r7.x = 1 / r7.x;
          r8.x = r6.w + -r5.w;
          r8.y = 0.300000012 * r6.w;
          r8.x = saturate(r8.x / r8.y);
          r7.x = r8.x * r7.x;
          r8.x = t83[r1.w].val[52/4];
          r8.y = t83[r1.w].val[52/4+1];
          r9.x = t83[r1.w].val[60/4];
          r9.y = t83[r1.w].val[60/4+1];
          r9.z = t83[r1.w].val[60/4+2];
          r8.z = r9.x;
          r8.w = dot(-r8.xyz, -r8.xyz);
          r8.w = rsqrt(r8.w);
          r8.xyz = -r8.xyz * r8.www;
          r8.w = rsqrt(r3.w);
          r10.xyz = r8.www * r6.xyz;
          r8.x = saturate(dot(r10.xyz, r8.xyz));
          r8.x = r8.x + -r9.y;
          r8.y = r9.z + -r9.y;
          r8.y = 0.00100000005 + r8.y;
          r8.x = saturate(r8.x / r8.y);
          r7.x = r8.x * r7.x;
          r8.x = t83[r1.w].val[44/4];
          r8.x = cmp(0 < r8.x);
          if (r8.x != 0) {
            r8.x = t83[r1.w].val[96/4];
            r9.x = t84[r8.x].val[96/4];
            r9.y = t84[r8.x].val[96/4+1];
            r9.z = t84[r8.x].val[96/4+2];
            r9.w = t84[r8.x].val[96/4+3];
            r10.x = t84[r8.x].val[112/4];
            r10.y = t84[r8.x].val[112/4+1];
            r10.z = t84[r8.x].val[112/4+2];
            r10.w = t84[r8.x].val[112/4+3];
            r11.x = t84[r8.x].val[128/4];
            r11.y = t84[r8.x].val[128/4+1];
            r11.z = t84[r8.x].val[128/4+2];
            r11.w = t84[r8.x].val[128/4+3];
            r12.x = t84[r8.x].val[144/4];
            r12.y = t84[r8.x].val[144/4+1];
            r12.z = t84[r8.x].val[144/4+2];
            r12.w = t84[r8.x].val[144/4+3];
            r13.x = r9.x;
            r13.y = r10.x;
            r13.z = r11.x;
            r13.w = r12.x;
            r13.x = dot(r13.xyzw, r4.xyzw);
            r14.x = r9.y;
            r14.y = r10.y;
            r14.z = r11.y;
            r14.w = r12.y;
            r13.y = dot(r14.xyzw, r4.xyzw);
            r14.x = r9.z;
            r14.y = r10.z;
            r14.z = r11.z;
            r14.w = r12.z;
            r13.z = dot(r14.xyzw, r4.xyzw);
            r12.x = r9.w;
            r12.y = r10.w;
            r12.z = r11.w;
            r8.y = dot(r12.xyzw, r4.xyzw);
            r8.yzw = r13.xyz / r8.yyy;
            r9.xy = r8.yz * float2(0.5,0.5) + float2(0.5,0.5);
            r10.x = t84[r8.x].val[0/4];
            r10.y = t84[r8.x].val[0/4+1];
            r10.z = t84[r8.x].val[0/4+2];
            r10.w = t84[r8.x].val[0/4+3];
            r9.z = 1 + -r9.y;
            r8.xy = r9.xz * r10.zw + r10.xy;
            r8.z = -9.99999975e-05 + r8.w;
            r8.w = t35.SampleCmpLevelZero(s8_s, r8.xy, r8.z, int2(-1, -1)).x;
            r9.x = t35.SampleCmpLevelZero(s8_s, r8.xy, r8.z, int2(-1, 0)).x;
            r8.w = r9.x + r8.w;
            r9.x = t35.SampleCmpLevelZero(s8_s, r8.xy, r8.z, int2(-1, 1)).x;
            r8.w = r9.x + r8.w;
            r9.x = t35.SampleCmpLevelZero(s8_s, r8.xy, r8.z, int2(0, -1)).x;
            r8.w = r9.x + r8.w;
            r9.x = t35.SampleCmpLevelZero(s8_s, r8.xy, r8.z, int2(0, 0)).x;
            r8.w = r9.x + r8.w;
            r9.x = t35.SampleCmpLevelZero(s8_s, r8.xy, r8.z, int2(0, 1)).x;
            r8.w = r9.x + r8.w;
            r9.x = t35.SampleCmpLevelZero(s8_s, r8.xy, r8.z, int2(1, -1)).x;
            r8.w = r9.x + r8.w;
            r9.x = t35.SampleCmpLevelZero(s8_s, r8.xy, r8.z, int2(1, 0)).x;
            r8.w = r9.x + r8.w;
            r8.x = t35.SampleCmpLevelZero(s8_s, r8.xy, r8.z, int2(1, 1)).x;
            r8.x = r8.w + r8.x;
            r8.x = 0.111111112 * r8.x;
          } else {
            r8.x = 1;
          }
        } else {
          r3.w = 1 + r3.w;
          r3.w = 1 / r3.w;
          r8.y = r6.w + -r5.w;
          r6.w = saturate(r8.y / r6.w);
          r6.w = r6.w * r6.w;
          r7.x = r6.w * r3.w;
          r3.w = t83[r1.w].val[44/4];
          r3.w = cmp(0 < r3.w);
          if (r3.w != 0) {
            r9.xyzw = cmp(abs(r6.yzxz) < abs(r6.xxyy));
            r8.yzw = cmp(-r6.xyz >= float3(0,0,0));
            r9.xy = r9.yw ? r9.xz : 0;
            r8.yzw = r8.yzw ? float3(0, 2, 4) : float3(1, 3, 5);
            r3.w = r9.y ? r8.z : r8.w;
            r3.w = r9.x ? r8.y : r3.w;
            r6.w = t83[r1.w].val[96/4];
            r8.yz = (uint2)r3.ww << int2(6,4);
            r9.xyzw = (int4)r8.yyyy + int4(96,112,128,144);
            r10.x = t84[r6.w].val[r9.x/4];
            r10.y = t84[r6.w].val[r9.x/4+1];
            r10.z = t84[r6.w].val[r9.x/4+2];
            r10.w = t84[r6.w].val[r9.x/4+3];
            r11.x = t84[r6.w].val[r9.y/4];
            r11.y = t84[r6.w].val[r9.y/4+1];
            r11.z = t84[r6.w].val[r9.y/4+2];
            r11.w = t84[r6.w].val[r9.y/4+3];
            r12.x = t84[r6.w].val[r9.z/4];
            r12.y = t84[r6.w].val[r9.z/4+1];
            r12.z = t84[r6.w].val[r9.z/4+2];
            r12.w = t84[r6.w].val[r9.z/4+3];
            r9.x = t84[r6.w].val[r9.w/4];
            r9.y = t84[r6.w].val[r9.w/4+1];
            r9.z = t84[r6.w].val[r9.w/4+2];
            r9.w = t84[r6.w].val[r9.w/4+3];
            r13.x = r10.x;
            r13.y = r11.x;
            r13.z = r12.x;
            r13.w = r9.x;
            r13.x = dot(r13.xyzw, r0.xyzw);
            r14.x = r10.y;
            r14.y = r11.y;
            r14.z = r12.y;
            r14.w = r9.y;
            r13.y = dot(r14.xyzw, r0.xyzw);
            r14.x = r10.z;
            r14.y = r11.z;
            r14.z = r12.z;
            r14.w = r9.z;
            r13.z = dot(r14.xyzw, r0.xyzw);
            r9.x = r10.w;
            r9.y = r11.w;
            r9.z = r12.w;
            r3.w = dot(r9.xyzw, r0.xyzw);
            r9.xyz = r13.xyz / r3.www;
            r10.xy = r9.xy * float2(0.5,0.5) + float2(0.5,0.5);
            r3.w = t83[r1.w].val[40/4];
            r8.y = 1 / r3.w;
            r8.y = -9 + r8.y;
            r8.y = r8.y * r3.w;
            r3.w = 4.5 * r3.w;
            r10.z = 1 + -r10.y;
            r8.yw = r10.xz * r8.yy + r3.ww;
            r10.x = t84[r6.w].val[r8.z/4];
            r10.y = t84[r6.w].val[r8.z/4+1];
            r10.z = t84[r6.w].val[r8.z/4+2];
            r10.w = t84[r6.w].val[r8.z/4+3];
            r8.yz = r8.yw * r10.zw + r10.xy;
            r3.w = dot(-r6.xyz, -r6.xyz);
            r3.w = sqrt(r3.w);
            r3.w = 9.99999975e-05 + r3.w;
            r6.w = t83[r1.w].val[32/4];
            r8.w = cmp(r3.w < r6.w);
            if (r8.w != 0) {
              r8.w = -0.00200000009 + r9.z;
              r9.x = t35.SampleCmpLevelZero(s8_s, r8.yz, r8.w, int2(-1, -1)).x;
              r9.y = t35.SampleCmpLevelZero(s8_s, r8.yz, r8.w, int2(-1, 0)).x;
              r9.x = r9.x + r9.y;
              r9.y = t35.SampleCmpLevelZero(s8_s, r8.yz, r8.w, int2(-1, 1)).x;
              r9.x = r9.x + r9.y;
              r9.y = t35.SampleCmpLevelZero(s8_s, r8.yz, r8.w, int2(0, -1)).x;
              r9.x = r9.x + r9.y;
              r9.y = t35.SampleCmpLevelZero(s8_s, r8.yz, r8.w, int2(0, 0)).x;
              r9.x = r9.x + r9.y;
              r9.y = t35.SampleCmpLevelZero(s8_s, r8.yz, r8.w, int2(0, 1)).x;
              r9.x = r9.x + r9.y;
              r9.y = t35.SampleCmpLevelZero(s8_s, r8.yz, r8.w, int2(1, -1)).x;
              r9.x = r9.x + r9.y;
              r9.y = t35.SampleCmpLevelZero(s8_s, r8.yz, r8.w, int2(1, 0)).x;
              r9.x = r9.x + r9.y;
              r8.y = t35.SampleCmpLevelZero(s8_s, r8.yz, r8.w, int2(1, 1)).x;
              r8.y = r9.x + r8.y;
              r8.y = 0.111111112 * r8.y;
            } else {
              r8.y = 1;
            }
            r8.z = 0.350000024 * r6.w;
            r3.w = -r6.w * 0.649999976 + r3.w;
            r3.w = max(0, r3.w);
            r3.w = saturate(r3.w / r8.z);
            r6.w = 1 + -r8.y;
            r8.x = r3.w * r6.w + r8.y;
          } else {
            r8.x = 1;
          }
        }
        r6.xyz = r6.xyz / r5.www;
        r3.w = saturate(dot(r6.xyz, r3.xyz));
        r3.w = r3.w * r8.x;
        r6.xyz = r3.www * r7.yzw;
        r6.xyz = r6.xyz * r7.xxx;
        r6.xyz = float3(0.318309873,0.318309873,0.318309873) * r6.xyz;
      } else {
        r6.xyz = float3(0,0,0);
      }
      r5.xyz = r6.xyz + r5.xyz;
      r1.z = (int)r1.z + 1;
      r2.w = (int)r2.w + 1;
      r1.w = t81.Load(r1.z).x;
    }
    r2.xyz = r5.xyz + r2.xyz;
  }
  r0.x = cmp(0 != cb0[101].x);
  if (r0.x != 0) {
    r0.x = t28.SampleLevel(s1_s, float2(0.5,0.5), 0).x;
  } else {
    r0.x = cb0[107].y;
  }
  o0.xyz = r2.xyz * r0.xxx;
  if (custom_ao_debug) o0.xyz = ao_value;
  o0.w = 1;
  return;
}