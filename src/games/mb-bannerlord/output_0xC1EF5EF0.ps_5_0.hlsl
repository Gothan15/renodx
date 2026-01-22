
#include "./shared.h"

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

// Custom LUT sampling 
float3 SampleGameLUT(float3 color, Texture2D<float4> lut1, Texture2D<float4> lut2, float lut_blend) {
  
  float3 srgb_color = renodx::color::srgb::EncodeSafe(color);
  srgb_color = saturate(srgb_color);
  
  
  float3 quantized = trunc(srgb_color * 255.0);
  
  
  float blue_index = quantized.z * 0.0588235296;  // / 17
  float blue_floor = floor(blue_index);
  float blue_frac = frac(blue_index);
  
  float2 rg_coord = quantized.xy * 0.0588235334 + 0.5;  // / 17 + 0.5
  float2 uv_offset = float2(0.00390625, 0.0625) * rg_coord;  // texel scaling
  
  float2 uv0 = float2(blue_floor * 0.0625 + uv_offset.x, uv_offset.y);
  float2 uv1 = float2(uv0.x + 0.0625, uv_offset.y);
  
  
  float3 lut1_sample0 = lut1.SampleLevel(s3_s, uv0, 0).xyz;
  float3 lut1_sample1 = lut1.SampleLevel(s3_s, uv1, 0).xyz;
  

  if (lut_blend > 0) {
    float3 lut2_sample0 = lut2.SampleLevel(s3_s, uv0, 0).xyz;
    float3 lut2_sample1 = lut2.SampleLevel(s3_s, uv1, 0).xyz;
    lut1_sample0 = lerp(lut1_sample0, lut2_sample0, lut_blend);
    lut1_sample1 = lerp(lut1_sample1, lut2_sample1, lut_blend);
  }
  
 
  float3 lut_result = lerp(lut1_sample0, lut1_sample1, blue_frac);
  
  return lut_result;
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
  t1.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.xy = fDest.xy;
  r2.xy = float2(1,1) / r0.xy;
  r2.zw = cb2[33].xy * r0.xy;
  r2.zw = trunc(r2.zw);
  r0.xy = r2.zw / r0.xy;
  r0.xy = -r2.xy * float2(0.5,0.5) + r0.xy;
  r0.xy = min(r0.zw, r0.xy);
  r0.w = t1.SampleLevel(s3_s, r0.xy, 0).w;
  r1.w = v2.x * v2.y;
  r1.w = cb0[75].x * r1.w;
  r2.xy = float2(76.9230804,8.13008118) * r1.ww;
  r2.zw = cmp(r2.xy >= -r2.xy);
  r2.xy = frac(abs(r2.xy));
  r2.xy = r2.zw ? r2.xy : -r2.xy;
  r1.w = 13 * r2.x;
  r1.w = r2.y * r1.w;
  r1.w = 3075 * r1.w;
  r2.x = cmp(r1.w >= -r1.w);
  r1.w = frac(abs(r1.w));
  r1.w = r2.x ? r1.w : -r1.w;
  r1.w = -r1.w * 0.199999988 + 1;
  
  if (RENODX_TONE_MAP_TYPE != 0) {
    r1.w = 1.0f;  // No vanilla grain effect
  }
  
  r2.x = dot(r1.xyz, float3(0.270000011,0.670000017,0.0599999987));
  r2.x = saturate(r2.x * 0.899999976 + 0.100000001);
  r2.x = saturate(cb2[4].z * r2.x);
  r2.yzw = r1.xyz * r1.www + -r1.xyz;
  
 
  float3 untonemapped = r2.xxx * r2.yzw + r1.xyz;
  
  
  if (RENODX_TONE_MAP_TYPE == 0) {
    r0.xyz = saturate(untonemapped);
  } else {
    r0.xyz = untonemapped;
  }
  
  r1.x = cmp(cb0[66].x != 1.000000);
  if (r1.x != 0) {
    // LUT processing path
    float lut_blend = cb2[8].w; 
    
    if (RENODX_TONE_MAP_TYPE == 0) {
      // === VANILLA SDR Path ===
      r1.xyz = cmp(r0.zxy < float3(0.00313080009,0.00313080009,0.00313080009));
      r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.zxy;
      r3.xyz = log2(r0.zxy);
      r3.xyz = float3(0.416666657,0.416666657,0.416666657) * r3.xyz;
      r3.xyz = exp2(r3.xyz);
      r3.xyz = r3.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
      r1.xyz = saturate(r1.xyz ? r2.xyz : r3.xyz);
      r1.xyz = float3(255,255,255) * r1.xyz;
      r1.xyz = trunc(r1.xyz);
      r1.x = 0.0588235296 * r1.x;
      r1.w = floor(r1.x);
      r1.yz = r1.yz * float2(0.0588235334,0.0588235334) + float2(0.5,0.5);
      r2.yz = float2(0.00390625,0.0625) * r1.yz;
      r2.x = r1.w * 0.0625 + r2.y;
      r1.yzw = t9.SampleLevel(s3_s, r2.xz, 0).xyz;
      r2.y = cmp(0 < cb2[8].w);
      if (r2.y != 0) {
        r3.xyz = t10.SampleLevel(s3_s, r2.xz, 0).xyz;
        r3.xyz = r3.xyz + -r1.yzw;
        r1.yzw = cb2[8].www * r3.xyz + r1.yzw;
      }
      r2.w = 0.0625 + r2.x;
      r3.xyz = t9.SampleLevel(s3_s, r2.wz, 0).xyz;
      if (r2.y != 0) {
        r2.xy = float2(0.0625,0) + r2.xz;
        r2.xyz = t10.SampleLevel(s3_s, r2.xy, 0).xyz;
        r2.xyz = r2.xyz + -r3.xyz;
        r3.xyz = cb2[8].www * r2.xyz + r3.xyz;
      }
      r1.x = frac(r1.x);
      r2.xyz = r3.xyz + -r1.yzw;
      r1.xyz = r1.xxx * r2.xyz + r1.yzw;
      r1.w = cb0[106].y + -cb0[106].x;
      r0.xyz = r1.xyz * r1.www + cb0[106].xxx;
    } else {
      // === HDR Path ===
      
      float3 neutral_sdr = renodx::tonemap::renodrt::NeutralSDR(untonemapped);
      
     
      float3 lut_input = saturate(neutral_sdr);
      float3 graded_sdr = SampleGameLUT(lut_input, t9, t10, lut_blend);
      
      
      graded_sdr = renodx::color::srgb::DecodeSafe(graded_sdr);
      
      
      float3 upgraded = renodx::tonemap::UpgradeToneMap(
        untonemapped,
        neutral_sdr,
        graded_sdr,
        RENODX_COLOR_GRADE_STRENGTH
      );
      
    
      float3 tonemapped = renodx::draw::ToneMapPass(upgraded);
      
      float3 final_color = tonemapped;
      if (CUSTOM_GRAIN_STRENGTH > 0) {
        final_color = renodx::effects::ApplyFilmGrain(
            tonemapped,
            v2.xy,
            CUSTOM_RANDOM,
            CUSTOM_GRAIN_STRENGTH * 0.03f);
      }
  
      r0.xyz = renodx::draw::RenderIntermediatePass(final_color);
      
    }
    
    // Dithering (SDR path only)
    if (RENODX_TONE_MAP_TYPE == 0) {
      r1.x = cmp(0 != cb0[106].w);
      if (r1.x != 0) {
        r1.xy = float2(13,311) * cb2[26].yy;
        r1.xy = (int2)r1.xy;
        r1.xy = (int2)r1.xy & int2(1023,1023);
        r1.xy = (int2)r1.xy;
        r1.xy = float2(0.0009765625,0.0009765625) * r1.xy;
        r1.zw = cb2[0].xy + cb2[0].xy;
        r1.zw = float2(1,1) / r1.zw;
        r1.zw = v2.xy * r1.zw;
        r1.xy = r1.zw * float2(0.0009765625,0.0009765625) + r1.xy;
        r1.xy = t8.Sample(s0_s, r1.xy).xy;
        r1.x = 1 + -r1.x;
        r1.x = r1.x + -r1.y;
        r0.xyz = r1.xxx * float3(0.00390625,0.00390625,0.00390625) + r0.xyz;
      }
    }
  }
  o0.xyzw = r0.xyzw;
  return;
}