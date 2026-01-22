// ============================================================================
// VOLUMETRIC SPOTLIGHT / LIGHT SHAFT PIXEL SHADER
// ============================================================================
// This shader renders volumetric light cones (god rays / light shafts) for
// spotlights.
// ============================================================================

#include "./shared.h"

// Per-light properties buffer (stride = 304 bytes = 76 floats)
// val[12] = Light rotation angle (degrees)
// val[13] = Dither intensity
// val[14] = Cookie texture U scale
// val[15] = Cookie texture V scale (also used for fog blend check)
struct t78_t {
  float val[76];
};
StructuredBuffer<t78_t> t78 : register(t78);

TextureCube<float4> t37 : register(t37);  // Environment/sky cubemap
Texture2D<float4> t28 : register(t28);    // Auto-exposure / adaptation texture
Texture2D<float4> t8 : register(t8);      // Dither/noise texture
Texture2D<float4> t4 : register(t4);      // Light cookie/projection texture
Texture2D<float4> t0 : register(t0);      // Spotlight falloff/gradient texture

SamplerState s3_s : register(s3);  // Sampler for falloff texture
SamplerState s2_s : register(s2);  // Sampler for cookie and cubemap
SamplerState s1_s : register(s1);  // Sampler for exposure texture
SamplerState s0_s : register(s0);  // Sampler for dither texture

cbuffer cb6 : register(b6) { float4 cb6[1]; }    // cb6[0].z = Light index into t78
cbuffer cb0 : register(b0) { float4 cb0[108]; }  // Global scene constants

#define cmp -

