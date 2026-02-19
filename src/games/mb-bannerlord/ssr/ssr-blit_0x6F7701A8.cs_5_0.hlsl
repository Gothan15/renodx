// ---- Created with 3Dmigoto v1.4.1 on Wed Feb 18 23:07:38 2026
Texture2D<float4> t0 : register(t0);

cbuffer cb2 : register(b2)
{
  float4 cb2[1];
}

RWTexture2D<float4> u0 : register(u0);

// 3Dmigoto declarations
#define cmp -


[numthreads(32,32,1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;
  r0.xy = (uint2)vThreadID.xy;
  r0.zw = cb2[0].xy + cb2[0].xy;
  r0.zw = float2(1,1) / r0.zw;
  r0.xy = cmp(r0.xy < r0.zw);
  r0.x = r0.y ? r0.x : 0;
  if (r0.x != 0) {
    r0.xy = vThreadID.xy;
    r0.zw = float2(0,0);
    r0.xyzw = t0.Load(r0.xyz).xyzw;
    u0[vThreadID.xy] = r0.xyzw;
  }
  return;
}