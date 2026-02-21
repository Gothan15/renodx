// ---- Created with 3Dmigoto v1.4.1 on Thu Feb 19 09:36:59 2026
Texture2D<float4> t16 : register(t16);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[106];
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

  r0.x = 1 + -v2.y;
  r0.x = r0.x * 2 + -1;
  r0.xyzw = cb0[44].xyzw * r0.xxxx;
  r1.x = v2.x * 2 + -1;
  r0.xyzw = cb0[43].xyzw * r1.xxxx + r0.xyzw;
  r1.xy = cb0[105].xy * v2.xy;
  r1.x = t16.Sample(s0_s, r1.xy).x;
  r0.xyzw = cb0[45].xyzw * r1.xxxx + r0.xyzw;
  r0.xyzw = cb0[46].xyzw + r0.xyzw;
  r0.xyz = r0.xyz / r0.www;
  r1.yzw = cb0[20].xyw * r0.yyy;
  r0.xyw = cb0[19].xyw * r0.xxx + r1.yzw;
  r0.xyz = cb0[21].xyw * r0.zzz + r0.xyw;
  r0.xyz = cb0[22].xyw + r0.xyz;
  r0.xy = r0.xy / r0.zz;
  r0.xy = r0.xy * float2(0.5,0.5) + float2(0.5,0.5);
  r0.z = 1 + -r0.y;
  r0.yw = r0.xz * float2(2,2) + float2(-1,-1);
  r1.yzw = cb0[48].xyw * -r0.www;
  r1.yzw = cb0[47].xyw * r0.yyy + r1.yzw;
  r1.xyz = cb0[49].xyw * r1.xxx + r1.yzw;
  r1.xyz = cb0[50].xyw + r1.xyz;
  r0.yw = r1.xy / r1.zz;
  r1.xy = r0.yw * float2(0.5,0.5) + float2(0.5,0.5);
  r1.z = 1 + -r1.y;
  o0.xy = -r1.xz + r0.xz;
  o0.zw = float2(0,0);
  return;
}