void main(
  float4 v0 : SV_POSITION0,   // Screen position
  float4 v1 : COLOR0,         // Vertex color (unused)
  float4 v2 : TEXCOORD0,      // UV coordinates (unused)
  float4 v3 : TEXCOORD1,      // World position (for view direction)
  float4 v4 : TEXCOORD2,      // World position (for light calculations)
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  // ========================================================================
  // BUFFER INDEX SETUP
  // ========================================================================
  // CRITICAL: Use asuint() to reinterpret raw bits as uint.
  // The constant buffer stores an integer index, but HLSL reads it as float.
  // Using (uint) cast would convert the float VALUE (giving wrong results),
  // while asuint() preserves the raw bit pattern.
  uint bufIdx = asuint(cb6[0].z);

  // ========================================================================
  // VIEW DIRECTION CALCULATION
  // ========================================================================
  // Calculate normalized direction from pixel world position to camera
  // cb0[0].xyz = Camera position
  // v3.xyz = Pixel world position
  r0.xyz = cb0[0].yxz + -v3.yxz;           // Vector from pixel to camera (swizzled)
  r0.w = dot(r0.xyz, r0.xyz);
  r0.w = sqrt(r0.w);                        // Distance to camera
  r1.xyz = r0.xyz / r0.www;                 // Normalized view direction
  
  // Calculate direction and distance from pixel to camera (different swizzle)
  r2.xyz = cb0[0].xyz + -v4.xyz;
  r0.x = dot(r2.xyz, r2.xyz);               // Squared distance
  r0.y = rsqrt(r0.x);
  r3.xyz = r2.xzy * r0.yyy;                 // Normalized direction (xzy swizzle for later use)
  
  // ========================================================================
  // LIGHT DIRECTION ROTATION
  // ========================================================================
  // Rotate the 2D light direction by the spotlight's rotation angle
  // This allows spotlights to have rotated cookie/gobo patterns
  r0.y = t78[bufIdx].val[12];               // Light rotation angle (degrees)
  r0.y = 0.0174532924 * r0.y;               // Convert degrees to radians
  sincos(r0.y, r4.x, r5.x);                 // r4.x = sin(angle), r5.x = cos(angle)
  
  // 2D rotation matrix application:
  // [cos -sin] [x]   [cos*x - sin*y]
  // [sin  cos] [y] = [sin*x + cos*y]
  // But with negations for light-space transformation
  r4.xy = r4.xx * -r1.xy;                   // r4.xy = -sin * r1.xy
  r0.y = r5.x * -r1.y + -r4.x;              // rotated Y = -cos*r1.y - (-sin*r1.x)
  r1.x = r5.x * -r1.x + r4.y;               // rotated X = -cos*r1.x + (-sin*r1.y)
  
  // ========================================================================
  // ATAN2 APPROXIMATION (Horizontal angle for cookie UV.x)
  // ========================================================================
  // Fast polynomial approximation of atan2(r0.y, r1.x)
  // This computes the horizontal angle for spherical coordinate mapping
  r1.y = min(abs(r1.x), abs(r0.y));
  r1.w = max(abs(r1.x), abs(r0.y));
  r1.w = 1 / r1.w;
  r1.y = r1.y * r1.w;                       // ratio = min/max (always <= 1)
  r1.w = r1.y * r1.y;                       // ratio^2
  
  // Polynomial approximation coefficients for atan
  r2.w = r1.w * 0.0208350997 + -0.0851330012;
  r2.w = r1.w * r2.w + 0.180141002;
  r2.w = r1.w * r2.w + -0.330299497;
  r1.w = r1.w * r2.w + 0.999866009;         // atan approximation
  r2.w = r1.y * r1.w;
  
  // Handle octant corrections for full atan2 range [-π, π]
  r3.w = cmp(abs(r0.y) < abs(r1.x));
  r2.w = r2.w * -2 + 1.57079637;            // π/2 - 2*atan for quadrant flip
  r2.w = r3.w ? r2.w : 0;
  r1.y = r1.y * r1.w + r2.w;
  
  // Sign corrections for negative quadrants
  r1.w = cmp(r0.y < -r0.y);                 // Check if r0.y < 0
  r1.w = r1.w ? -3.141593 : 0;              // Add -π if in negative half
  r1.y = r1.y + r1.w;
  
  // Final sign adjustment based on quadrant
  r1.w = min(r1.x, r0.y);
  r0.y = max(r1.x, r0.y);
  r1.x = cmp(r1.w < -r1.w);
  r0.y = cmp(r0.y >= -r0.y);
  r0.y = r0.y ? r1.x : 0;
  r0.y = r0.y ? -r1.y : r1.y;
  
  // ========================================================================
  // ACOS APPROXIMATION (Vertical angle for cookie UV.y)
  // ========================================================================
  // Fast polynomial approximation of acos(r1.z)
  // This computes the vertical angle for spherical coordinate mapping
  r1.x = 3.14159274 + r0.y;                 // Shift horizontal angle to [0, 2π]
  r0.y = 1 + -abs(r1.z);
  r0.y = sqrt(r0.y);                        // sqrt(1 - |z|)
  
  // Polynomial approximation for acos
  r1.w = abs(r1.z) * -0.0187292993 + 0.0742610022;
  r1.w = r1.w * abs(r1.z) + -0.212114394;
  r1.w = r1.w * abs(r1.z) + 1.57072878;
  r2.w = r1.w * r0.y;
  r2.w = r2.w * -2 + 3.14159274;            // Flip for negative z
  r1.z = cmp(-r1.z < r1.z);                 // Check sign of z
  r1.z = r1.z ? r2.w : 0;
  r1.y = r1.w * r0.y + r1.z;                // Final acos result
  
  // ========================================================================
  // SPOTLIGHT FALLOFF TEXTURE SAMPLING
  // ========================================================================
  // Convert angles to UV coordinates for the spotlight gradient texture
  r1.xy = float2(0.159154937,0.318309873) * r1.xy;  // Normalize to [0,1] range (1/2π, 1/π)
  r0.y = min(0.5, r1.y);                    // Clamp vertical to hemisphere
  r0.y = r0.y + r0.y;                       // Scale to full range
  
  // Apply per-light UV scaling from buffer
  r1.y = t78[bufIdx].val[14];               // Cookie U scale
  r1.w = t78[bufIdx].val[15];               // Cookie V scale (also fog blend flag)
  r1.y = 1 + -r1.y;
  r1.z = saturate(r1.y * r0.y);             // Final V coordinate
  
  // Sample spotlight falloff/gradient texture
  r1.xyz = t0.SampleLevel(s3_s, r1.xz, 0).xyz;
  
  // ========================================================================
  // LIGHT COOKIE/PROJECTION TEXTURE (Conditional)
  // ========================================================================
  // If the pixel is in front of the light (facing the light direction),
  // sample a projected cookie texture for shaped light patterns
  r0.y = dot(cb0[2].xyz, r2.xyz);           // Dot product with light direction
  r0.y = cmp(r0.y >= 0);                    // Check if in front of light
  if (r0.y != 0) {
    // Build orthonormal basis for light projection
    // Cross product of light direction with up vector (0,1,0)
    r2.xyz = float3(0,0,1) * cb0[2].yzx;
    r2.xyz = cb0[2].xyz * float3(0,1,0) + -r2.xyz;
    r0.y = dot(r2.yz, r2.yz);
    r0.y = rsqrt(r0.y);
    r2.xyz = r2.xyz * r0.yyy;               // Normalized right vector
    
    // Cross product to get up vector in light space
    r4.xyz = cb0[2].yzx * r2.xyz;
    r4.xyz = r2.zxy * cb0[2].zxy + -r4.xyz;
    r0.y = dot(r4.xyz, r4.xyz);
    r0.y = rsqrt(r0.y);
    r4.xyz = r4.xyz * r0.yyy;               // Normalized up vector
    
    // Calculate projection UV coordinates
    r0.x = sqrt(r0.x);                      // Distance to light
    r0.y = 4 * cb0[52].w;                   // Light projection scale
    r2.x = 1 / r0.x;
    r0.y = r2.x * r0.y;                     // Scale factor
    
    // Project pixel position onto light's image plane
    r5.xyz = -cb0[2].xyz * r0.xxx + cb0[0].xyz;  // Light position offset
    r2.xw = v4.xy + -r5.xy;
    r0.x = dot(r2.xw, r2.yz);               // Project onto right axis
    r2.xyz = v4.xyz + -r5.xyz;
    r2.x = dot(r2.xyz, r4.xyz);             // Project onto up axis
    
    // Compute final UV coordinates
    r4.x = r0.y * r0.x;
    r4.y = r2.x * r0.y;
    
    // Calculate unclamped UV for accurate distance calculation
    float2 unclampedUV = r4.xy * float2(0.5,0.5) + float2(0.5,0.5);
    r0.xy = saturate(unclampedUV);  // Map to [0,1] (clamped for texture sampling)
    
    // HDR Sun: Scale UVs from center to decrease sun size by 25% and increase brightness
    float2 sunUV = r0.xy;
    float sunCorona = 0;
    float sunBloom = 0;
    
    // Validation to prevent artifacts during scene initialization
    // UV bounds check - tightened to [-3, 3] since sun disk should be relatively centered
    // Garbage projection data often produces extreme UV values
    bool validLightData = (cb0[52].w > 0.001) && (cb0[52].w < 1000.0) &&
                          (abs(unclampedUV.x) < 3.0) && (abs(unclampedUV.y) < 3.0);
    
    if (CUSTOM_SUN_INTENSITY > 0 && validLightData) {
      // Calculate distance from center using UNCLAMPED UVs (prevents edge artifacts)
      float2 centerOffset = unclampedUV - 0.5;
      float distFromCenter = length(centerOffset) * 2.0;  // Normalize so edge = 1
      
      // Procedural corona: soft glow extending beyond the sun disk
      sunCorona = exp(-distFromCenter * 3.0) * 1.5;  // Exponential falloff
      sunCorona += exp(-distFromCenter * 8.0) * 0.5; // Tighter inner glow
      
      // Custom sun bloom: multiple wide layers simulating light diffusion
      sunBloom = exp(-distFromCenter * 1.0) * 0.8;   // Very wide outer bloom
      sunBloom += exp(-distFromCenter * 1.5) * 0.6;  // Medium bloom layer
      sunBloom += exp(-distFromCenter * 0.5) * 0.3;  // Ultra-wide atmospheric scatter
      
      // Scale UVs to shrink sun disk by 25%
      r0.xy = (r0.xy - 0.5) * 1.333333 + 0.5;
    }
    // NOTE: Removed the else-if branch that applied UV scaling with invalid data
    // This was causing artifacts when CUSTOM_SUN_INTENSITY > 0 but validLightData was false
    
    // Sample cookie texture and apply sRGB-like gamma approximation
    r2.xyz = t4.SampleLevel(s2_s, r0.xy, 0).xyz;
    
    // Apply HDR sun enhancements - ONLY when light data is valid
    // This prevents garbage data during scene initialization from causing artifacts
    if (CUSTOM_SUN_INTENSITY > 0 && validLightData) {
      // Zero out sun disk when UVs are outside [0,1] to prevent wrap artifacts
      if (any(r0.xy < 0) || any(r0.xy > 1)) {
        r2.xyz = 0;
      }
      
      // Soft edge falloff - blend disk edges smoothly into corona/sky
      // Use unclamped UV distance for consistent falloff calculation
      float2 uvOffset = unclampedUV - 0.5;
      float edgeDist = length(uvOffset) * 2.0;  // 0 at center, 1 at edge of original UV
      
      // Smooth falloff - fade starts at 30% from center, fully faded by 65%
      float edgeFade = 1.0 - smoothstep(0.3, 0.65, edgeDist);
      
      // Apply edge fade to sun disk
      r2.xyz = r2.xyz * edgeFade;
      
      // Increase sun disk brightness by 9x for HDR
      r2.xyz = r2.xyz * 9.0;
      
      // Add corona glow (warm tinted)
      float3 coronaColor = float3(1.0, 0.9, 0.7) * sunCorona;
      r2.xyz = r2.xyz + coronaColor;
      
      // Add custom bloom (slightly cooler/whiter for realistic light scatter)
      float3 bloomColor = float3(1.0, 0.95, 0.85) * sunBloom;
      r2.xyz = r2.xyz + bloomColor;
    }
    r4.xyz = r2.xyz * float3(0.305306017,0.305306017,0.305306017) + float3(0.682171106,0.682171106,0.682171106);
    r4.xyz = r2.xyz * r4.xyz + float3(0.0125228781,0.0125228781,0.0125228781);
    r2.xyz = r4.xyz * r2.xyz;               // Approximate sRGB to linear
    r2.xyz = cb0[52].xyz * r2.xyz;          // Multiply by light color
  } else {
    r2.xyz = float3(0,0,0);                 // No cookie contribution behind light
  }
  
  // Combine falloff texture with cookie texture
  r1.xyz = r1.xyz * cb0[84].xxx + r2.xyz;   // cb0[84].x = falloff intensity multiplier
  
  // ========================================================================
  // ATMOSPHERIC FOG / SCATTERING SETUP
  // ========================================================================
  r0.x = cmp(r1.w < 1);                     // Check if fog blending is enabled
  r0.y = -cb0[77].x + r0.w;                 // Distance minus fog start distance
  r0.y = max(0, r0.y);                      // Clamp to positive
  r0.y = cb0[101].w * r0.y;                 // Apply fog density multiplier
  
  // ========================================================================
  // BEER-LAMBERT ATMOSPHERIC ABSORPTION
  // ========================================================================
  // Exponential fog based on height and distance
  // Models light absorption as it travels through the atmosphere
  r0.w = cb0[56].y * 0.00999999978 + 9.99999975e-05;  // Fog density coefficient
  r1.w = -cb0[57].w + cb0[1].z;             // Height difference (camera Z - fog base)
  r1.w = r1.w * -r0.w;
  r1.w = 1.44269502 * r1.w;                 // Convert to log2 base (1/ln(2))
  r1.w = exp2(r1.w);                        // Exponential falloff with height
  r0.y = max(0, r0.y);
  r1.w = r0.y * r1.w;                       // Combined distance and height factor
  
  // Handle the integral of exponential fog along the view ray
  // This prevents division by zero when looking horizontally
  r2.x = cmp(0.00999999978 < abs(r0.z));    // Check if ray has significant vertical component
  r0.z = r0.w * -r0.z;
  r0.w = -1.44269502 * r0.z;
  r0.w = exp2(r0.w);
  r0.w = 1 + -r0.w;                         // 1 - exp(-density * deltaZ)
  r0.z = r0.w / r0.z;                       // Analytical integral of exponential
  r0.z = r1.w * r0.z;
  r0.z = r2.x ? r0.z : r1.w;                // Use simple fog if nearly horizontal
  
  // Final fog transmittance (how much light gets through)
  r0.z = -cb0[51].w * r0.z;                 // Apply extinction coefficient
  r0.z = 0.000721347576 * r0.z;             // Scale factor
  r0.z = exp2(r0.z);                        // Beer-Lambert: T = exp(-τ)
  r0.w = 1 + -cb0[57].z;                    // Fog max opacity
  r0.z = saturate(min(r0.z, r0.w));         // Clamp transmittance
  
  // ========================================================================
  // HENYEY-GREENSTEIN PHASE FUNCTION
  // ========================================================================
  // Models anisotropic scattering in participating media
  // Controls how light scatters based on angle between view and light
  // g parameter controls forward/backward scattering preference
  r0.w = 0.100000001 * cb0[57].y;           // Scattering anisotropy (g parameter)
  r0.w = min(0.999899983, r0.w);            // Clamp to avoid singularity at g=1
  r1.w = dot(cb0[2].xzy, r3.xyz);           // cos(θ) = dot(lightDir, viewDir)
  
  // Henyey-Greenstein formula: (1 - g²) / (4π * (1 + g² - 2g*cos(θ))^1.5)
  r2.x = -r0.w * r0.w + 1;                  // 1 - g²
  r2.y = r0.w * r0.w + 1;                   // 1 + g²
  r0.w = dot(r1.ww, r0.ww);                 // g * cos(θ) * 2 (approximation)
  r0.w = r2.y + -r0.w;                      // 1 + g² - 2g*cos(θ)
  r0.w = log2(abs(r0.w));
  r0.w = 1.5 * r0.w;                        // Power of 1.5
  r0.w = exp2(r0.w);
  r0.w = 12.566371 * r0.w;                  // 4π
  r0.w = r2.x / r0.w;                       // Final phase function value
  r0.w = max(0, r0.w);
  r0.w = min(100, r0.w);                    // Clamp to prevent fireflies
  r0.w = cb0[56].w * r0.w;                  // Apply phase function intensity
  
  // Apply phase function to atmospheric scattering color
  r2.xyz = cb0[55].xyz * r0.www;            // cb0[55] = atmospheric scattering color
  r0.w = dot(cb0[52].xyz, cb0[52].xyz);     // Light color magnitude
  r0.w = sqrt(r0.w);
  r0.w = cb0[84].x + r0.w;                  // Add ambient contribution
  r1.xyz = r2.xyz * r0.www + r1.xyz;        // Add scattering to light color
  
  // ========================================================================
  // ENVIRONMENT / SKY AMBIENT CONTRIBUTION (Conditional)
  // ========================================================================
  // If fog blending is enabled, sample the environment cubemap and blend
  // the volumetric light with the ambient sky color
  if (r0.x != 0) {
    // Sample environment cubemap in the opposite view direction
    r2.xyz = -r3.xyz;
    r2.xyz = t37.SampleLevel(s2_s, r2.xyz, 2).xyz;  // LOD 2 for blurry ambient
    r2.xyz = r2.xyz / cb0[107].xxx;         // Normalize by exposure reference
    
    // ======================================================================
    // RGB TO XYZ COLOR SPACE CONVERSION
    // ======================================================================
    // Convert from RGB to CIE XYZ for color processing
    r0.x = dot(r2.xyz, float3(0.412400007,0.357600003,0.180500001));  // X
    r0.w = dot(r2.xyz, float3(0.212599993,0.715200007,0.0722000003)); // Y (luminance)
    r1.w = dot(r2.xyz, float3(0.0193000007,0.119199999,0.950500011)); // Z
    
    // Calculate chromaticity coordinates (x, y from xyY)
    r2.x = r0.x + r0.w;
    r1.w = r2.x + r1.w;                     // X + Y + Z
    r1.w = 9.99999975e-06 + r1.w;           // Prevent division by zero
    r0.x = r0.x / r1.w;                     // x = X / (X+Y+Z)
    r1.w = r0.w / r1.w;                     // y = Y / (X+Y+Z)
    
    // Desaturation based on luminance
    r2.x = 9.99999975e-06 + r1.w;
    r2.x = r0.w / r2.x;                     // Luminance ratio
    r2.y = r2.x * r0.x;                     // Modified x
    r0.x = 1 + -r0.x;
    r0.x = r0.x + -r1.w;
    r0.x = r0.x * r2.x;                     // Modified z chromaticity
    
    // ======================================================================
    // XYZ TO RGB COLOR SPACE CONVERSION
    // ======================================================================
    // Convert back from XYZ to RGB
    r2.xzw = float3(-1.53719997,1.87580001,-0.203999996) * r0.www;
    r2.xyz = r2.yyy * float3(3.24060011,-0.968900025,0.0557000004) + r2.xzw;
    r2.xyz = r0.xxx * float3(-0.498600006,0.0414999984,1.05700004) + r2.xyz;
    
    // ======================================================================
    // DISTANCE-BASED FOG COLOR BLEND
    // ======================================================================
    // Blend towards fog color based on distance
    r0.x = -0.00595833035 * r0.y;           // Distance-based blend factor
    r0.x = exp2(r0.x);
    r0.x = 1 + -r0.x;                       // Blend amount (0 near, 1 far)
    r0.x = cb0[100].x * r0.x;               // Apply fog color intensity
    
    // Interpolate between fog color and calculated ambient
    r2.xyz = -cb0[51].xyz + r2.xyz;         // cb0[51] = fog/ambient color
    r0.xyw = r0.xxx * r2.xyz + cb0[51].xyz; // Lerp to fog color
  } else {
    r0.xyw = r1.xyz;                        // No ambient blend, use light color directly
  }
  
  // ========================================================================
  // FINAL FOG TRANSMITTANCE BLEND
  // ========================================================================
  // Blend between the ambient-modified color and the raw light color
  // based on the fog transmittance calculated earlier
  r1.xyz = r1.xyz + -r0.xyw;
  r0.xyz = r0.zzz * r1.xyz + r0.xyw;        // Lerp based on transmittance
  
  // ========================================================================
  // AUTO-EXPOSURE / ADAPTATION
  // ========================================================================
  // Apply scene exposure from the adaptation texture or use default
  r0.w = cmp(0 != cb0[101].x);              // Check if auto-exposure is enabled
  if (r0.w != 0) {
    r0.w = t28.SampleLevel(s1_s, float2(0.5,0.5), 0).x;  // Sample center of adaptation texture
  } else {
    r0.w = cb0[107].y;                      // Use default exposure value
  }
  r0.xyz = r0.xyz * r0.www;                 // Apply exposure
  
  // ========================================================================
  // DITHERING (Anti-banding) - BYPASSED
  // ========================================================================
  //
  // r0.w = cmp(0 != cb0[106].w);              // Check if dithering is enabled
  // if (r0.w != 0) {
  //   r0.w = t78[bufIdx].val[13];             // Dither intensity from per-light buffer
  //   r0.w = 0.0199999996 * r0.w;             // Scale dither amount
  //   
  //   // Sample noise texture based on screen position
  //   r1.xy = float2(0.0009765625,0.0009765625) * v0.xy;  // 1/1024 scale
  //   r1.xy = t8.Sample(s0_s, r1.xy).xy;      // Two-channel noise
  //   r1.x = 1 + -r1.x;
  //   r1.x = r1.x + -r1.y;                    // Combine channels for signed noise
  //   r0.xyz = r1.xxx * r0.www + r0.xyz;      // Add dither to final color
  // }
  
  // ========================================================================
  // OUTPUT
  // ========================================================================
  o0.xyz = r0.xyz;
  o0.w = 1;                                 // Alpha = 1 (fully opaque)
  return;
}
