// ============================================================================
// BLOOM BLUR + COMPOSITE SHADER
// Performs a weighted 3x3 Gaussian blur on the bloom texture (t1)
// and composites the result onto the main scene texture (t0)
//
// Blur kernel weights (sum = 16):
//   1  2  1
//   2  4  2
//   1  2  1
// ============================================================================

Texture2D<float4> t1 : register(t1);  // Bloom texture to blur

Texture2D<float4> t0 : register(t0);  // Main scene texture

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
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  // ========================================
  // SETUP: Get bloom texture dimensions and calculate texel size
  // ========================================
  t1.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.xy = fDest.xy;                              // Bloom texture dimensions
  r0.zw = float2(1,1) / r0.xy;                   // Texel size (1/width, 1/height)
  
  // Calculate UV bounds for clamping
  r1.xy = v2.xy * cb2[33].xy + -r0.zw;           // UV offset by -1 texel (top-left)
  r1.xy = max(float2(0,0), r1.xy);
  r1.zw = cb2[33].xy * r0.xy;
  r1.zw = trunc(r1.zw);
  r0.xy = r1.zw / r0.xy;
  r0.xy = -r0.zw * float2(0.5,0.5) + r0.xy;      // Max UV clamp bounds
  r1.xy = min(r1.xy, r0.xy);
  
  // ========================================
  // SAMPLE TOP-LEFT CORNER (weight: 1)
  // ========================================
  r1.xyzw = t1.SampleLevel(s3_s, r1.xy, 0).xyzw;
  
  // ========================================
  // SAMPLE TOP-CENTER (weight: 2)
  // ========================================
  r2.xy = cb2[33].xy * v2.xy;                    // Current UV scaled
  r2.zw = r0.zw * float2(0,-1) + r2.xy;          // Offset up by 1 texel
  r2.zw = max(float2(0,0), r2.zw);
  r2.zw = min(r2.zw, r0.xy);
  r3.xyzw = t1.SampleLevel(s3_s, r2.zw, 0).xyzw;
  r1.xyzw = r3.xyzw * float4(2,2,2,2) + r1.xyzw; // Add with weight 2
  
  // ========================================
  // SAMPLE TOP-RIGHT (weight: 1) and LEFT-CENTER (weight: 2)
  // ========================================
  r3.xyzw = r0.zwzw * float4(1,-1,-1,0) + r2.xyxy;
  r3.xyzw = max(float4(0,0,0,0), r3.xyzw);
  r3.xyzw = min(r3.xyzw, r0.xyxy);
  r4.xyzw = t1.SampleLevel(s3_s, r3.xy, 0).xyzw;    // Top-right sample
  r3.xyzw = t1.SampleLevel(s3_s, r3.zw, 0).xyzw;    // Left-center sample
  r1.xyzw = r4.xyzw + r1.xyzw;                       // Add top-right (weight 1)
  r1.xyzw = r3.xyzw * float4(2,2,2,2) + r1.xyzw;    // Add left (weight 2)
  
  // ========================================
  // SAMPLE CENTER (weight: 4) - Highest weight
  // ========================================
  r2.zw = max(float2(0,0), r2.xy);
  r3.xy = min(r2.zw, r0.xy);
  r3.xyzw = t1.SampleLevel(s3_s, r3.xy, 0).xyzw;
  r1.xyzw = r3.xyzw * float4(4,4,4,4) + r1.xyzw;    // Add center (weight 4)
  
  // ========================================
  // SAMPLE RIGHT-CENTER (weight: 2), BOTTOM-LEFT (weight: 1)
  // ========================================
  r3.xyzw = r0.zwzw * float4(1,0,-1,1) + r2.xyxy;   // Right and bottom-left offsets
  r2.xy = r0.zw * float2(0,1) + r2.xy;              // Bottom-center offset
  
  // ========================================
  // SAMPLE BOTTOM-RIGHT (weight: 1)
  // ========================================
  r0.zw = v2.xy * cb2[33].xy + r0.zw;
  r0.zw = max(float2(0,0), r0.zw);
  r0.zw = min(r0.zw, r0.xy);
  r4.xyzw = t1.SampleLevel(s3_s, r0.zw, 0).xyzw;    // Bottom-right sample
  
  // ========================================
  // SAMPLE BOTTOM-CENTER (weight: 2)
  // ========================================
  r0.zw = max(float2(0,0), r2.xy);
  r0.zw = min(r0.zw, r0.xy);
  r5.xyzw = t1.SampleLevel(s3_s, r0.zw, 0).xyzw;    // Bottom-center sample
  
  // ========================================
  // SAMPLE RIGHT-CENTER and BOTTOM-LEFT, ACCUMULATE
  // ========================================
  r3.xyzw = max(float4(0,0,0,0), r3.xyzw);
  r0.xyzw = min(r3.xyzw, r0.xyxy);
  r3.xyzw = t1.SampleLevel(s3_s, r0.xy, 0).xyzw;    // Right-center sample
  r0.xyzw = t1.SampleLevel(s3_s, r0.zw, 0).xyzw;    // Bottom-left sample
  r1.xyzw = r3.xyzw * float4(2,2,2,2) + r1.xyzw;    // Add right (weight 2)
  r0.xyzw = r1.xyzw + r0.xyzw;                       // Add bottom-left (weight 1)
  r0.xyzw = r5.xyzw * float4(2,2,2,2) + r0.xyzw;    // Add bottom-center (weight 2)
  r0.xyzw = r0.xyzw + r4.xyzw;                       // Add bottom-right (weight 1)
  // ========================================
  // SAMPLE MAIN SCENE TEXTURE (t0)
  // ========================================
  t0.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r1.xy = fDest.xy;
  r1.zw = cb2[33].xy * r1.xy;
  r1.zw = trunc(r1.zw);
  r1.zw = r1.zw / r1.xy;
  r1.xy = float2(1,1) / r1.xy;
  r1.xy = -r1.xy * float2(0.5,0.5) + r1.zw;
  r1.xy = min(r2.zw, r1.xy);
  r1.xyzw = t0.SampleLevel(s3_s, r1.xy, 0).xyzw;    // Main scene color
  
  // ========================================
  // FINAL COMPOSITE: Blurred bloom + scene
  // Divide blur sum by 16 (0.0625) and add to scene
  // ========================================
  o0.xyzw = r0.xyzw * float4(0.0625,0.0625,0.0625,0.0625) + r1.xyzw;
  return;
}