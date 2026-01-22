// =============================================================================
// LIGHT SHAFT / GOD RAY SHADER
// =============================================================================
// This shader creates volumetric light shafts (god rays) by performing radial
// sampling from a light source position toward each pixel. Uses exponential
// falloff weighting so samples closer to the light contribute more.
//
// cb2[0].zw = aspect ratio (width/height)
// cb2[2].x  = light intensity multiplier
// cb2[2].y  = light visibility flag (negative = behind camera)
// cb2[2].zw = light source screen-space position [0,1]
// cb2[33].xy = viewport scale
// =============================================================================

Texture2D<float4> t0 : register(t0);  // Occlusion/depth mask texture

SamplerState s3_s : register(s3);

cbuffer cb2 : register(b2)
{
  float4 cb2[34];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,      // Screen UV coordinates [0,1]
  out float4 o0 : SV_TARGET0) // Output: light shaft intensity in R channel
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  // =========================================================================
  // STEP 1: Calculate base intensity from light source strength
  // =========================================================================
  // cb2[2].x is light intensity - this creates a quadratic response curve
  // Formula: 2.25 * (1 - (1 - intensity*0.1)^2)
  
  r0.x = -cb2[2].x * 0.100000001 + 1;   // 1 - intensity*0.1
  r0.x = -r0.x * r0.x + 1;               // 1 - (above)^2 = quadratic falloff
  r0.x = 2.25 * r0.x;                    // Scale by 2.25 for final intensity
  
  // =========================================================================
  // STEP 2: Edge vignette - fade out when light is near screen edges
  // =========================================================================
  // Uses smoothstep to fade the effect when light source approaches screen borders
  // This prevents harsh cutoffs at screen edges
  
  r0.yz = float2(-0.5,-0.5) + cb2[2].zw;  // Distance from screen center
  r0.yz = float2(1,1) + -abs(r0.yz);       // 1 - |distance| = fade factor
  r0.yz = saturate(r0.yz + r0.yz);         // Double and clamp [0,1]
  
  // Smoothstep: 3t^2 - 2t^3 = t^2 * (3 - 2t)
  r1.xy = r0.yz * float2(-2,-2) + float2(3,3);  // (3 - 2t)
  r0.yz = r0.yz * r0.yz;                         // t^2
  r0.yz = r1.xy * r0.yz;                         // smoothstep result
  
  // Combine intensity with edge vignette (X and Y separately)
  r0.x = r0.x * r0.y;  // Apply horizontal edge fade
  r0.x = r0.x * r0.z;  // Apply vertical edge fade
  
  // =========================================================================
  // STEP 3: Early out - discard if light is behind camera
  // =========================================================================
  // cb2[2].y < 0 means the light source is behind the camera
  
  r0.y = cmp(-cb2[2].y < 0);
  if (r0.y != 0) discard;
  
  // =========================================================================
  // STEP 4: Calculate ray direction from light source to pixel
  // =========================================================================
  // Direction vector with aspect ratio correction for proper circular shafts
  
  r0.yz = -cb2[2].zw + v2.xy;   // Vector from light to pixel
  r1.y = cb2[0].z / cb2[0].w;   // Aspect ratio correction
  r1.x = 1;
  r1.xy = r1.xy * r0.yz;        // Apply aspect ratio to get proper distance
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);            // r0.w = distance from light to pixel (aspect-corrected)
  r0.yz = r0.yz / r0.ww;        // Normalized direction (without aspect correction for sampling)
  
  // =========================================================================
  // STEP 5: Calculate max ray length and setup viewport clamping
  // =========================================================================
  
  r1.x = min(0.25, r0.w);       // Clamp max ray march distance to 0.25 (quarter screen)
  
  // Standard viewport clamping setup (half-texel inset)
  t0.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r1.yz = fDest.xy;
  r2.xy = float2(1,1) / r1.yz;                   // Texel size
  r2.zw = cb2[33].xy * r1.yz;                    // Viewport in pixels
  r2.zw = trunc(r2.zw);                          // Truncate to integer
  r1.yz = r2.zw / r1.yz;                         // Max valid UV
  r1.yz = -r2.xy * float2(0.5,0.5) + r1.yz;     // Half-texel inset
  
  // =========================================================================
  // STEP 6: Radial sampling loop - accumulate light shaft contribution
  // =========================================================================
  // 20 samples along the ray from light source toward current pixel
  // Each sample is weighted by exponential falloff based on distance
  
  r1.w = 0;      // Accumulated light shaft value
  r2.x = 1;      // Loop counter (starts at 1, goes to 20)
  
  while (true) {
    r2.y = cmp(20 < (int)r2.x);
    if (r2.y != 0) break;
    
    // Calculate sample position along ray
    r2.y = (int)r2.x;
    r2.y = r2.y * r1.x;                         // Scale by max ray length
    r2.zw = float2(0.0500000007,0.200000003) * r2.yy;  // Step sizes (5% and 20%)
    
    // Sample position = light_pos + (direction * step * 0.05)
    r3.xy = r2.zz * r0.yz + cb2[2].zw;
    r3.xy = cb2[33].xy * r3.xy;                 // Apply viewport scale
    r3.xy = max(float2(0,0), r3.xy);            // Clamp to valid region
    r3.xy = min(r3.xy, r1.yz);
    
    // Sample occlusion texture (0 = occluded, 1 = visible)
    r2.z = t0.SampleLevel(s3_s, r3.xy, 0).x;
    
    // -----------------------------------------------------------------------
    // Exponential falloff weight calculation
    // -----------------------------------------------------------------------
    // Weight = exp2(-3.03 * (distance_to_pixel - sample_distance) / (sample_distance + 0.125))
    // This creates stronger contribution from samples closer to the light
    
    r3.x = -r2.y * 0.0500000007 + r0.w;   // Distance remaining to pixel
    r2.y = r2.y * 0.0500000007 + 0.125;    // Normalize factor (avoid div by zero)
    r2.y = r3.x / r2.y;                    // Ratio
    r2.y = -3.02965951 * r2.y;             // Exponential decay constant
    r2.y = exp2(r2.y);                     // Convert to weight
    r2.y = r2.z * r2.y;                    // Multiply by occlusion sample
    
    // -----------------------------------------------------------------------
    // Additional falloff based on ray progress (outer samples fade out)
    // -----------------------------------------------------------------------
    // This creates (1 - min(1, progress))^4.5 falloff
    
    r2.z = min(1, r2.w);                   // Clamp progress to [0,1]
    r2.z = 1 + -r2.z;                      // Invert: 1 at start, 0 at end
    r2.z = log2(r2.z);
    r2.z = 4.5 * r2.z;                     // Power of 4.5
    r2.z = exp2(r2.z);                     // = (1-progress)^4.5
    
    // Accumulate weighted sample
    r1.w = r2.y * r2.z + r1.w;
    r2.x = (int)r2.x + 1;
  }
  
  // =========================================================================
  // STEP 7: Final intensity calculation
  // =========================================================================
  // Combine accumulated samples with base intensity and distance-based boost
  
  r0.x = 0.0500000007 * r0.x;              // Scale down base intensity
  r0.y = r0.w * 2.79999995 + 0.300000012;  // Distance boost: 0.3 + distance * 2.8
  r0.x = r0.x * r0.y;                      // Final intensity multiplier
  
  // Output light shaft intensity (R channel only, G/B/A = 0)
  o0.x = r1.w * r0.x;
  o0.yzw = float3(0,0,0);
  return;
}