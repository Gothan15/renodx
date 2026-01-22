// ---- Created with 3Dmigoto v1.4.1 on Wed Jan 21 14:44:46 2026
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[2];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear centroid float2 v0 : IO0_uv0,
  linear centroid float2 w0 : IO1_pixcoord0,
  linear centroid float4 v1 : IO2_offsets0,
  linear centroid float4 v2 : IO2_offsets1,
  linear centroid float4 v3 : IO2_offsets2,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  // --- Early reject: check base mask/edge value
  r0.xy = t0.SampleLevel(s0_s, v0.xy, 0).xy;
  r0.y = cmp(0 < r0.y);
  if (r0.y != 0) {
    // --- Search left/up for edge run length (loop up to cb0[1].x)
    r0.y = cmp(0 < r0.x);
    r1.xyzw = cb0[0].xyxy * float4(-1,1,1,-1) + v0.xyxy;
    r0.zw = r1.xy;
    r2.xy = float2(0,0);
    while (true) {
      r2.z = cmp(r2.y >= cb0[1].x);
      if (r2.z != 0) break;
      r2.zw = t0.SampleLevel(s0_s, r0.zw, 0).xy;
      r2.z = dot(r2.zw, float2(1,1));
      r2.z = cmp(r2.z < 1.89999998);
      r2.xz = r2.wz;
      if (r2.z != 0) break;
      r0.zw = cb0[0].xy * float2(-1,1) + r0.zw;
      r2.y = 1 + r2.y;
      r2.xy = r2.wy;
    }
    // --- Resolve first direction length, then search opposite direction
    r0.z = cmp(0.899999976 < r2.x);
    r0.z = r0.z ? 1.000000 : 0;
    r0.z = r2.y + r0.z;
    r2.y = r0.y ? r0.z : 0;
    r0.yz = r1.zw;
    r0.w = 0;
    while (true) {
      r1.x = cmp(r0.w >= cb0[1].x);
      if (r1.x != 0) break;
      r1.xy = t0.SampleLevel(s0_s, r0.yz, 0).xy;
      r1.x = dot(r1.xy, float2(1,1));
      r1.x = cmp(r1.x < 1.89999998);
      if (r1.x != 0) break;
      r0.yz = cb0[0].xy * float2(1,-1) + r0.yz;
      r0.w = 1 + r0.w;
    }
    r0.y = r2.y + r0.w;
    r0.y = cmp(2 < r0.y);
    if (r0.y != 0) {
      // --- Sample pattern lookup from t1 based on edge lengths
      r2.x = -r2.y;
      r2.zw = float2(1,-1) * r0.ww;
      r1.xyzw = r2.xyzw * cb0[0].xyxy + v0.xyxy;
      r0.y = t0.SampleLevel(s0_s, r1.xy, 0, int2(-1, 0)).y;
      r1.x = t0.SampleLevel(s0_s, r1.xy, 0, int2(0, 0)).x;
      r0.z = t0.SampleLevel(s0_s, r1.zw, 0, int2(1, 0)).y;
      r1.y = t0.SampleLevel(s0_s, r1.zw, 0, int2(1, -1)).x;
      r0.yz = r0.yz * float2(2,2) + r1.xy;
      r0.w = -1 + cb0[1].x;
      r1.xy = cmp(r0.ww >= r2.yz);
      r1.xy = r1.xy ? float2(1,1) : 0;
      r0.yz = r1.xy * r0.yz;
      r0.yz = r0.yz * float2(20,20) + r2.yz;
      r0.yz = r0.yz * float2(0.00625000009,0.0017857143) + float2(0.503125012,0.000892857148);
      r0.yz = t1.SampleLevel(s0_s, r0.yz, 0).xy;
    } else {
      r0.yz = float2(0,0);
    }
    // --- Search left for second axis (horizontal/vertical pass)
    r1.xy = -cb0[0].xy + v0.xy;
    r1.zw = r1.xy;
    r2.x = 0;
    while (true) {
      r0.w = cmp(r2.x >= cb0[1].x);
      if (r0.w != 0) break;
      r3.y = t0.SampleLevel(s0_s, r1.zw, 0).y;
      r3.x = t0.SampleLevel(s0_s, r1.zw, 0, int2(1, 0)).x;
      r0.w = dot(r3.xy, float2(1,1));
      r0.w = cmp(r0.w < 1.89999998);
      if (r0.w != 0) break;
      r1.zw = -cb0[0].xy + r1.zw;
      r2.x = 1 + r2.x;
    }
    // --- Search right and resolve edge length
    r0.w = t0.SampleLevel(s0_s, v0.xy, 0, int2(1, 0)).x;
    r0.w = cmp(0 < r0.w);
    r1.xy = cb0[0].xy + v0.xy;
    r1.zw = r1.xy;
    r2.w = 0;
    r3.x = 0;
    while (true) {
      r3.y = cmp(r3.x >= cb0[1].x);
      if (r3.y != 0) break;
      r3.z = t0.SampleLevel(s0_s, r1.zw, 0).y;
      r3.y = t0.SampleLevel(s0_s, r1.zw, 0, int2(1, 0)).x;
      r3.y = dot(r3.yz, float2(1,1));
      r3.y = cmp(r3.y < 1.89999998);
      r2.w = r3.z;
      if (r3.y != 0) break;
      r1.zw = cb0[0].xy + r1.zw;
      r3.x = 1 + r3.x;
      r2.w = r3.z;
    }
    r1.x = cmp(0.899999976 < r2.w);
    r1.x = r1.x ? 1.000000 : 0;
    r1.x = r3.x + r1.x;
    r2.z = r0.w ? r1.x : 0;
    r0.w = r2.x + r2.z;
    r0.w = cmp(2 < r0.w);
    if (r0.w != 0) {
      // --- Sample pattern lookup for this axis and accumulate
      r2.y = -r2.x;
      r1.xyzw = r2.yyzz * cb0[0].xyxy + v0.xyxy;
      r3.x = t0.SampleLevel(s0_s, r1.xy, 0, int2(-1, 0)).y;
      r3.z = t0.SampleLevel(s0_s, r1.xy, 0, int2(0, -1)).x;
      r3.yw = t0.SampleLevel(s0_s, r1.zw, 0, int2(1, 0)).yx;
      r1.xy = r3.xy * float2(2,2) + r3.zw;
      r0.w = -1 + cb0[1].x;
      r1.zw = cmp(r0.ww >= r2.xz);
      r1.zw = r1.zw ? float2(1,1) : 0;
      r1.xy = r1.xy * r1.zw;
      r1.xy = r1.xy * float2(20,20) + r2.xz;
      r1.xy = r1.xy * float2(0.00625000009,0.0017857143) + float2(0.503125012,0.000892857148);
      r1.xy = t1.SampleLevel(s0_s, r1.xy, 0).xy;
      r0.yz = r1.yx + r0.yz;
    }
    // --- If still no pattern, fall back to edge neighborhood refinement
    r0.w = dot(r0.yz, float2(1,1));
    r0.w = cmp(r0.w == 0.000000);
    if (r0.w != 0) {
      // --- Vertical traversal using v1/v3 offsets
      r1.xy = v1.yx;
      r1.z = 1;
      r2.x = 0;
      while (true) {
        r0.w = cmp(v3.x < r1.y);
        r1.w = cmp(0.828100026 < r1.z);
        r0.w = r0.w ? r1.w : 0;
        r1.w = cmp(r2.x == 0.000000);
        r0.w = r0.w ? r1.w : 0;
        if (r0.w == 0) break;
        r2.xy = t0.SampleLevel(s0_s, r1.yx, 0).xy;
        r1.xy = -cb0[0].yx * float2(0,2) + r1.xy;
        r1.z = r2.y;
      }
      // --- Build lookup coords and sample t2/t1 to reconstruct offsets
      r0.w = cb0[0].x * 3.25 + r1.y;
      r1.x = 0.5 * r2.x;
      r1.x = t2.SampleLevel(s1_s, r1.xz, 0).x;
      r1.x = cb0[0].x * r1.x;
      r1.x = -r1.x * 255 + r0.w;
      r1.y = v2.y;
      r2.x = t0.SampleLevel(s0_s, r1.xy, 0).x;
      r3.xy = v1.wz;
      r3.z = 1;
      r2.z = 0;
      while (true) {
        r0.w = cmp(r3.y < v3.y);
        r1.w = cmp(0.828100026 < r3.z);
        r0.w = r0.w ? r1.w : 0;
        r1.w = cmp(r2.z == 0.000000);
        r0.w = r0.w ? r1.w : 0;
        if (r0.w == 0) break;
        r2.zw = t0.SampleLevel(s0_s, r3.yx, 0).xy;
        r3.xy = cb0[0].yx * float2(0,2) + r3.xy;
        r3.z = r2.w;
      }
      r0.w = -cb0[0].x * 0.25 + r3.y;
      r0.w = cb0[0].x * -3 + r0.w;
      r3.x = r2.z * 0.5 + 0.5;
      r1.w = t2.SampleLevel(s1_s, r3.xz, 0).x;
      r1.w = cb0[0].x * r1.w;
      r1.z = r1.w * 255 + r0.w;
      r1.xw = r1.xz / cb0[0].xx;
      r1.xw = -w0.xz + r1.xw;
      r2.zw = sqrt(abs(r1.xw));
      r2.y = t0.SampleLevel(s0_s, r1.zy, 0, int2(1, 0)).x;
      r1.yz = float2(4,4) * r2.xy;
      r1.yz = round(r1.yz);
      r1.yz = r1.yz * float2(16,16) + r2.zw;
      r1.yz = r1.yz * float2(0.00625000009,0.0017857143) + float2(0.00312500005,0.000892857148);
      r1.yz = t1.SampleLevel(s0_s, r1.yz, 0).xy;
      r2.xz = cb0[0].xx * r1.xw;
      r2.y = 0;
      r2.xyz = v0.xyx + r2.xyz;
      r3.x = t0.SampleLevel(s0_s, r2.xy, 0, int2(0, 1)).x;
      r0.w = cmp(abs(r1.x) < abs(r1.w));
      r3.y = t0.SampleLevel(s0_s, r2.xy, 0, int2(0, -2)).x;
      r1.x = cb0[1].y * 0.00999999978 + 1;
      r2.xw = saturate(-r3.xy + r1.xx);
      r2.xw = r2.xw * r1.yz;
      r1.yz = r0.ww ? r2.xw : r1.yz;
      r3.x = t0.SampleLevel(s0_s, r2.zy, 0, int2(1, 1)).x;
      r3.y = t0.SampleLevel(s0_s, r2.zy, 0, int2(1, -2)).x;
      r1.xw = saturate(-r3.xy + r1.xx);
      r1.xy = r1.yz * r1.xw;
      o0.xy = r0.ww ? r2.xw : r1.xy;
    } else {
      o0.xy = r0.yz;
      r0.x = 0;
    }
  } else {
    o0.xy = float2(0,0);
  }
  // --- Optional second pass (z/w outputs) if base edge present
  r0.x = cmp(0 < r0.x);
  if (r0.x != 0) {
    // --- Similar traversal along the orthogonal axis
    r0.xy = v2.xy;
    r0.z = 1;
    r1.x = 0;
    while (true) {
      r0.w = cmp(v3.z < r0.y);
      r1.z = cmp(0.828100026 < r0.z);
      r0.w = r0.w ? r1.z : 0;
      r1.z = cmp(r1.x == 0.000000);
      r0.w = r0.w ? r1.z : 0;
      if (r0.w == 0) break;
      r1.xy = t0.SampleLevel(s0_s, r0.xy, 0).yx;
      r0.xy = -cb0[0].xy * float2(0,2) + r0.xy;
      r0.z = r1.y;
    }
    // --- Build lookup coords and sample t2/t1 for offset reconstruction
    r0.y = cb0[0].y * 3.25 + r0.y;
    r0.x = 0.5 * r1.x;
    r0.x = t2.SampleLevel(s1_s, r0.xz, 0).x;
    r0.x = cb0[0].y * r0.x;
    r0.x = -r0.x * 255 + r0.y;
    r0.y = v1.x;
    r1.x = t0.SampleLevel(s0_s, r0.yx, 0).y;
    r2.xy = v2.zw;
    r2.z = 1;
    r1.z = 0;
    while (true) {
      r0.w = cmp(r2.y < v3.w);
      r2.w = cmp(0.828100026 < r2.z);
      r0.w = r0.w ? r2.w : 0;
      r2.w = cmp(r1.z == 0.000000);
      r0.w = r0.w ? r2.w : 0;
      if (r0.w == 0) break;
      r1.zw = t0.SampleLevel(s0_s, r2.xy, 0).yx;
      r2.xy = cb0[0].xy * float2(0,2) + r2.xy;
      r2.z = r1.w;
    }
    r0.w = -cb0[0].y * 0.25 + r2.y;
    r0.w = cb0[0].y * -3 + r0.w;
    r2.x = r1.z * 0.5 + 0.5;
    r1.z = t2.SampleLevel(s1_s, r2.xz, 0).x;
    r1.z = cb0[0].y * r1.z;
    r0.z = r1.z * 255 + r0.w;
    r0.xw = r0.xz / cb0[0].yy;
    r2.yz = -w0.yw + r0.xw;
    r0.xw = sqrt(abs(r2.yz));
    r1.y = t0.SampleLevel(s0_s, r0.yz, 0, int2(0, 1)).y;
    r0.yz = float2(4,4) * r1.xy;
    r0.yz = round(r0.yz);
    r0.xy = r0.yz * float2(16,16) + r0.xw;
    r0.xy = r0.xy * float2(0.00625000009,0.0017857143) + float2(0.00312500005,0.000892857148);
    r0.xy = t1.SampleLevel(s0_s, r0.xy, 0).xy;
    r2.x = 0;
    r1.xyz = r2.xyz * cb0[0].xyy + v0.xyy;
    r0.z = t0.SampleLevel(s0_s, r1.xy, 0, int2(1, 0)).y;
    r1.w = cmp(abs(r2.y) < abs(r2.z));
    r0.w = t0.SampleLevel(s0_s, r1.xy, 0, int2(-2, 0)).y;
    r1.y = cb0[1].y * 0.00999999978 + 1;
    r0.zw = saturate(r1.yy + -r0.zw);
    r0.zw = r0.xy * r0.zw;
    r0.xy = r1.ww ? r0.zw : r0.xy;
    r2.x = t0.SampleLevel(s0_s, r1.xz, 0, int2(1, 1)).y;
    r2.y = t0.SampleLevel(s0_s, r1.xz, 0, int2(-2, 1)).y;
    r1.xy = saturate(-r2.xy + r1.yy);
    r0.xy = r1.xy * r0.xy;
    o0.zw = r1.ww ? r0.zw : r0.xy;
  } else {
    o0.zw = float2(0,0);
  }
  return;
}