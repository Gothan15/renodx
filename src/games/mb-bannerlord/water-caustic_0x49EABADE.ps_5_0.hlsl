// =============================================================================
// WATER CAUSTICS PROJECTION SHADER
// =============================================================================

struct t78_t {
  float val[76];
};
StructuredBuffer<t78_t> t78 : register(t78);

Texture2D<float4> t0 : register(t0);  // Caustic noise/pattern texture

SamplerState s2_s : register(s2);     // Linear wrap sampler

cbuffer cb6 : register(b6)            // Material instance index
{
  float4 cb6[1];
}

cbuffer cb0 : register(b0)            // Scene constants (camera pos, time, etc.)
{
  float4 cb0[76];
}




// 3Dmigoto declarations
#define cmp -

// =============================================================================
// INPUTS:
//   v0 - Screen position (SV_POSITION)
//   v1 - Vertex color (tint for caustics)
//   v2 - UV coordinates
//   v3 - World position
//   v4 - World normal
// OUTPUT:
//   o0 - Caustic color (RGB) + blend alpha (A)
// =============================================================================

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  float4 v3 : TEXCOORD1,
  float3 v4 : NORMAL0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  // =========================================================================
  // SECTION 1: PROJECTION VOLUME CHECK
  // =========================================================================
  // Calculate vector from surface point to projector origin (camera/light)
  r0.xyz = cb0[0].xyz + -v3.xyz;
  r0.w = 4 * r0.z;                    // Scale Z for elliptical projection
  r0.z = dot(r0.xyw, r0.xyw);         // Squared distance to projector
  
  // Check if surface is facing the projector (backface culling)
  r0.x = dot(v4.xyz, r0.xyw);
  r0.x = cmp(0 < r0.x);               // True if facing projector
  
  // Get projection radius from material data
  r0.y = t78[cb6[0].z].val[32/4];     // Caustic projection radius
  r0.w = r0.y * r0.y;                 // Squared radius
  r0.w = cmp(r0.z < r0.w);            // True if within projection radius
  
  // Combine checks: must be facing AND within radius
  r0.w = (int)r0.w | (int)r0.x;
  
  if (r0.w != 0) {
    // =========================================================================
    // SECTION 2: ANIMATED UV CALCULATION
    // =========================================================================
    r0.z = sqrt(r0.z);                // Actual distance to projector
    
    // Time-based animation parameters
    // cb0[75].x = game time
    r1.xyz = float3(0.0149999997,100,150) * cb0[75].xxx;
    
    // First UV layer - sin/cos circular motion
    r0.w = sin(-r1.x);                // Slow rotation
    r2.y = v2.y + r0.w;
    r0.w = cos(r1.x);
    r2.x = v2.x + r0.w;
    r1.xw = float2(16,16) * r2.xy;    // 16x tiling scale
    
    // Sample first caustic layer
    r2.xyz = t0.Sample(s2_s, r1.xw).xyz;
    
    // =========================================================================
    // SECTION 3: SECOND UV LAYER (DIFFERENT SCROLL)
    // =========================================================================
    // Complex time-based UV offset for second layer
    r1.xyzw = cmp(r1.yyzz >= -r1.yyzz);
    r1.xyzw = r1.xyzw ? float4(100,0.00999999978,150,0.00666666683) : float4(-100,-0.00999999978,-150,-0.00666666683);
    r1.yw = cb0[75].xx * r1.yw;
    r1.yw = frac(r1.yw);              // Wrap to [0,1]
    r1.xy = r1.xz * r1.yw;
    
    // Second UV with different scroll direction and speed
    r3.x = -r1.x * 0.00999999978 + v2.x;
    r3.y = r1.y * 0.00666666683 + v2.y;
    r1.xy = float2(20,20) * r3.xy;    // 20x tiling (different from first layer)
    
    // Sample second caustic layer
    r1.xyz = t0.Sample(s2_s, r1.xy).xyz;
    
    // =========================================================================
    // SECTION 4: COMBINE CAUSTIC LAYERS
    // =========================================================================
    // Multiply both samples with vertex color tint
    // The swizzling (yxz) creates variation in the pattern
    r2.xyz = v1.yxz * r2.yxz;         // First layer * vertex color
    r1.xyz = r2.xyz * r1.yxz;         // Multiply with second layer
    
    // =========================================================================
    // SECTION 5: DISTANCE FALLOFF (EDGE FADE)
    // =========================================================================
    r0.z = r0.y + -r0.z;              // Distance from projection edge
    r0.y = r0.z / r0.y;               // Normalize to [0,1]
    r0.y = saturate(1.25 * r0.y);     // Bias toward center
    
    // Smoothstep for soft edge falloff
    r0.z = r0.y * -2 + 3;
    r0.y = r0.y * r0.y;
    r0.y = r0.z * r0.y;               // Smooth edge fade
    
    r0.x = r0.x ? 1 : r0.y;           // Full intensity if facing, else faded
    
    // =========================================================================
    // SECTION 6: HEIGHT-BASED FADE (WATER SURFACE PROXIMITY)
    // =========================================================================
    // Caustics fade out as you move away from water surface
    r0.y = t78[cb6[0].z].val[36/4];   // Water surface height (Z)
    r0.y = -v3.z + r0.y;              // Distance from water plane
    r0.y = 200 + -abs(r0.y);          // 200 unit fade range above/below
    r0.y = saturate(0.00624999963 * r0.y);  // Normalize (1/160)
    
    // Smoothstep for height fade
    r0.z = r0.y * -2 + 3;
    r0.y = r0.y * r0.y;
    r0.y = r0.z * r0.y;
    
    // Combine distance and height fades
    r0.x = r0.y * r0.x;
    
    // =========================================================================
    // SECTION 7: FINAL OUTPUT
    // =========================================================================
    // Calculate alpha for additive blending
    r0.y = 0.899999976 * r0.x;        // Alpha = 90% of fade factor
    r0.x = -r0.x * 0.899999976 + 1;   // Inverse for color blend
    
    // Final caustic color (2x intensity boost)
    o0.xyz = saturate(r1.xyz * float3(2,2,2) + r0.xxx);
    o0.w = r0.y;                      // Blend alpha
    
  } else {
    // =========================================================================
    // OUTSIDE PROJECTION - DISCARD PIXEL
    // =========================================================================
    if (-1 != 0) discard;             // Always discards (unconditional)
    o0.xyzw = float4(0,0,0,0);
  }
  return;
}