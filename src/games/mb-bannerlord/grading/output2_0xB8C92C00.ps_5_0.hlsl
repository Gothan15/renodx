
#include "../common.hlsl"

Texture2D<float4> t10 : register(t10);

Texture2D<float4> t9 : register(t9);

Texture2D<float4> t8 : register(t8);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[34];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[107];
}



// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Sample scene color from t0
  t0.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.xy = fDest.xy;
  r0.zw = float2(1,1) / r0.xy;
  r1.xy = cb2[33].xy * r0.xy;
  r1.xy = trunc(r1.xy);
  r0.xy = r1.xy / r0.xy;
  r1.xy = cb2[33].xy * v2.xy;
  r0.xy = -r0.zw * float2(0.5,0.5) + r0.xy;
  r0.zw = max(float2(0,0), r1.xy);
  r0.xy = min(r0.zw, r0.xy);
  r1.xyz = t0.SampleLevel(s3_s, r0.xy, 0).xyz;
  
  // Sample alpha from t1
  t1.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.xy = fDest.xy;
  r2.xy = float2(1,1) / r0.xy;
  r2.zw = cb2[33].xy * r0.xy;
  r2.zw = trunc(r2.zw);
  r0.xy = r2.zw / r0.xy;
  r0.xy = -r2.xy * float2(0.5,0.5) + r0.xy;
  r0.xy = min(r0.zw, r0.xy);
  r0.w = t1.SampleLevel(s3_s, r0.xy, 0).w;
  

  float3 untonemapped = r1.xyz;
  

  if (RENODX_TONE_MAP_TYPE == 0) {
    r1.xyz = saturate(r1.xyz);
  }
  
  r0.x = cmp(cb0[66].x != 1.000000);
  if (r0.x != 0) {
    // LUT processing path
    float lut_blend = cb2[8].w;
    
    if (RENODX_TONE_MAP_TYPE == 0) {
      // === VANILLA SDR Path ===
      // sRGB encoding: linear to sRGB gamma curve
      float3 sdr_color = r1.xyz;
      float3 is_small = cmp(sdr_color.zxy < float3(0.00313080009,0.00313080009,0.00313080009));
      r2.xyz = float3(12.9200001,12.9200001,12.9200001) * sdr_color.zxy;
      r3.xyz = log2(sdr_color.zxy);
      r3.xyz = float3(0.416666657,0.416666657,0.416666657) * r3.xyz;
      r3.xyz = exp2(r3.xyz);
      r3.xyz = r3.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
      r0.xyz = saturate(is_small ? r2.xyz : r3.xyz);
      r0.xyz = float3(255,255,255) * r0.xyz;
      r0.xyz = trunc(r0.xyz);
      r0.x = 0.0588235296 * r0.x;
      r1.w = floor(r0.x);
      r0.yz = r0.yz * float2(0.0588235334,0.0588235334) + float2(0.5,0.5);
      r2.yz = float2(0.00390625,0.0625) * r0.yz;
      r2.x = r1.w * 0.0625 + r2.y;
      r1.xyz = t9.SampleLevel(s3_s, r2.xz, 0).xyz;
      r2.y = cmp(0 < cb2[8].w);
      if (r2.y != 0) {
        r3.xyz = t10.SampleLevel(s3_s, r2.xz, 0).xyz;
        r3.xyz = r3.xyz + -r1.xyz;
        r1.xyz = cb2[8].www * r3.xyz + r1.xyz;
      }
      r2.w = 0.0625 + r2.x;
      r3.xyz = t9.SampleLevel(s3_s, r2.wz, 0).xyz;
      if (r2.y != 0) {
        r2.xy = float2(0.0625,0) + r2.xz;
        r2.xyz = t10.SampleLevel(s3_s, r2.xy, 0).xyz;
        r2.xyz = r2.xyz + -r3.xyz;
        r3.xyz = cb2[8].www * r2.xyz + r3.xyz;
      }
      r0.x = frac(r0.x);
      r2.xyz = r3.xyz + -r1.xyz;
      r1.xyz = r0.xxx * r2.xyz + r1.xyz;
      r1.w = cb0[106].y + -cb0[106].x;
      r1.xyz = r1.xyz * r1.www + cb0[106].xxx;
      
      // Dithering (SDR path only)
      r0.x = cmp(0 != cb0[106].w);
      if (r0.x != 0) {
        r0.xy = float2(13,311) * cb2[26].yy;
        r0.xy = (int2)r0.xy;
        r0.xy = (int2)r0.xy & int2(1023,1023);
        r0.xy = (int2)r0.xy;
        r0.xy = float2(0.0009765625,0.0009765625) * r0.xy;
        r0.zw = cb2[0].xy + cb2[0].xy;
        r0.zw = float2(1,1) / r0.zw;
        r0.zw = v2.xy * r0.zw;
        r0.xy = r0.zw * float2(0.0009765625,0.0009765625) + r0.xy;
        r0.xy = t8.Sample(s0_s, r0.xy).xy;
        r0.x = 1 + -r0.x;
        r0.x = r0.x + -r0.y;
        r1.xyz = r0.xxx * float3(0.00390625,0.00390625,0.00390625) + r1.xyz;
      }
    } else {
      // === HDR Path ===
      LUTSampleResult lut_sample = LUTSAMPLE(s3_s, t9, t10, lut_blend, untonemapped);
      float3 final_color = HDRGRADE(lut_sample);

      if (CUSTOM_GRAIN_STRENGTH > 0) {
        final_color = renodx::effects::ApplyFilmGrain(
            final_color,
            v2.xy,
            CUSTOM_RANDOM,
            CUSTOM_GRAIN_STRENGTH * 0.03f);
      }

      r1.xyz = renodx::draw::RenderIntermediatePass(final_color);
    }
  }
  
  r1.w = r0.w;  // Restore alpha
  o0.xyzw = r1.xyzw;
  return;
}