// ---- Created with 3Dmigoto v1.4.1 on Mon Jan 12 06:06:12 2026

cbuffer camera_VS_PS : register(b0)
{
  float3 camera_position : packoffset(c0);
  float4x4 view : packoffset(c1);
  float4x4 projection : packoffset(c5);
  float4x4 view_projection : packoffset(c9);
  float4x4 inv_view : packoffset(c13);
  float4x4 inv_projection : packoffset(c17);
  float4x4 inv_view_projection : packoffset(c21);
  float4 camera_near_far : packoffset(c25);
  float time_in_sec : packoffset(c26);
  float2 g_inverse_focal_length : packoffset(c26.y);
  float g_vertical_fov : packoffset(c26.w);
  float4 g_screen_size : packoffset(c27);
  float g_vpos_texel_offset : packoffset(c28);
  float4 g_viewport_dimensions : packoffset(c29);
  float4 g_camera_temp0 : packoffset(c30);
  float4 g_camera_temp1 : packoffset(c31);
  float4 g_camera_temp2 : packoffset(c32);
  float4 g_clip_rect : packoffset(c33);
  float g_hide_foliage : packoffset(c34);
}

cbuffer fog_of_war_PS : register(b1)
{
  float g_fog_of_war_size : packoffset(c0);
  float g_fog_of_war_min_height : packoffset(c0.y);
  float g_fog_of_war_height_range : packoffset(c0.z);
  float3 g_fog_of_war_source_position : packoffset(c1);
  float4x4 g_fog_of_war_source_view_projection : packoffset(c2);
  float g_fog_of_war_source_z_far : packoffset(c6);
  float g_fog_of_war_distance : packoffset(c6.y);
  float g_fog_of_war_cross_fade_step : packoffset(c6.z);
}

SamplerState s_fog_of_war_source_s : register(s0);
SamplerState s_fog_of_war_current_s : register(s1);
Texture2D<float4> s_fog_of_war_source : register(t0);
Texture2D<float4> s_fog_of_war_current : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = g_vpos_texel_offset + v0.xy;
  r0.xy = r0.xy / g_fog_of_war_size;
  r1.xyzw = s_fog_of_war_source.SampleLevel(s_fog_of_war_source_s, r0.xy, 0).xyzw;
  r0.xyzw = s_fog_of_war_current.SampleLevel(s_fog_of_war_current_s, r0.xy, 0).xyzw;
  r1.xyzw = r1.xyzw + -r0.xyzw;
  o0.xyzw = g_fog_of_war_cross_fade_step * r1.xyzw + r0.xyzw;
  return;
}