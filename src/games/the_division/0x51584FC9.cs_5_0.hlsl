// ---- Created with 3Dmigoto v1.4.1 on Wed Jan 21 14:27:57 2026
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0)
{
  float4 cb0[1];
}




// 3Dmigoto declarations
#define cmp -


void main)
{
// Needs manual fix for instruction:
// unknown dcl_: dcl_uav_typed_texture3d (float,float,float,float) u0
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

// Needs manual fix for instruction:
// unknown dcl_: dcl_thread_group 8, 8, 1
  // --- Compute linear X index from thread ID
  r0.x = (uint)vThreadID.z << 5;
  r0.x = (int)r0.x + (int)vThreadID.x;
  // --- Decide which input textures contribute (cb0[0].xyz flags)
  r1.xyz = cmp(float3(0,0,0) < cb0[0].xyz);
  if (r1.x != 0) {
    // --- Load t0 slice and apply weight cb0[0].x
    r0.y = vThreadID.y;
    r0.zw = float2(0,0);
    r2.xyz = t0.Load(r0.xyz).xyz;
    r2.xyz = cb0[0].xxx * r2.xyz;
  } else {
    r2.xyz = float3(0,0,0);
  }
  if (r1.y != 0) {
    // --- Load t1 slice and accumulate with weight cb0[0].y
    r0.y = vThreadID.y;
    r0.zw = float2(0,0);
    r1.xyw = t1.Load(r0.xyz).xyz;
    r2.xyz = cb0[0].yyy * r1.xyw + r2.xyz;
  }
  if (r1.z != 0) {
    // --- Load t2 slice and accumulate with weight cb0[0].z
    r0.y = vThreadID.y;
    r0.zw = float2(0,0);
    r0.xyz = t2.Load(r0.xyz).xyz;
    r2.xyz = cb0[0].zzz * r0.xyz + r2.xyz;
  }
  // --- Store combined result into UAV at thread ID
// No code for instruction (needs manual fix):
store_uav_typed u0.xyzw, vThreadID.xyzz, r2.xyzx
  return;
}