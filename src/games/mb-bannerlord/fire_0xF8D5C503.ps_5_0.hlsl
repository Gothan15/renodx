// ---- Created with 3Dmigoto v1.4.1 on Wed Feb 18 22:50:56 2026
struct t75_t {
  float val[25];
};
StructuredBuffer<t75_t> t75 : register(t75);

Texture2D<float4> t39 : register(t39);

TextureCube<float4> t37 : register(t37);

Texture2D<float4> t28 : register(t28);

Texture2D<float4> t16 : register(t16);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb6 : register(b6)
{
  float4 cb6[2];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[108];
}

cbuffer cb13 : register(b13)
{
  float4 cb13v[10];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float4 v4 : TEXCOORD2,
  float4 v5 : TEXCOORD4,
  nointerpolation uint v6 : PARTICLE_INDEX0,
  nointerpolation uint w6 : EMITTER_INDEX0,
  nointerpolation uint x6 : INSTANCE_ID0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = cb0[1].zxy + -v2.zxy;
  r1.x = dot(r0.xyz, r0.xyz);
  r1.x = sqrt(r1.x);
  r1.yzw = r0.yzx / r1.xxx;
  r2.xyzw = t0.Sample(s2_s, v4.xy).xyzw;
  r2.w = v1.w * r2.w;
  uint emitterFlags = asuint(t75[w6.x].val[52/4]);
  if (emitterFlags & 512u) {
    r3.yzw = cb0[0].xyz + -v2.xyz;
    r3.y = dot(r3.yzw, r3.yzw);
    r3.y = sqrt(r3.y);
    r3.z = t75[w6.x].val[48/4];
    r3.w = r3.y + -r3.z;
    r3.z = saturate(r3.w / r3.z);
    r3.z = r3.z * r3.z;
    r3.z = r3.z * r2.w;
    r3.w = t75[w6.x].val[68/4];
    r4.x = cmp(0 < r3.w);
    r3.y = r3.y + -r3.w;
    r3.w = 0.25 * r3.w;
    r3.y = saturate(-r3.y / r3.w);
    r3.y = r3.y * r3.y;
    r3.y = r3.z * r3.y;
    r3.y = min(r3.z, r3.y);
    r2.w = r4.x ? r3.y : r3.z;
  }
  if (emitterFlags & 8192u) {
    r3.y = t75[w6.x].val[72/4];
    r3.y = 1 / r3.y;
    r3.y = saturate(r3.y * r1.w);
    r3.z = r3.y * -2 + 3;
    r3.y = r3.y * r3.y;
    r3.y = -r3.z * r3.y + 1;
    r3.y = r3.y * r3.y;
    r2.w = r3.y * r2.w;
  }
  if (emitterFlags & 1024u) {
    r3.y = cmp(0 != cb0[76].z);
    if (r3.y != 0) {
      r3.yz = cb0[65].zw * v0.xy;
      r3.yw = cb0[105].xy * r3.yz;
      r3.w = t16.Sample(s0_s, r3.yw).x;
      r3.y = r3.y * 2 + -1;
      r3.z = -r3.z * cb0[105].y + 1;
      r3.z = r3.z * 2 + -1;
      r5.xyzw = cb0[44].xyzw * r3.zzzz;
      r5.xyzw = cb0[43].xyzw * r3.yyyy + r5.xyzw;
      r5.xyzw = cb0[45].xyzw * r3.wwww + r5.xyzw;
      r5.xyzw = cb0[46].xyzw + r5.xyzw;
      r3.yzw = r5.xyz / r5.www;
      r3.yzw = cb0[0].xyz + -r3.yzw;
      r3.y = dot(r3.yzw, r3.yzw);
      r4.xyz = cb0[0].xyz + -v2.xyz;
      r3.z = dot(r4.xyz, r4.xyz);
      r3.yz = sqrt(r3.yz);
      r3.y = r3.y + -r3.z;
      r3.y = max(9.99999975e-05, r3.y);
      r3.z = t75[w6.x].val[0/4];
      r3.w = t75[w6.x].val[0/4+1];
      r3.y = saturate(r3.y / r3.z);
      r3.z = 1 + r3.w;
      r3.y = log2(r3.y);
      r3.y = r3.z * r3.y;
      r3.y = exp2(r3.y);
      r2.w = r3.y * r2.w;
    }
  }
  if (emitterFlags & 256u) {
    r3.y = cmp(0 != cb0[76].z);
    if (r3.y != 0) {
      r3.y = saturate(-cb0[85].z + v2.z);
      r3.z = t75[w6.x].val[0/4];
      r3.y = saturate(r3.y / r3.z);
      r2.w = r3.y * r2.w;
    }
  }
  if (emitterFlags & 2048u) {
    r3.x = cb0[62].x * v2.x;
    r3.z = -v2.y * cb0[62].y + 1;
    r3.x = t39.SampleLevel(s2_s, r3.xz, 0).x;
    r3.x = 1 + -r3.x;
    r3.x = r3.x * 800 + -400;
    r3.x = cmp(v2.z >= r3.x);
    r3.x = r3.x ? 1.000000 : 0;
    r2.w = r3.x * r2.w;
  }
  r3.x = asint(cb6[1].y) & 8;
  r4.xyz = r2.xyz * float3(0.305306017,0.305306017,0.305306017) + float3(0.682171106,0.682171106,0.682171106);
  r4.xyz = r2.xyz * r4.xyz + float3(0.0125228781,0.0125228781,0.0125228781);
  r2.xyz = r4.xyz * r2.xyz;
  r2.xyz = r3.xxx ? float3(1,1,1) : r2.xyz;
  r2.xyz = v1.xyz * r2.xyz;
  r3.x = t75[w6.x].val[60/4];
  r2.xyz = r3.xxx * r2.xyz;
  r3.x = t75[w6.x].val[28/4];
  r2.xyz = r3.xxx * r2.xyz;
  if (emitterFlags & 4096u) {
    r3.x = cmp(0 != cb0[101].x);
    if (r3.x != 0) {
      r3.x = t28.SampleLevel(s1_s, float2(0.5,0.5), 0).x;
    } else {
      r3.x = cb0[107].y;
    }
    r3.yzw = v3.www * r2.xyz;
    r2.xyz = r3.yzw / r3.xxx;
  }
  r3.x = t75[w6.x].val[96/4];
  r3.y = cmp(r3.x != 1.000000);
  if (r3.y != 0) {
    r0.w = r3.x * r0.x;
    r3.x = dot(r0.yzw, r0.yzw);
    r1.x = sqrt(r3.x);
    r3.x = rsqrt(r3.x);
    r3.xyz = r3.xxx * r0.yzw;
    r0.x = r0.w;
  } else {
    r0.y = dot(r1.yzw, r1.yzw);
    r3.xyz = sqrt(r0.yyy);
  }
  r0.y = -cb0[77].x + r1.x;
  r0.y = max(0, r0.y);
  r0.y = cb0[101].w * r0.y;
  r0.z = cb0[56].y * 0.00999999978 + 9.99999975e-05;
  r0.w = -cb0[57].w + cb0[1].z;
  r0.w = -r0.z * r0.w;
  r0.w = 1.44269502 * r0.w;
  r0.w = exp2(r0.w);
  r0.y = max(0, r0.y);
  r0.w = r0.y * r0.w;
  r1.x = cmp(0.00999999978 < abs(r0.x));
  r0.x = r0.z * -r0.x;
  r0.z = -1.44269502 * r0.x;
  r0.z = exp2(r0.z);
  r0.z = 1 + -r0.z;
  r0.x = r0.z / r0.x;
  r0.x = r0.w * r0.x;
  r0.x = r1.x ? r0.x : r0.w;
  r0.x = -cb0[51].w * r0.x;
  r0.x = 0.000721347576 * r0.x;
  r0.x = exp2(r0.x);
  r0.z = 1 + -cb0[57].z;
  r0.x = saturate(min(r0.x, r0.z));
  r1.xyz = -r3.xzy;
  r0.z = cb0[100].y * -r0.y;
  r0.yz = float2(-0.00595833035,1.44269497e-05) * r0.yz;
  r0.z = exp2(r0.z);
  r0.z = min(1, r0.z);
  r0.w = 7 * r0.z;
  r3.xyz = t37.SampleLevel(s2_s, r1.xyz, r0.w).xyz;
  r3.xyz = r3.xyz / cb0[107].xxx;
  r2.xyz = -r3.xyz + r2.xyz;
  r2.xyz = r0.zzz * r2.xyz + r3.xyz;
  r1.xyz = t37.SampleLevel(s2_s, r1.xyz, 2).xyz;
  r1.xyz = r1.xyz / cb0[107].xxx;
  r0.z = dot(r1.xyz, float3(0.412400007,0.357600003,0.180500001));
  r0.w = dot(r1.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r1.x = dot(r1.xyz, float3(0.0193000007,0.119199999,0.950500011));
  r1.y = r0.z + r0.w;
  r1.x = r1.y + r1.x;
  r1.x = 9.99999975e-06 + r1.x;
  r0.z = r0.z / r1.x;
  r1.x = r0.w / r1.x;
  r1.y = 9.99999975e-06 + r1.x;
  r1.y = r0.w / r1.y;
  r1.z = r1.y * r0.z;
  r0.z = 1 + -r0.z;
  r0.z = r0.z + -r1.x;
  r0.z = r0.z * r1.y;
  r1.xyw = float3(-1.53719997,1.87580001,-0.203999996) * r0.www;
  r1.xyz = r1.zzz * float3(3.24060011,-0.968900025,0.0557000004) + r1.xyw;
  r1.xyz = r0.zzz * float3(-0.498600006,0.0414999984,1.05700004) + r1.xyz;
  r0.y = exp2(r0.y);
  r0.y = 1 + -r0.y;
  r0.y = cb0[100].x * r0.y;
  r1.xyz = -cb0[51].xyz + r1.xyz;
  r0.yzw = r0.yyy * r1.xyz + cb0[51].xyz;
  r1.xyz = r2.xyz + -r0.yzw;
  r0.xyz = r0.xxx * r1.xyz + r0.yzw;
  r0.xyz = r0.xyz * r2.www;
  r0.w = cmp(0 != cb0[101].x);
  if (r0.w != 0) {
    r0.w = t28.SampleLevel(s1_s, float2(0.5,0.5), 0).x;
  } else {
    r0.w = cb0[107].y;
  }
  float3 finalColor = r0.xyz * r0.www;

  // HDR highlight boost for fire
  float peakNits = cb13v[0].x;
  if (peakNits > 0) {
    float lum = dot(finalColor, float3(0.2126, 0.7152, 0.0722));
    float hdrHeadroom = peakNits / 203.0;
    float highlightMask = smoothstep(0.33, 1.0, lum);
    finalColor *= lerp(1.0, hdrHeadroom, highlightMask);
  }

  o0.xyz = finalColor;
  o0.w = 1;
  return;
}