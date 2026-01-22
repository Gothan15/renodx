// ---- Created with 3Dmigoto v1.4.1 on Wed Jan 21 14:44:46 2026
Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture3D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[8];
}




// 3Dmigoto declarations
#define cmp(x) ((x) ? 1.0 : 0.0)


void main(
  float2 v0 : IO0_uv0,
  float2 w0 : IO1_uv1,
  nointerpolation float2 v1 : IO2_uv0Min0,
  nointerpolation float2 w1 : IO3_uv0Max0,
  nointerpolation float2 v2 : IO4_uv1Min0,
  nointerpolation float2 w2 : IO5_uv1Max0,
  float4 v3 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  // --- Compute center/bounds and radial offsets for sampling
  r0.xy = w1.xy + -v1.xy;
  r0.xy = r0.xy * float2(0.5,0.5) + v1.xy;
  r0.zw = v0.xy + -r0.xy;
  r1.x = dot(abs(r0.zw), cb0[1].zw);
  r1.x = sqrt(r1.x);
  r1.xyz = cb0[4].xyz * r1.xxx + float3(1,1,1);
  r2.xyzw = r0.zwzw * r1.xxyy + r0.xyxy;
  r2.xyzw = max(v1.xyxy, r2.xyzw);
  r2.xyzw = min(w1.xyxy, r2.xyzw);
  r0.xy = r0.zw * r1.zz + r0.xy;
  r0.xy = max(v1.xy, r0.xy);
  r0.xy = min(w1.xy, r0.xy);
  // --- Gather neighborhood luminance/weights
  r1.x = t0.SampleLevel(s0_s, r2.xy, 0).x;
  r1.y = t0.SampleLevel(s0_s, r2.zw, 0).y;
  r1.z = t0.SampleLevel(s0_s, r0.xy, 0).z;
  // --- Blend with blur/highlight inputs (t2/t4) and optional t3
  r0.x = t2.SampleLevel(s1_s, v0.xy, 0).x;
  r0.yz = v3.xy * cb0[7].xy + cb0[7].zw;
  r0.y = t4.SampleLevel(s1_s, r0.yz, 0).x;
  r0.x = cb0[3].w * r0.x;
  r0.x = max(r0.x, r0.y);
  r0.z = cmp(0 < r0.x);
  if (r0.z != 0) {
    // --- Composite t3 into the neighborhood when mask active
    r0.zw = max(v2.xy, w0.xy);
    r0.zw = min(w2.xy, r0.zw);
    r2.xyz = t3.SampleLevel(s1_s, r0.zw, 0).xyz;
    r2.xyz = r2.xyz + -r1.xyz;
    r0.xzw = r0.xxx * r2.xyz + r1.xyz;
    r0.y = r0.y + r0.y;
    r0.y = min(1, r0.y);
    r1.w = dot(r0.xzw, r0.xzw);
    r1.w = sqrt(r1.w);
    // --- Normalize/limit based on cb0[2].w
    r0.y = -cb0[2].w * r0.y + 1;
    r0.y = 1.73199999 * r0.y;
    r0.y = min(r1.w, r0.y);
    r1.w = max(9.99999975e-05, r1.w);
    r0.y = r0.y / r1.w;
    r1.xyz = r0.xzw * r0.yyy;
  }
  // --- 3D LUT lookup and final color scale/bias
  // Bypass LUT to test HDR output
  r0.xyz = r1.xyz;
  o0.xyz = r0.xyz * cb0[3].xyz + cb0[2].xyz;
  o0.w = 1;
  return;
}