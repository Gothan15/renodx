

#include "../shared.h"

// =============================================================================
// TEXTURE & SAMPLER DECLARATIONS
// =============================================================================
Texture2D<float4> t8 : register(t8);  // Fog/atmosphere depth texture
Texture2D<float4> t6 : register(t6);  // Auto-exposure/luminance adaptation texture
Texture2D<float4> t1 : register(t1);  // Bloom texture
Texture2D<float4> t0 : register(t0);  // Main scene color buffer

SamplerState s3_s : register(s3);

cbuffer cb2 : register(b2)
{
  float4 cb2[34];
  // cb2[0].xy  = resolution?
  // cb2[2].x   = fog intensity multiplier
  // cb2[2].y   = fog enable flag (negative = enabled)
  // cb2[4].x   = bloom power/gamma
  // cb2[23].z  = fallback exposure value
  // cb2[33].xy = render scale factors
}

cbuffer cb0 : register(b0)
{
  float4 cb0[102];
  // cb0[52].xyz = fog/atmosphere color
  // cb0[101].x  = auto-exposure toggle (0 = use fallback)
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

  // ===========================================================================
  // SECTION 1: AUTO-EXPOSURE / LUMINANCE ADAPTATION
  // ===========================================================================
  r0.x = t6.Sample(s3_s, float2(0.5,0.5)).x;
  
  // ===========================================================================
  // SECTION 2: MAIN SCENE COLOR SAMPLING WITH RESOLUTION SCALING
  // ===========================================================================
  // Get main color buffer dimensions
  t0.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.yz = fDest.xy;
  r1.xy = float2(1,1) / r0.yz;  // Texel size
  
  // Apply render scale to get actual rendered resolution
  r1.zw = cb2[33].xy * r0.yz;
  r1.zw = trunc(r1.zw);
  r0.yz = r1.zw / r0.yz;
  
  // Calculate scaled UV coordinates
  r1.zw = cb2[33].xy * v2.xy;
  
  // Adjust for half-texel offset and clamp to valid range
  r0.yz = -r1.xy * float2(0.5,0.5) + r0.yz;
  r1.xy = max(float2(0,0), r1.zw);
  r0.yz = min(r1.xy, r0.yz);
  
  // Sample main scene color
  r2.xyzw = t0.SampleLevel(s3_s, r0.yz, 0).xyzw;
  
  // ===========================================================================
  // SECTION 3: EXPOSURE APPLICATION
  // ===========================================================================
  // Calculate exposure multiplier (inverse of adaptation luminance)
  r0.y = 1 / r0.x;  // 1 / adapted_luminance = exposure multiplier
  
  // Check if auto-exposure is disabled
  r0.z = cmp(cb0[101].x == 0.000000);
  
  // Fallback exposure value when auto-exposure is off
  r0.w = 1 / cb2[23].z;
  
  // Select between auto-exposure and fallback
  r0.y = r0.z ? r0.w : r0.y;
  
  // Reduce auto-exposure strength for highlights to preserve bright detail
  // This prevents auto-exposure from crushing highlights when adapting to dark scenes
  if (CUSTOM_AUTO_EXPOSURE > 0) {
    float y = dot(r2.xyz * r0.y, float3(0.2126, 0.7152, 0.0722));  // BT.709 luminance after exposure
    float t = saturate(y - 0.18);           // ramp starts at mid-gray (0.18)
    float strength = lerp(1.0, 0.95, t * t * t);  // reduce from 100% to 95% for highlights
    r0.y = lerp(1.0, r0.y, strength);       // blend toward neutral exposure
  }
  
  // Apply exposure to scene color
  r2.xyz = r2.xyz * r0.yyy;
  
  // ===========================================================================
  // SECTION 4: ATMOSPHERIC FOG / SCATTERING (CONDITIONAL)
  // ===========================================================================
  // Check if fog is enabled (negative value = enabled)
  r0.z = cmp(cb2[2].y < 0);
  if (r0.z != 0) {
    // Get fog depth texture dimensions
    t8.GetDimensions(0, fDest.x, fDest.y, fDest.z);
    r0.zw = fDest.xy;
    r1.zw = float2(1,1) / r0.zw;
    
    // Same resolution scaling as main buffer
    r3.xy = cb2[33].xy * r0.zw;
    r3.xy = trunc(r3.xy);
    r0.zw = r3.xy / r0.zw;
    r0.zw = -r1.zw * float2(0.5,0.5) + r0.zw;
    r0.zw = min(r1.xy, r0.zw);
    
    // Sample fog depth/density
    r0.z = t8.SampleLevel(s3_s, r0.zw, 0).x;
    
    // Calculate fog intensity curve (exponential ramp-up)
    // fog^2 -> fog^4 -> fog^8, then scale by 1.25 and add 1
    r0.w = r0.z * r0.z;
    r0.w = r0.w * r0.w;
    r0.w = r0.w * r0.w;
    r0.w = r0.w * 1.25 + 1;  // Intensity multiplier: 1.0 to 2.25
    
    // Apply fog color with intensity
    r3.xyz = cb0[52].xyz * r0.www;  // Fog color * intensity
    
    // Calculate scene fade-out based on fog depth (linear falloff)
    r0.w = saturate(-r0.z * 0.75 + 1);  // 1.0 at no fog, 0.25 at full fog
    
    // Combine fog color with depth
    r3.xyz = r3.xyz * r0.zzz;
    
    // Apply fog intensity multiplier from settings
    r3.xyz = cb2[2].xxx * r3.xyz;
    
    // Blend: scene * fade + fog contribution
    r2.xyz = r2.xyz * r0.www + r3.xyz;
  }
  
  // ===========================================================================
  // SECTION 5: BLOOM SAMPLING AND APPLICATION
  // ===========================================================================
  // Get bloom texture dimensions
  t1.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.zw = fDest.xy;
  r1.zw = float2(1,1) / r0.zw;
  
  // Same resolution scaling
  r3.xy = cb2[33].xy * r0.zw;
  r3.xy = trunc(r3.xy);
  r0.zw = r3.xy / r0.zw;
  r0.zw = -r1.zw * float2(0.5,0.5) + r0.zw;
  r0.zw = min(r1.xy, r0.zw);
  
  // Sample bloom
  r1.xyz = t1.SampleLevel(s3_s, r0.zw, 0).xyz;
  
  // Apply exposure to bloom
  r0.yzw = r1.xyz * r0.yyy;
  
  // Apply bloom power/gamma curve (cb2[4].x controls bloom intensity curve)
  r0.yzw = log2(abs(r0.yzw));
  r0.yzw = cb2[4].xxx * r0.yzw;
  r0.yzw = exp2(r0.yzw);

  // Apply user bloom strength
  r0.yzw *= CUSTOM_BLOOM_STRENGTH;
  
  // Add bloom to scene
  r0.yzw = r2.xyz + r0.yzw;
  r0.yzw = max(float3(9.99999997e-07,9.99999997e-07,9.99999997e-07), r0.yzw);
  
  // ===========================================================================
  // SECTION 6: TONEMAPPING (Modified Hable curve)
  // ===========================================================================
  r0.xyz = r0.yzw * r0.xxx;
  
  if (RENODX_TONE_MAP_TYPE == 0) {
    r1.xyz = r0.xyz * float3(0.150000006,0.150000006,0.150000006) + float3(0.0500000007,0.0500000007,0.0500000007);
    r1.xyz = r0.xyz * r1.xyz + float3(0.00400000019,0.00400000019,0.00400000019);
    r2.xyz = r0.xyz * float3(0.150000006,0.150000006,0.150000006) + float3(0.5,0.5,0.5);
    r0.xyz = r0.xyz * r2.xyz + float3(0.0600000024,0.0600000024,0.0600000024);
    r0.xyz = r1.xyz / r0.xyz;
    r0.xyz = float3(-0.0666666627,-0.0666666627,-0.0666666627) + r0.xyz;
    o0.xyz = float3(4.53191471,4.53191471,4.53191471) * r0.xyz;
  } else {
    o0.xyz = r0.xyz;
  }
  
  // Pass through alpha
  o0.w = r2.w;
  return;
}