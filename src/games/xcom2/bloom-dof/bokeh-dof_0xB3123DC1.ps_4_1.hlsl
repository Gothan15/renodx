// ---- Created with 3Dmigoto v1.4.1 on Fri Feb 20 19:58:52 2026

cbuffer _Globals : register(b0)
{
  float2 InvSize : packoffset(c0);
  float4 Weights[3] : packoffset(c1);
}

SamplerState BloomMipChain_s : register(s0);
Texture2D<float4> BloomMipChain : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  const float4 icb[] = { { 1.000000, 0, 0, 0},
                              { 0, 1.000000, 0, 0},
                              { 0, 0, 1.000000, 0},
                              { 0, 0, 0, 1.000000},
                              { -0.089068, 0.732343, 0, 0},
                              { 0.927216, -0.173444, 0, 0},
                              { 0.103671, -0.330136, 0, 0},
                              { -0.779488, 0.200650, 0, 0} };
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(0,0,0,0);
  r1.x = 0;
  while (true) {
    r1.y = cmp(r1.x >= 9);
    if (r1.y != 0) break;
    r1.y = 0.25 * r1.x;
    r1.z = frac(r1.y);
    r1.z = 4 * r1.z;
    r1.yz = (uint2)r1.yz;
    r1.y = dot(Weights[r1.y].xyzw, icb[r1.z+0].xyzw);
    r2.xyzw = r0.xyzw;
    r1.z = 0;
    while (true) {
      r1.w = cmp((int)r1.z >= 4);
      if (r1.w != 0) break;
      r3.xy = icb[r1.z+4].xy * InvSize.xy + v0.xy;
      r3.xyzw = BloomMipChain.SampleLevel(BloomMipChain_s, r3.xy, r1.x).xyzw;
      r2.xyzw = r3.xyzw * r1.yyyy + r2.xyzw;
      r1.z = (int)r1.z + 1;
    }
    r0.xyzw = r2.xyzw;
    r1.x = 1 + r1.x;
  }
  o0.xyzw = float4(0.25,0.25,0.25,0.25) * r0.xyzw;
  return;
}