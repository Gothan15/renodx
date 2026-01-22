// ---- Created with 3Dmigoto v1.4.1 on Wed Jan 21 14:44:46 2026
Texture2D<float4> t1 : register(t1);

Texture2D<uint4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[5];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[2];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear centroid float4 v0 : IO0_unClipPos0,
  linear centroid float4 v1 : IO1_color0,
  linear centroid float4 v2 : IO2_uv1,
  linear centroid float2 v3 : IO3_uv2,
  linear centroid float w3 : IO5_additive0,
  linear centroid float3 v4 : IO4_edgeuv0,
  nointerpolation int v5 : IO6_renderType0,
  float4 v6 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  // --- Clip plane tests
  r0.xyz = v0.xyz / v0.www;
  r0.w = cmp(0 < asuint(cb2[0].y));
  r1.x = dot(cb2[1].xyz, r0.xyz);
  r1.x = cb2[1].w + r1.x;
  r1.x = cmp(r1.x < 0);
  r1.x = r0.w ? r1.x : 0;
  if (r1.x != 0) discard;
  r1.x = dot(cb2[2].xyz, r0.xyz);
  r1.x = cb2[2].w + r1.x;
  r1.x = cmp(r1.x < 0);
  r1.x = r0.w ? r1.x : 0;
  if (r1.x != 0) discard;
  r1.x = dot(cb2[3].xyz, r0.xyz);
  r1.x = cb2[3].w + r1.x;
  r1.x = cmp(r1.x < 0);
  r1.x = r0.w ? r1.x : 0;
  if (r1.x != 0) discard;
  r0.x = dot(cb2[4].xyz, r0.xyz);
  r0.x = cb2[4].w + r0.x;
  r0.x = cmp(r0.x < 0);
  r0.x = r0.x ? r0.w : 0;
  if (r0.x != 0) discard;
  // --- Stencil/bitmask discard
  r0.xy = cb0[0].zw * v6.xy;
  r0.xy = (int2)r0.xy;
  r0.zw = float2(0,0);
  r0.x = t0.Load(r0.xyz).x;
  r0.x = (int)r0.x & asint(cb2[0].x);
  if (r0.x != 0) discard;
  // --- Edge coverage from v4 and derivatives
  r0.xy = v4.xy / v4.zz;
  r0.zw = r0.xy + r0.xy;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r0.xy = float2(1,1) + -abs(r0.xy);
  r1.xy = ddx_coarse(r0.zw);
  r0.zw = ddy_coarse(r0.zw);
  r0.zw = abs(r1.xy) + abs(r0.zw);
  r0.zw = float2(9.99999975e-06,9.99999975e-06) + r0.zw;
  r0.xy = saturate(r0.xy / r0.zw);
  r0.x = r0.x * r0.y;
  // --- RenderType switch: choose sampling method for t1
  r1.xyzw = ddx_coarse(v2.xyxy);
  r2.xyzw = ddy_coarse(v2.xyxy);
  r0.y = cmp((int)v5.x == 1);
  if (r0.y != 0) {
    r0.w = t1.SampleGrad(s0_s, v2.xy, r1.z, r2.z).x;
    r0.z = 1;
    r3.xyzw = r0.zzzw;
  }
  if (r0.y == 0) {
    r0.y = cmp((int)v5.x == 2);
    if (r0.y != 0) {
      r0.z = asint(cb1[1].z);
      t1.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
      r4.xy = uiDest.xy;
      r4.xy = (uint2)r4.xy;
      r0.zw = r4.xy / r0.zz;
      r4.xy = abs(r2.zw) + abs(r1.zw);
      r0.zw = r4.xy * r0.zw;
      r0.z = max(r0.z, r0.w);
      r0.w = 0.5 * r0.z;
      r4.x = r0.z * 0.5 + -0.400000006;
      r4.x = saturate(10.000001 * r4.x);
      r5.xyzw = -r1.zwzw * float4(0.375,0.375,0.125,0.125) + v2.xyxy;
      r4.yz = -r2.zw * float2(0.125,0.125) + r5.xy;
      r6.x = t1.SampleLevel(s0_s, r4.yz, 0).x;
      r4.yz = r2.zw * float2(0.375,0.375) + r5.zw;
      r6.y = t1.SampleLevel(s0_s, r4.yz, 0).x;
      r5.xyzw = r1.zwzw * float4(0.125,0.125,0.375,0.375) + v2.xyxy;
      r4.yz = -r2.zw * float2(0.375,0.375) + r5.xy;
      r6.z = t1.SampleLevel(s0_s, r4.yz, 0).x;
      r4.yz = r2.zw * float2(0.125,0.125) + r5.zw;
      r6.w = t1.SampleLevel(s0_s, r4.yz, 0).x;
      r5.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r6.xyzw;
      r5.xyzw = r0.zzzz * float4(0.25,0.25,0.25,0.25) + r5.xyzw;
      r5.xyzw = saturate(r5.xyzw / r0.wwww);
      r6.xyzw = r6.xyzw + -r5.xyzw;
      r5.xyzw = r4.xxxx * r6.xyzw + r5.xyzw;
      r6.xyzw = r5.xyzw * r5.xyzw;
      r7.xyzw = -r5.xyzw * float4(2,2,2,2) + float4(3,3,3,3);
      r7.xyzw = r7.xyzw * r6.xyzw;
      r6.xyzw = r6.xyzw * r5.xyzw;
      r8.xyzw = r5.xyzw * float4(6,6,6,6) + float4(-15,-15,-15,-15);
      r5.xyzw = r5.xyzw * r8.xyzw + float4(10,10,10,10);
      r5.xyzw = r6.xyzw * r5.xyzw + -r7.xyzw;
      r4.xyzw = r4.xxxx * r5.xyzw + r7.xyzw;
      r0.z = dot(r4.xyzw, float4(1,1,1,1));
      r3.w = 0.25 * r0.z;
      r3.xyz = float3(1,1,1);
    }
    if (r0.y == 0) {
      r0.y = cmp((int)v5.x == 3);
      if (r0.y != 0) {
        // --- Custom filter kernel for mode 3
        t1.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
        r0.zw = uiDest.xy;
        r0.zw = (uint2)r0.zw;
        r4.xy = abs(r2.zw) + abs(r1.zw);
        r0.zw = r4.xy * r0.zw;
        r0.z = max(r0.z, r0.w);
        r0.w = 0.5 * r0.z;
        r4.x = r0.z * 0.5 + -0.400000006;
        r4.x = saturate(10.000001 * r4.x);
        r5.xyzw = -r1.zwxy * float4(0.375,0.375,0.125,0.125) + v2.xyxy;
        r4.yz = -r2.xy * float2(0.125,0.125) + r5.xy;
        r6.x = t1.SampleLevel(s0_s, r4.yz, 0).x;
        r4.yz = r2.zw * float2(0.375,0.375) + r5.zw;
        r6.y = t1.SampleLevel(s0_s, r4.yz, 0).x;
        r1.xyzw = r1.xyzw * float4(0.125,0.125,0.375,0.375) + v2.xyxy;
        r1.xy = -r2.zw * float2(0.375,0.375) + r1.xy;
        r6.z = t1.SampleLevel(s0_s, r1.xy, 0).x;
        r1.xy = r2.xy * float2(0.125,0.125) + r1.zw;
        r6.w = t1.SampleLevel(s0_s, r1.xy, 0).x;
        r1.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r6.xyzw;
        r1.xyzw = r0.zzzz * float4(0.25,0.25,0.25,0.25) + r1.xyzw;
        r1.xyzw = saturate(r1.xyzw / r0.wwww);
        r2.xyzw = r6.xyzw + -r1.xyzw;
        r1.xyzw = r4.xxxx * r2.xyzw + r1.xyzw;
        r2.xyzw = r1.xyzw * r1.xyzw;
        r5.xyzw = -r1.xyzw * float4(2,2,2,2) + float4(3,3,3,3);
        r5.xyzw = r5.xyzw * r2.xyzw;
        r2.xyzw = r2.xyzw * r1.xyzw;
        r6.xyzw = r1.xyzw * float4(6,6,6,6) + float4(-15,-15,-15,-15);
        r1.xyzw = r1.xyzw * r6.xyzw + float4(10,10,10,10);
        r1.xyzw = r2.xyzw * r1.xyzw + -r5.xyzw;
        r1.xyzw = r4.xxxx * r1.xyzw + r5.xyzw;
        r0.z = dot(r1.xyzw, float4(1,1,1,1));
        r3.w = 0.25 * r0.z;
        r3.xyz = float3(1,1,1);
      }
      if (r0.y == 0) {
        // --- Default: use LOD from hardware
        r0.y = t1.CalculateLevelOfDetail(s0_s, v2.xy);
        r3.xyzw = t1.SampleLevel(s0_s, v2.xy, r0.y).xyzw;
      }
    }
  }
  // --- Multiply sampled coverage by input color and apply additive control
  r1.xyzw = v1.xyzw * r3.xyzw;
  r1.w = r1.w * r0.x;
  r0.x = 1;
  r0.w = w3.x;
  r0.xyzw = r1.xyzw * r0.xxxw;
  r2.x = 1;
  r2.w = 1 + -w3.x;
  r1.xyzw = r2.xxxw * r1.xyzw;
  r1.xyz = r1.xyz * r1.www;
  o0.xyz = r0.xyz * r0.www + r1.xyz;
  o0.w = r1.w;
  return;
}