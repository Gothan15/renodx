// ---- Created with 3Dmigoto v1.4.1 on Wed Jan 14 08:02:25 2026
// =============================================================================
// AUTO-EXPOSURE / EYE ADAPTATION SHADER
// =============================================================================
// Computes exposure value from a luminance histogram to simulate eye adaptation.
// Uses a 64-bin histogram to calculate weighted average luminance, then smoothly
// adapts toward the target exposure over time.
//
// Key Features:
// - Histogram-based metering (more robust than simple average)
// - Percentile-based weighting (ignores extreme outliers)
// - Asymmetric adaptation (different speeds for bright->dark vs dark->bright)
// - Min/max exposure clamping
// =============================================================================

#include "./shared.h"

Buffer<uint4> t10 : register(t10);    // Luminance histogram (64 bins, uint counts)

Texture2D<float4> t4 : register(t4);  // Previous frame exposure / luminance

SamplerState s1_s : register(s1);     // Linear sampler

cbuffer cb2 : register(b2)
{
  float4 cb2[34];  // cb2[1].w = exposure target, cb2[1].x = adaptation speed
                   // cb2[3].zw = min/max exposure, cb2[23].z = target exposure
                   // cb2[33].xy = resolution scale
}

cbuffer cb0 : register(b0)
{
  float4 cb0[108]; // cb0[107].z = exposure threshold multiplier
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)  // Output: x = new exposure value
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  // ===========================================================================
  // SECTION 1: SAMPLE PREVIOUS FRAME EXPOSURE
  // ===========================================================================
  // Get texture dimensions and calculate proper UV for center sampling
  t4.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.xy = fDest.xy;                                     // Texture dimensions
  r0.zw = float2(1,1) / r0.xy;                          // Texel size
  r1.xy = cb2[33].xy * r0.xy;                           // Scale by resolution
  r1.xy = trunc(r1.xy);                                 // Integer pixel coords
  r0.xy = r1.xy / r0.xy;                                // Normalized coords
  r1.xy = float2(0.5,0.5) * cb2[33].xy;                 // Half resolution offset
  r0.xy = -r0.zw * float2(0.5,0.5) + r0.xy;             // Offset by half texel
  r0.zw = max(float2(0,0), r1.xy);                      // Clamp min
  r0.xy = min(r0.zw, r0.xy);                            // Clamp max
  r0.x = t4.SampleLevel(s1_s, r0.xy, 0).x;              // Sample previous exposure

  // ===========================================================================
  // SECTION 2: SUM HISTOGRAM TO GET TOTAL PIXEL COUNT
  // ===========================================================================
  // Loop through all 64 histogram bins and sum the total pixel count
  r0.yz = float2(0,0);                                  // y = total count, z = loop index
  while (true) {
    r0.w = cmp((int)r0.z >= 64);                        // Loop 64 times
    if (r0.w != 0) break;
    r0.w = t10.Load(r0.z).x;                            // Load bin count
    r0.w = (uint)r0.w;                                  // Convert to uint
    r0.y = r0.y + r0.w;                                 // Accumulate total
    r0.z = (int)r0.z + 1;
  }
  
  // ===========================================================================
  // SECTION 3: CALCULATE PERCENTILE THRESHOLDS
  // ===========================================================================
  // Use 70% and 90% of total pixels as thresholds for weighted average
  // This ignores the darkest 70% and brightest 10% (outlier rejection)
  r0.yz = float2(0.699999988,0.899999976) * r0.yy;      // y = 70% threshold, z = 90% threshold
  r1.y = 1;                                             // Weight normalizer
  r1.zw = float2(0,0);                                  // z = weighted sum, w = total weight
  r0.w = r0.y;                                          // Remaining pixels to skip (low end)
  r2.x = r0.z;                                          // Remaining pixels to include (high end)
  r2.y = 0;                                             // Loop counter

  // ===========================================================================
  // SECTION 4: WEIGHTED HISTOGRAM AVERAGE (METERING)
  // ===========================================================================
  // Loop through histogram bins, weighting by luminance value
  // Only includes pixels between 70th and 90th percentile
  while (true) {
    r2.z = cmp((int)r2.y >= 64);
    if (r2.z != 0) break;
    
    r2.z = t10.Load(r2.y).x;                            // Load bin count
    r2.z = (uint)r2.z;
    
    // Skip pixels below 70th percentile (darkest)
    r2.w = min(r2.z, r0.w);                             // Pixels to skip from this bin
    r2.z = r2.z + -r2.w;                                // Remaining after skip
    r0.w = -r2.w + r0.w;                                // Update skip counter
    
    // Include pixels up to 90th percentile
    r2.w = r2.x + -r2.w;                                // Update include counter
    r2.z = min(r2.z, r2.w);                             // Pixels to include from this bin
    r2.x = r2.w + -r2.z;                                // Update remaining include counter
    
    // Calculate luminance weight for this bin
    // Maps bin index [0,63] to log-luminance via exponential curve
    r2.w = (int)r2.y;
    r2.w = r2.w * 0.015625 + -0.428571433;              // Normalize bin: [0,63] -> [-0.43, 0.57]
    r2.w = 35 * r2.w;                                   // Scale for exp2
    r1.x = exp2(r2.w);                                  // Exponential luminance value
    
    // Accumulate weighted luminance
    r1.zw = r1.xy * r2.zz + r1.zw;                      // z += lum*count, w += count
    r2.y = (int)r2.y + 1;
  }

  // ===========================================================================
  // SECTION 5: CALCULATE TARGET EXPOSURE
  // ===========================================================================
  // Convert weighted average luminance to target exposure
  r0.y = r1.z / r1.w;                                   // Weighted average luminance
  r0.y = cb2[1].w / r0.y;                               // Target exposure = reference / avg luminance
  
  // Clamp exposure change rate (max 4x or 0.25x per frame)
  r0.zw = float2(4,0.25) * cb2[23].zz;                  // Upper/lower bounds relative to target
  r0.zw = cmp(r0.zy < r0.yw);                           // Compare thresholds
  r1.xy = float2(0.25,4) * r0.yy;                       // Clamped values
  r0.y = r0.w ? r1.y : cb2[23].z;                       // Apply upper clamp
  r0.y = r0.z ? r1.x : r0.y;                            // Apply lower clamp
  
  // Apply absolute min/max exposure limits
  r0.y = max(cb2[3].z, r0.y);                           // Min exposure
  r0.y = min(cb2[3].w, r0.y);                           // Max exposure

  // ===========================================================================
  // SECTION 6: TEMPORAL ADAPTATION (EYE ADAPTATION)
  // ===========================================================================
  // Smoothly adapt from previous exposure to target exposure
  // Uses different speeds for brightening vs darkening (asymmetric)
  r0.z = cb0[107].z * r0.y;                             // Threshold for direction
  r0.z = cmp(r0.x < r0.z);                              // Is scene getting brighter?
  r0.y = r0.y * cb0[107].z + -r0.x;                     // Exposure difference
  
  // Calculate adaptation rates (exponential decay toward target)
  r1.xy = float2(-1.44269502,-4.32808495) * cb2[1].xx;  // Two different speeds
  r1.xy = exp2(r1.xy);                                  // Convert to exponential
  r1.xy = float2(1,1) + -r1.xy;                         // Complement for lerp
  
  // Apply adaptation: current + (target - current) * speed
  r0.xy = r0.yy * r1.xy + r0.xx;                        // x = slow adapt, y = fast adapt
  
  // ===========================================================================
  // SECTION 7: OUTPUT
  // ===========================================================================
  // Select adaptation rate based on brightness direction
  // Typically: faster adaptation when getting brighter, slower when getting darker
  float calculated_exposure = r0.z ? r0.x : r0.y;       // Final adapted exposure
  
  // RenoDX: Control auto-exposure intensity
  // At 100%: full auto-exposure (calculated value)
  // At 0%: locked to game's target exposure (no auto-exposure swing)
  // This uses cb2[23].z as the stable default instead of prev_exposure,
  // which avoids blown-out results when loading a new scene at 0%
  float default_exposure = cb2[23].z;
  o0.x = lerp(default_exposure, calculated_exposure, CUSTOM_AUTO_EXPOSURE);
  
  o0.yzw = float3(0,0,0);                               // Unused channels
  return;
}