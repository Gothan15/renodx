// ---- Created with 3Dmigoto v1.4.1 on Thu Feb 19 09:36:59 2026
Texture2D<float4> t0 : register(t0);

cbuffer cb2 : register(b2)
{
  float4 cb2[34];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = (uint)cb2[26].y;
  r0.y = (int)r0.x & 15;
  r0.x = (uint)r0.x >> 4;
  r0.x = (uint)r0.x;
  r0.x = v0.y * 16 + r0.x;
  r0.x = (uint)r0.x;
  r0.x = (uint)r0.x;
  r0.x = cb2[33].y * r0.x;
  r1.y = (int)r0.x;
  r0.x = (uint)r0.y;
  r0.x = v0.x * 16 + r0.x;
  r0.x = (uint)r0.x;
  r0.x = (uint)r0.x;
  r0.x = cb2[33].x * r0.x;
  r1.x = (int)r0.x;
  r1.zw = float2(0,0);
  o0.xyzw = t0.Load(r1.xyz).xyzw;
  return;
}