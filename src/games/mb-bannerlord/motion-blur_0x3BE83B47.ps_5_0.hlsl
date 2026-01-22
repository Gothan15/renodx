// ============================================================================
// MOTION BLUR SHADER (Depth-Aware)
// Applies per-pixel motion blur based on velocity vectors
// Uses depth comparison for proper occlusion handling
// Two-pass sampling (forward/backward along motion direction)
// ============================================================================

Texture2D<float4> t14 : register(t14);  // Motion/depth auxiliary buffer (xy: depth, velocity)

Texture2D<float4> t13 : register(t13);  // Depth buffer

Texture2D<float4> t11 : register(t11);  // Motion vectors (screen-space velocity)

Texture2D<float4> t7 : register(t7);    // Per-pixel velocity buffer

Texture2D<float4> t0 : register(t0);    // Main scene color

SamplerState s3_s : register(s3);

SamplerState s1_s : register(s1);

cbuffer cb2 : register(b2)
{
  float4 cb2[34];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[84];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10;
  uint4 bitmask, uiDest;
  float4 fDest;

  // ========================================
  // SETUP: Sample main scene color (t0)
  // ========================================
  t0.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.xy = fDest.xy;
  r0.zw = float2(1,1) / r0.xy;                     // Texel size
  r1.xy = cb2[33].xy * r0.xy;
  r1.xy = trunc(r1.xy);
  r0.xy = r1.xy / r0.xy;
  r1.xy = cb2[33].xy * v2.xy;
  r0.xy = -r0.zw * float2(0.5,0.5) + r0.xy;        // Max UV clamp bounds
  r0.zw = max(float2(0,0), r1.xy);
  r1.xy = min(r0.zw, r0.xy);
  r1.xyzw = t0.SampleLevel(s3_s, r1.xy, 0).xyzw;   // Sample center pixel color
  
  // ========================================
  // RANDOM ROTATION: Jitter sample pattern to reduce banding
  // Uses interleaved gradient noise hash
  // ========================================
  r2.xy = cb2[0].xy + cb2[0].xy;
  r2.xy = float2(1,1) / r2.xy;
  r2.xy = v2.xy * r2.xy;                           // Normalized screen coords
  r2.zw = floor(r2.xy);                            // Pixel coordinates
  r3.xy = float2(3,2) + r2.zw;
  r3.x = dot(float2(0.0671105608,0.00583714992), r3.xy);  // Hash function
  r3.x = frac(r3.x);
  r3.x = 52.9829178 * r3.x;
  r3.x = frac(r3.x);
  r3.x = 6.28318548 * r3.x;                        // Random angle [0, 2π]
  sincos(r3.x, r3.x, r4.x);                        // Random rotation vector
  r4.y = r3.x;
  r3.xy = cb2[0].xy * r4.xy;
  r3.xy = r3.xy * float2(10,10) + v2.xy;           // Rotated sample offset
  
  // ========================================
  // SAMPLE MOTION VECTORS (t11)
  // ========================================
  t11.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r3.zw = fDest.xy;
  r4.xy = float2(1,1) / r3.zw;
  r4.zw = cb2[33].xy * r3.zw;
  r4.zw = trunc(r4.zw);
  r3.zw = r4.zw / r3.zw;
  r3.xy = cb2[33].xy * r3.xy;
  r3.zw = -r4.xy * float2(0.5,0.5) + r3.zw;
  r3.xy = max(float2(0,0), r3.xy);
  r3.xy = min(r3.xy, r3.zw);
  r3.xy = t11.SampleLevel(s1_s, r3.xy, 0).xy;      // Motion vector (velocity)
  r3.z = dot(r3.xy, r3.xy);
  r3.z = sqrt(r3.z);                               // Motion magnitude
  r3.z = max(9.99999997e-07, r3.z);
  
  // ========================================
  // MOTION THRESHOLD CHECK
  // Only apply blur if motion > 0.5 threshold
  // ========================================
  r3.w = cmp(0.500001013 < r3.z);
  if (r3.w != 0) {
    // ========================================
    // MOTION BLUR ENABLED - Complex path
    // ========================================
    
    // Secondary random hash for sample variation
    r2.zw = float2(-1,1) + r2.zw;
    r2.z = dot(float2(0.0671105608,0.00583714992), r2.zw);
    r2.z = frac(r2.z);
    r2.z = 52.9829178 * r2.z;
    r2.z = frac(r2.z);                             // Random value for sample jitter
    
    // ========================================
    // SAMPLE DEPTH (t13) - Linearize depth
    // ========================================
    t13.GetDimensions(0, fDest.x, fDest.y, fDest.z);
    r4.xy = fDest.xy;
    r4.zw = float2(1,1) / r4.xy;
    r5.xy = cb2[33].xy * r4.xy;
    r5.xy = trunc(r5.xy);
    r4.xy = r5.xy / r4.xy;
    r4.xy = -r4.zw * float2(0.5,0.5) + r4.xy;
    r4.xy = min(r4.xy, r0.zw);
    r2.w = t13.SampleLevel(s1_s, r4.xy, 0).x;      // Raw depth
    r2.w = cb0[83].y + r2.w;
    r2.w = cb0[83].z / r2.w;                       // Linearized depth
    
    // ========================================
    // SAMPLE VELOCITY BUFFER (t7)
    // ========================================
    t7.GetDimensions(0, fDest.x, fDest.y, fDest.z);
    r4.xy = fDest.xy;
    r4.zw = float2(1,1) / r4.xy;
    r5.xy = cb2[33].xy * r4.xy;
    r5.xy = trunc(r5.xy);
    r4.xy = r5.xy / r4.xy;
    r4.xy = -r4.zw * float2(0.5,0.5) + r4.xy;
    r0.zw = min(r4.xy, r0.zw);
    r0.zw = t7.SampleLevel(s1_s, r0.zw, 0).xy;     // Per-pixel velocity
    
    // Scale and clamp velocity
    r3.w = 1 / cb2[1].x;
    r0.zw = r3.ww * r0.zw;
    r0.zw = float2(6,6) * r0.zw;                   // Scale velocity
    r3.w = dot(r0.zw, r0.zw);
    r3.w = sqrt(r3.w);                             // Velocity magnitude
    r4.x = max(0.5, r3.w);
    r4.x = min(20, r4.x);                          // Clamp blur length [0.5, 20]
    r3.w = 9.99999997e-07 + r3.w;
    r0.zw = r0.zw / r3.ww;
    r0.zw = r0.zw * r4.xx;                         // Normalized & scaled velocity
    
    // ========================================
    // CALCULATE BLUR DIRECTIONS
    // Primary direction from motion vectors
    // ========================================
    r4.xy = r3.xy / r3.zz;                         // Normalized motion direction
    r4.zw = -r4.yy;
    r3.w = dot(r4.zx, r0.zw);
    r3.w = cmp(r3.w < 0);
    r5.xy = float2(-1,1) * r4.yx;
    r4.zw = r3.ww ? -r4.wx : r5.xy;                // Perpendicular direction
    
    // Blend between motion vector and velocity directions
    r3.w = dot(r0.zw, r0.zw);
    r3.w = sqrt(r3.w);
    r5.xy = max(float2(0.5,9.99999997e-07), r3.ww);
    r5.yz = r0.zw / r5.yy;                         // Normalized velocity
    r6.xy = float2(-0.5,9.99999997e-07) + r5.xx;
    r3.w = 0.666666687 * r6.x;
    r3.w = min(1, r3.w);                           // Blend factor
    r6.xz = r5.yz + -r4.zw;
    r4.zw = r3.ww * r6.xz + r4.zw;                 // Blended direction
    r3.w = dot(r4.zw, r4.zw);
    r3.w = sqrt(r3.w);
    r3.w = max(9.99999997e-07, r3.w);
    r4.zw = r4.zw / r3.ww;                         // Final blur direction 1
    
    // Initial weight for center sample
    r3.w = 20 * r5.x;
    r3.w = 5 / r3.w;
    r7.xyzw = r3.wwww * r1.xyzw;                   // Weighted center color
    
    // ========================================
    // SETUP FOR AUXILIARY BUFFER (t14) SAMPLING
    // ========================================
    t14.GetDimensions(0, fDest.x, fDest.y, fDest.z);
    r6.xz = fDest.xy;
    r8.xy = float2(1,1) / r6.xz;
    r8.zw = cb2[33].xy * r6.xz;
    r8.zw = trunc(r8.zw);
    r6.xz = r8.zw / r6.xz;
    r6.xz = -r8.xy * float2(0.5,0.5) + r6.xz;
    
    // Alignment factor between blur direction and motion
    r4.x = dot(r4.zw, r4.xy);
    r4.y = max(1, abs(r4.x));
    r4.y = 0.649999976 * r4.y;                     // Alignment weight
    
    // ========================================
    // FIRST BLUR PASS - Sample along motion direction
    // ========================================
    r8.xyzw = r7.xyzw;                             // Accumulator
    r5.w = r3.w;                                   // Total weight
    r6.w = 0;
    while (true) {
      r9.x = cmp((int)r6.w >= 5);
      if (r9.x != 0) break;                        // 5 samples (step by 2)
      
      // Calculate sample offset with jitter
      r9.x = (int)r6.w;
      r9.x = r2.z * 0.800000012 + r9.x;            // Add random jitter
      r9.x = 1 + r9.x;
      r9.x = r9.x * 0.333333343 + -1;              // Normalized offset [-1, 1]
      r9.y = r9.x * r3.z;                          // Scale by motion magnitude
      
      // Calculate sample UV along motion vector direction
      r9.xz = r9.xx * r3.xy + r2.xy;
      r9.xz = cb2[0].xy * r9.xz;
      r9.xz = cb2[33].xy * r9.xz;
      r9.xz = r9.xz + r9.xz;
      r9.xz = max(float2(0,0), r9.xz);
      r10.xy = min(r9.xz, r6.xz);
      
      // Sample auxiliary buffer for depth/velocity info
      r10.xy = t14.SampleLevel(s1_s, r10.xy, 0).xy;
      r9.w = 40 * r10.y;                           // Scaled velocity
      
      // ========================================
      // DEPTH-BASED OCCLUSION WEIGHTS
      // Compare sample depth vs center depth
      // ========================================
      r10.z = r10.x * 300 + -r2.w;
      r10.z = saturate(-r10.z * 10000 + 1);        // Behind center (occluded)
      r10.x = -r10.x * 300 + r2.w;
      r10.x = saturate(-r10.x * 10000 + 1);        // In front of center
      
      // Velocity-based weight falloff
      r10.y = r10.y * 40 + 9.99999997e-07;
      r10.y = abs(r9.y) / r10.y;
      r10.y = saturate(1 + -r10.y);
      
      // Distance-based weight falloff
      r10.w = abs(r9.y) / r6.y;
      r10.w = 1 + -r10.w;
      r10.w = max(0, r10.w);
      
      // Combine occlusion weights
      r10.x = r10.x * r10.w;
      r10.x = r10.x * abs(r4.x);
      r10.x = r10.z * r10.y + r10.x;
      
      // Soft edge weight (smoothstep falloff)
      r9.w = min(r9.w, r5.x);
      r10.y = 0.0999999642 * r9.w;
      r9.y = -r9.w * 0.949999988 + abs(r9.y);
      r9.w = 1 / r10.y;
      r9.y = saturate(r9.y * r9.w);
      r9.w = r9.y * -2 + 3;
      r9.y = r9.y * r9.y;
      r9.y = -r9.w * r9.y + 1;                     // Smoothstep
      r9.y = r4.y * r9.y + r10.x;                  // Final sample weight
      
      // Sample and accumulate scene color
      r9.xz = min(r9.xz, r0.xy);
      r10.xyzw = t0.SampleLevel(s3_s, r9.xz, 0).xyzw;
      r8.xyzw = r10.xyzw * r9.yyyy + r8.xyzw;      // Weighted accumulation
      r5.w = r9.y + r5.w;                          // Accumulate weights
      r6.w = (int)r6.w + 2;
    }
    
    // ========================================
    // SECOND BLUR PASS - Sample along velocity direction
    // ========================================
    r3.x = dot(r4.zw, r5.yz);                      // Alignment with velocity
    r3.y = max(1, abs(r3.x));
    r3.y = 0.649999976 * r3.y;
    r4.xyzw = r8.xyzw;                             // Continue accumulation
    r3.w = r5.w;
    r5.y = 1;
    while (true) {
      r5.z = cmp((int)r5.y >= 5);
      if (r5.z != 0) break;                        // 5 samples (step by 2)
      
      // Calculate sample offset with jitter
      r5.z = (int)r5.y;
      r5.z = r2.z * 0.800000012 + r5.z;
      r5.z = 1 + r5.z;
      r5.z = r5.z * 0.333333343 + -1;
      r6.w = r5.z * r3.z;
      
      // Calculate sample UV along velocity direction
      r7.xy = r5.zz * r0.zw + r2.xy;
      r7.xy = cb2[0].xy * r7.xy;
      r7.xy = cb2[33].xy * r7.xy;
      r7.xy = r7.xy + r7.xy;
      r7.xy = max(float2(0,0), r7.xy);
      r7.zw = min(r7.xy, r6.xz);
      
      // Sample auxiliary buffer
      r7.zw = t14.SampleLevel(s1_s, r7.zw, 0).xy;
      r5.z = 40 * r7.w;
      
      // Depth occlusion weights (same logic as first pass)
      r9.x = r7.z * 300 + -r2.w;
      r9.x = saturate(-r9.x * 10000 + 1);
      r7.z = -r7.z * 300 + r2.w;
      r7.z = saturate(-r7.z * 10000 + 1);
      r7.w = r7.w * 40 + 9.99999997e-07;
      r7.w = abs(r6.w) / r7.w;
      r7.w = saturate(1 + -r7.w);
      r9.y = abs(r6.w) / r6.y;
      r9.y = 1 + -r9.y;
      r9.y = max(0, r9.y);
      r7.z = r9.y * r7.z;
      r7.z = r7.z * abs(r3.x);
      r7.z = r9.x * r7.w + r7.z;
      
      // Soft edge weight
      r5.z = min(r5.x, r5.z);
      r7.w = 0.0999999642 * r5.z;
      r5.z = -r5.z * 0.949999988 + abs(r6.w);
      r6.w = 1 / r7.w;
      r5.z = saturate(r6.w * r5.z);
      r6.w = r5.z * -2 + 3;
      r5.z = r5.z * r5.z;
      r5.z = -r6.w * r5.z + 1;
      r5.z = r3.y * r5.z + r7.z;                   // Final sample weight
      
      // Sample and accumulate
      r7.xy = min(r7.xy, r0.xy);
      r7.xyzw = t0.SampleLevel(s3_s, r7.xy, 0).xyzw;
      r4.xyzw = r7.xyzw * r5.zzzz + r4.xyzw;
      r3.w = r5.z + r3.w;
      r5.y = (int)r5.y + 2;
    }
    
    // ========================================
    // NORMALIZE: Divide accumulated color by total weight
    // ========================================
    o0.xyzw = r4.xyzw / r3.wwww;
  } else {
    // ========================================
    // NO MOTION: Output original color unchanged
    // ========================================
    o0.xyzw = r1.xyzw;
  }
  return;
}