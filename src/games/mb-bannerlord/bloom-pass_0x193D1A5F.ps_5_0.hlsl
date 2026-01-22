// =============================================================================
// BLOOM BRIGHT PASS WITH EDGE VIGNETTE
// =============================================================================
// This shader extracts bright pixels for bloom processing. It:
// 1. Samples the scene color with viewport clamping
// 2. Calculates brightness (max RGB component)
// 3. Applies a threshold to isolate bright areas
// 4. Fades out contribution toward screen edges (vignette)
// 5. Scales the result for bloom accumulation
//
// cb2[3].x  = brightness threshold
// cb2[4].y  = bloom intensity multiplier
// cb2[33].xy = viewport scale
// =============================================================================

Texture2D<float4> t0 : register(t0);  // Scene color texture

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
  out float4 o0 : SV_TARGET0) // Output: thresholded bloom color (RGB), max brightness (A)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  // =========================================================================
  // STEP 1: Standard viewport-clamped texture sampling
  // =========================================================================
  // Same pattern as other shaders - clamp UVs to valid viewport region
  
  t0.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.xy = fDest.xy;
  r0.zw = cb2[33].xy * r0.xy;        // Viewport in pixels
  r0.zw = trunc(r0.zw);              // Truncate to integer
  r0.zw = r0.zw / r0.xy;             // Max valid UV
  r0.xy = float2(1,1) / r0.xy;       // Texel size
  r0.xy = -r0.xy * float2(0.5,0.5) + r0.zw;  // Half-texel inset
  r0.zw = cb2[33].xy * v2.xy;        // Scale input UV
  r0.zw = max(float2(0,0), r0.zw);   // Clamp min
  r0.xy = min(r0.zw, r0.xy);         // Clamp max
  
  // Sample scene color
  r0.xyz = t0.SampleLevel(s3_s, r0.xy, 0).xyz;
  
  // =========================================================================
  // STEP 2: Calculate brightness (max RGB component)
  // =========================================================================
  
  r0.w = max(r0.x, r0.y);
  r0.w = max(r0.w, r0.z);            // r0.w = max(R, G, B) = brightness
  
  // =========================================================================
  // STEP 3: Threshold calculation
  // =========================================================================
  // How much the brightness exceeds the threshold
  
  r1.x = -cb2[3].x + r0.w;           // brightness - threshold = excess
  o0.w = r0.w;                        // Output alpha = raw brightness (for later passes)
  
  // =========================================================================
  // STEP 4: Edge vignette - fade out toward screen borders
  // =========================================================================
  // This prevents bloom from wrapping around screen edges
  // Distance from center: max(|u-0.5|, |v-0.5|)
  
  r1.yz = float2(-0.5,-0.5) + v2.xy; // Offset from center
  r0.w = max(abs(r1.y), abs(r1.z));  // Chebyshev distance to center (box distance)
  r0.w = 0.5 + -r0.w;                // Invert: 0.5 at center, 0 at edges
  
  // Combine edge falloff with brightness excess
  r0.w = r0.w * r1.x;                // vignette * (brightness - threshold)
  
  // =========================================================================
  // STEP 5: Soft threshold with normalization
  // =========================================================================
  // Divide by half the threshold for smooth transition
  
  r1.x = 0.5 * cb2[3].x;             // Half threshold
  r0.w = saturate(r0.w / r1.x);      // Normalize and clamp [0,1]
  
  // =========================================================================
  // STEP 6: Apply intensity and final scaling
  // =========================================================================
  
  r0.xyz = r0.xyz * r0.www;          // Multiply color by threshold mask
  r0.xyz = cb2[4].yyy * r0.xyz;      // Apply bloom intensity multiplier
  o0.xyz = float3(0.100000001,0.100000001,0.100000001) * r0.xyz;  // Final scale (0.1)
  
  return;
}