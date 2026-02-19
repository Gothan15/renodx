// ---- Created with 3Dmigoto v1.4.1 on Wed Feb 18 23:07:38 2026
Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  t0.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
  r0.xy = uiDest.xy;
  r0.xyzw = (uint4)r0.xyxy;
  r0.xyzw = float4(1,1,1,1) / r0.xyzw;
  r1.xyzw = r0.zwzw * float4(-0.5,-0.5,0.5,-0.5) + v2.xyxy;
  r0.xyzw = r0.xyzw * float4(-0.5,0.5,0.5,0.5) + v2.xyxy;
  r2.xyzw = t0.SampleLevel(s3_s, r1.zw, 0).xyzw;
  r1.xyzw = t0.SampleLevel(s3_s, r1.xy, 0).xyzw;
  r2.xyzw = float4(0.25,0.25,0.25,0.25) * r2.xyzw;
  r1.xyzw = r1.xyzw * float4(0.25,0.25,0.25,0.25) + r2.xyzw;
  r2.xyzw = t0.SampleLevel(s3_s, r0.xy, 0).xyzw;
  r0.xyzw = t0.SampleLevel(s3_s, r0.zw, 0).xyzw;
  r1.xyzw = r2.xyzw * float4(0.25,0.25,0.25,0.25) + r1.xyzw;
  o0.xyzw = r0.xyzw * float4(0.25,0.25,0.25,0.25) + r1.xyzw;
  return;
}