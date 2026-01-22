// ---- Created with 3Dmigoto v1.4.1 on Wed Jan 21 14:44:46 2026
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<uint4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb5 : register(b5)
{
  float4 cb5[3];
}

cbuffer cb4 : register(b4)
{
  float4 cb4[11];
}

cbuffer cb3 : register(b3)
{
  float4 cb3[5];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[2];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[1];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[52];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear centroid float4 v0 : IO0_unClippedPos0,
  linear centroid float3 v1 : IO1_edgeuv0,
  nointerpolation float v2 : IO2_UI_UserBig0,
  nointerpolation float w2 : IO4_UI_UserSmall0,
  nointerpolation int w2 : IO6_UI_RenderType0,
  linear centroid float4 v3 : IO3_Gfx_ClipPosition0,
  linear centroid float2 v4 : IO5_Gfx_UV0,
  linear centroid float4 v5 : IO7_Gfx_Color0,
  float4 v6 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10;
  uint4 bitmask, uiDest;
  float4 fDest;

  // --- Clip plane tests
  r0.xyz = v0.xyz / v0.www;
  r0.w = cmp(0 < asuint(cb3[0].y));
  r1.x = dot(cb3[1].xyz, r0.xyz);
  r1.x = cb3[1].w + r1.x;
  r1.x = cmp(r1.x < 0);
  r1.x = r0.w ? r1.x : 0;
  if (r1.x != 0) discard;
  r1.x = dot(cb3[2].xyz, r0.xyz);
  r1.x = cb3[2].w + r1.x;
  r1.x = cmp(r1.x < 0);
  r1.x = r0.w ? r1.x : 0;
  if (r1.x != 0) discard;
  r1.x = dot(cb3[3].xyz, r0.xyz);
  r1.x = cb3[3].w + r1.x;
  r1.x = cmp(r1.x < 0);
  r1.x = r0.w ? r1.x : 0;
  if (r1.x != 0) discard;
  r0.x = dot(cb3[4].xyz, r0.xyz);
  r0.x = cb3[4].w + r0.x;
  r0.x = cmp(r0.x < 0);
  r0.x = r0.x ? r0.w : 0;
  if (r0.x != 0) discard;
  // --- Stencil/bitmask discard
  r0.xy = cb1[0].zw * v6.xy;
  r0.xy = (int2)r0.xy;
  r0.zw = float2(0,0);
  r0.x = t1.Load(r0.xyz).x;
  r0.y = (int)r0.x & asint(cb3[0].x);
  if (r0.y != 0) discard;
  // --- Edge coverage from v1 and derivatives
  r0.yz = v1.xy / v1.zz;
  r1.xy = r0.yz + r0.yz;
  r0.yz = r0.yz * float2(2,2) + float2(-1,-1);
  r0.yz = float2(1,1) + -abs(r0.yz);
  r1.zw = ddx_coarse(r1.xy);
  r1.xy = ddy_coarse(r1.xy);
  r1.xy = abs(r1.zw) + abs(r1.xy);
  r1.xy = float2(9.99999975e-06,9.99999975e-06) + r1.xy;
  r0.yz = saturate(r0.yz / r1.xy);
  r0.y = r0.y * r0.z;
  r1.w = v5.w * r0.y;
  // --- Noise/jitter for UI sampling
  t2.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
  r0.yz = uiDest.xy;
  r0.yz = (uint2)r0.yz;
  r2.xy = float2(0.0439999998,0.0370000005) * cb4[10].zz;
  r3.xyzw = cb4[10].zzzz * float4(0.100000001,0.100000001,0.100000001,0.100000001) + float4(0.400000006,0.0599999987,2.74000001,1.97000003);
  r3.xyzw = float4(0.439999998,1,5.73999977,2) * r3.xyzw;
  r3.xyzw = sin(r3.xyzw);
  r3.xyzw = r3.xyxy + r3.zwzw;
  r3.xyzw = float4(27.2199993,21.0400009,27.2199993,21.0400009) * r3.xyzw;
  r3.xyzw = floor(r3.xyzw);
  r3.xyzw = float4(6.5,0.0599999987,3.75999999,1.97000003) + r3.xyzw;
  r3.xyzw = float4(6.9000001,12.0600004,1.79999995,6.01999998) * r3.xyzw;
  r3.xyzw = sin(r3.xyzw);
  r2.zw = r3.xy + r3.zw;
  r2.xy = floor(r2.xy);
  r2.xy = r2.xy + r2.zw;
  r2.xy = v4.xy + r2.xy;
  r0.w = t3.Sample(s2_s, r2.xy).x;
  // --- Clamp/scale UI user parameter and compute quantized UVs
  r2.x = saturate(w2.x * 2 + cb5[0].y);
  r0.w = saturate(r0.w);
  r2.y = cmp(r2.x >= 1);
  r2.z = cmp(0 >= r2.x);
  r2.y = (int)r2.z | (int)r2.y;
  r0.w = r2.x * 2 + r0.w;
  r0.w = saturate(-1 + r0.w);
  r0.w = r2.y ? r2.x : r0.w;
  r2.xy = float2(1,1) + -r0.yz;
  r2.xy = r0.ww * r2.xy + r0.yz;
  r2.xy = floor(r2.xy);
  r2.zw = v4.xy * r2.xy;
  r2.zw = round(r2.zw);
  r2.xy = r2.zw / r2.xy;
  r0.w = cmp(0.00100000005 >= r0.w);
  r0.w = r0.w ? 1.000000 : 0;
  r2.zw = v4.xy + -r2.xy;
  r2.xy = r0.ww * r2.zw + r2.xy;
  r3.xyzw = ddx_coarse(r2.xyxy);
  r4.xyzw = ddy_coarse(r2.xyxy);
  // --- RenderType switch: choose sampling method for t2
  r0.w = cmp((int)w2.x == 1);
  if (r0.w != 0) {
    r2.w = t2.SampleGrad(s1_s, r2.xy, r3.z, r4.z).x;
    r2.z = 1;
    r5.xyzw = r2.zzzw;
  }
  if (r0.w == 0) {
    r0.w = cmp((int)w2.x == 2);
    if (r0.w != 0) {
      r2.z = asint(cb2[1].z);
      r2.zw = r0.yz / r2.zz;
      r6.xy = abs(r4.zw) + abs(r3.zw);
      r2.zw = r6.xy * r2.zw;
      r2.z = max(r2.z, r2.w);
      r2.w = 0.5 * r2.z;
      r6.x = r2.z * 0.5 + -0.400000006;
      r6.x = saturate(10.000001 * r6.x);
      r7.xyzw = -r3.zwzw * float4(0.375,0.375,0.125,0.125) + r2.xyxy;
      r6.yz = -r4.zw * float2(0.125,0.125) + r7.xy;
      r8.x = t2.SampleLevel(s1_s, r6.yz, 0).x;
      r6.yz = r4.zw * float2(0.375,0.375) + r7.zw;
      r8.y = t2.SampleLevel(s1_s, r6.yz, 0).x;
      r7.xyzw = r3.zwzw * float4(0.125,0.125,0.375,0.375) + r2.xyxy;
      r6.yz = -r4.zw * float2(0.375,0.375) + r7.xy;
      r8.z = t2.SampleLevel(s1_s, r6.yz, 0).x;
      r6.yz = r4.zw * float2(0.125,0.125) + r7.zw;
      r8.w = t2.SampleLevel(s1_s, r6.yz, 0).x;
      r7.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r8.xyzw;
      r7.xyzw = r2.zzzz * float4(0.25,0.25,0.25,0.25) + r7.xyzw;
      r7.xyzw = saturate(r7.xyzw / r2.wwww);
      r8.xyzw = r8.xyzw + -r7.xyzw;
      r7.xyzw = r6.xxxx * r8.xyzw + r7.xyzw;
      r8.xyzw = r7.xyzw * r7.xyzw;
      r9.xyzw = -r7.xyzw * float4(2,2,2,2) + float4(3,3,3,3);
      r9.xyzw = r9.xyzw * r8.xyzw;
      r8.xyzw = r8.xyzw * r7.xyzw;
      r10.xyzw = r7.xyzw * float4(6,6,6,6) + float4(-15,-15,-15,-15);
      r7.xyzw = r7.xyzw * r10.xyzw + float4(10,10,10,10);
      r7.xyzw = r8.xyzw * r7.xyzw + -r9.xyzw;
      r6.xyzw = r6.xxxx * r7.xyzw + r9.xyzw;
      r2.z = dot(r6.xyzw, float4(1,1,1,1));
      r5.w = 0.25 * r2.z;
      r5.xyz = float3(1,1,1);
    }
    if (r0.w == 0) {
      r0.w = cmp((int)w2.x == 3);
      if (r0.w != 0) {
        // --- Custom filter kernel for mode 3
        r2.zw = abs(r4.zw) + abs(r3.zw);
        r0.yz = r2.zw * r0.yz;
        r0.y = max(r0.y, r0.z);
        r0.z = 0.5 * r0.y;
        r2.z = r0.y * 0.5 + -0.400000006;
        r2.z = saturate(10.000001 * r2.z);
        r6.xyzw = -r3.zwxy * float4(0.375,0.375,0.125,0.125) + r2.xyxy;
        r6.xy = -r4.xy * float2(0.125,0.125) + r6.xy;
        r7.x = t2.SampleLevel(s1_s, r6.xy, 0).x;
        r6.xy = r4.zw * float2(0.375,0.375) + r6.zw;
        r7.y = t2.SampleLevel(s1_s, r6.xy, 0).x;
        r3.xyzw = r3.xyzw * float4(0.125,0.125,0.375,0.375) + r2.xyxy;
        r3.xy = -r4.zw * float2(0.375,0.375) + r3.xy;
        r7.z = t2.SampleLevel(s1_s, r3.xy, 0).x;
        r3.xy = r4.xy * float2(0.125,0.125) + r3.zw;
        r7.w = t2.SampleLevel(s1_s, r3.xy, 0).x;
        r3.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r7.xyzw;
        r3.xyzw = r0.yyyy * float4(0.25,0.25,0.25,0.25) + r3.xyzw;
        r3.xyzw = saturate(r3.xyzw / r0.zzzz);
        r4.xyzw = r7.xyzw + -r3.xyzw;
        r3.xyzw = r2.zzzz * r4.xyzw + r3.xyzw;
        r4.xyzw = r3.xyzw * r3.xyzw;
        r6.xyzw = -r3.xyzw * float4(2,2,2,2) + float4(3,3,3,3);
        r6.xyzw = r6.xyzw * r4.xyzw;
        r4.xyzw = r4.xyzw * r3.xyzw;
        r7.xyzw = r3.xyzw * float4(6,6,6,6) + float4(-15,-15,-15,-15);
        r3.xyzw = r3.xyzw * r7.xyzw + float4(10,10,10,10);
        r3.xyzw = r4.xyzw * r3.xyzw + -r6.xyzw;
        r3.xyzw = r2.zzzz * r3.xyzw + r6.xyzw;
        r0.y = dot(r3.xyzw, float4(1,1,1,1));
        r5.w = 0.25 * r0.y;
        r5.xyz = float3(1,1,1);
      }
      if (r0.w == 0) {
        // --- Default: use LOD from hardware
        r0.y = t2.CalculateLevelOfDetail(s1_s, r2.xy);
        r5.xyzw = t2.SampleLevel(s1_s, r2.xy, r0.y).xyzw;
      }
    }
  }
  // --- Multiply sampled coverage by UI color
  r1.xyz = v5.xyz;
  r1.xyzw = r5.xyzw * r1.xyzw;
  // --- Depth/alpha modulation using cb5 parameters
  r0.yz = cb1[0].xy * v6.xy;
  r0.yz = r0.yz * cb0[50].zw + cb0[51].xy;
  r0.y = t0.SampleLevel(s0_s, r0.yz, 0).x;
  r0.y = v3.w + -r0.y;
  r0.z = saturate(v2.x);
  r0.w = -cb5[0].z + r0.y;
  r2.x = cb5[0].w + -cb5[0].z;
  r0.w = saturate(r0.w / r2.x);
  r0.z = -cb5[1].x + r0.z;
  r0.z = r0.w * r0.z + cb5[1].x;
  r0.y = -cb5[1].y + r0.y;
  r0.w = cb5[1].z + -cb5[1].y;
  r0.y = saturate(r0.y / r0.w);
  r0.w = cb5[2].x + -cb5[1].w;
  r0.y = r0.y * r0.w + cb5[1].w;
  r0.x = (uint)r0.x;
  r0.x = cmp(r0.x == 1.000000);
  r0.x = r0.x ? 1.000000 : 0;
  r0.y = r0.y + -r0.z;
  r0.x = r0.x * r0.y + r0.z;
  r1.w = r1.w * r0.x;
  // --- Premultiply and output
  r0.x = 1;
  r0.w = cb5[0].x;
  r0.xyzw = r1.xyzw * r0.xxxw;
  r2.x = 1;
  r2.w = 1 + -cb5[0].x;
  r1.xyzw = r2.xxxw * r1.xyzw;
  r1.xyz = r1.xyz * r1.www;
  o0.xyz = r0.xyz * r0.www + r1.xyz;
  o0.w = r1.w;
  return;
}