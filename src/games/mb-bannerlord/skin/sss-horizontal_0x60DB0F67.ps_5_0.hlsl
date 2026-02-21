// ---- Created with 3Dmigoto v1.4.1 on Thu Feb 19 09:05:46 2026
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

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
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 0.5 * cb2[8].z;
  sincos(r0.x, r0.x, r1.x);
  r0.x = r0.x / r1.x;
  r0.x = 1 / r0.x;
  r0.yz = cb2[33].xy * v2.xy;
  r0.w = t1.SampleLevel(s1_s, r0.yz, 0).x;
  r1.xyzw = t0.SampleLevel(s1_s, r0.yz, 0).xyzw;
  r0.y = cb0[83].y + r0.w;
  r0.y = cb0[83].z / r0.y;
  r0.z = r0.x / r0.y;
  r0.x = 19.2000008 * r0.x;
  r2.xyzw = r0.zzzz * float4(-0.0106666675,-0,-0.00816666707,-0) + v2.xyxy;
  r2.xyzw = cb2[33].xyxy * r2.xyzw;
  r3.xyz = t0.SampleLevel(s3_s, r2.xy, 0).xyz;
  r0.w = t1.SampleLevel(s1_s, r2.xy, 0).x;
  r0.w = cb0[83].y + r0.w;
  r0.w = cb0[83].z / r0.w;
  r0.w = r0.y + -r0.w;
  r0.w = saturate(r0.x * abs(r0.w));
  r4.xyz = -r3.xyz + r1.xyz;
  r3.xyz = r0.www * r4.xyz + r3.xyz;
  r3.xyz = float3(0.00317393988,0.000134823,3.77268989e-05) * r3.xyz;
  r3.xyz = r1.xyz * float3(0.536342978,0.624624014,0.748866975) + r3.xyz;
  r4.xyz = t0.SampleLevel(s3_s, r2.zw, 0).xyz;
  r0.w = t1.SampleLevel(s1_s, r2.zw, 0).x;
  r0.w = cb0[83].y + r0.w;
  r0.w = cb0[83].z / r0.w;
  r0.w = r0.y + -r0.w;
  r0.w = saturate(r0.x * abs(r0.w));
  r2.xyz = -r4.xyz + r1.xyz;
  r2.xyz = r0.www * r2.xyz + r4.xyz;
  r2.xyz = r2.xyz * float3(0.0100386003,0.000914679025,0.000275702012) + r3.xyz;
  r3.xyzw = r0.zzzz * float4(-0.00600000052,-0,-0.00416666688,-0) + v2.xyxy;
  r3.xyzw = cb2[33].xyxy * r3.xyzw;
  r0.w = t1.SampleLevel(s1_s, r3.xy, 0).x;
  r0.w = cb0[83].y + r0.w;
  r0.w = cb0[83].z / r0.w;
  r0.w = r0.y + -r0.w;
  r0.w = saturate(r0.x * abs(r0.w));
  r4.xyz = t0.SampleLevel(s3_s, r3.xy, 0).xyz;
  r5.xyz = -r4.xyz + r1.xyz;
  r4.xyz = r0.www * r5.xyz + r4.xyz;
  r2.xyz = r4.xyz * float3(0.0144608999,0.00317269005,0.00106399006) + r2.xyz;
  r0.w = t1.SampleLevel(s1_s, r3.zw, 0).x;
  r3.xyz = t0.SampleLevel(s3_s, r3.zw, 0).xyz;
  r0.w = cb0[83].y + r0.w;
  r0.w = cb0[83].z / r0.w;
  r0.w = r0.y + -r0.w;
  r0.w = saturate(r0.x * abs(r0.w));
  r4.xyz = -r3.xyz + r1.xyz;
  r3.xyz = r0.www * r4.xyz + r3.xyz;
  r2.xyz = r3.xyz * float3(0.0216301009,0.00794618018,0.00376990996) + r2.xyz;
  r3.xyzw = r0.zzzz * float4(-0.00266666687,-0,-0.00150000013,-0) + v2.xyxy;
  r3.xyzw = cb2[33].xyxy * r3.xyzw;
  r0.w = t1.SampleLevel(s1_s, r3.xy, 0).x;
  r0.w = cb0[83].y + r0.w;
  r0.w = cb0[83].z / r0.w;
  r0.w = r0.y + -r0.w;
  r0.w = saturate(r0.x * abs(r0.w));
  r4.xyz = t0.SampleLevel(s3_s, r3.xy, 0).xyz;
  r5.xyz = -r4.xyz + r1.xyz;
  r4.xyz = r0.www * r5.xyz + r4.xyz;
  r2.xyz = r4.xyz * float3(0.034731701,0.0151084997,0.00871982984) + r2.xyz;
  r0.w = t1.SampleLevel(s1_s, r3.zw, 0).x;
  r3.xyz = t0.SampleLevel(s3_s, r3.zw, 0).xyz;
  r0.w = cb0[83].y + r0.w;
  r0.w = cb0[83].z / r0.w;
  r0.w = r0.y + -r0.w;
  r0.w = saturate(r0.x * abs(r0.w));
  r4.xyz = -r3.xyz + r1.xyz;
  r3.xyz = r0.www * r4.xyz + r3.xyz;
  r2.xyz = r3.xyz * float3(0.0571056008,0.0287432,0.0172844008) + r2.xyz;
  r3.xyzw = r0.zzzz * float4(-0.000666666718,-0,-0.000166666679,-0) + v2.xyxy;
  r3.xyzw = cb2[33].xyxy * r3.xyzw;
  r0.w = t1.SampleLevel(s1_s, r3.xy, 0).x;
  r0.w = cb0[83].y + r0.w;
  r0.w = cb0[83].z / r0.w;
  r0.w = r0.y + -r0.w;
  r0.w = saturate(r0.x * abs(r0.w));
  r4.xyz = t0.SampleLevel(s3_s, r3.xy, 0).xyz;
  r5.xyz = -r4.xyz + r1.xyz;
  r4.xyz = r0.www * r5.xyz + r4.xyz;
  r2.xyz = r4.xyz * float3(0.0582415983,0.0659959018,0.0411329009) + r2.xyz;
  r0.w = t1.SampleLevel(s1_s, r3.zw, 0).x;
  r3.xyz = t0.SampleLevel(s3_s, r3.zw, 0).xyz;
  r0.w = cb0[83].y + r0.w;
  r0.w = cb0[83].z / r0.w;
  r0.w = r0.y + -r0.w;
  r0.w = saturate(r0.x * abs(r0.w));
  r4.xyz = -r3.xyz + r1.xyz;
  r3.xyz = r0.www * r4.xyz + r3.xyz;
  r2.xyz = r3.xyz * float3(0.0324461982,0.0656718016,0.0532821007) + r2.xyz;
  r3.xyzw = r0.zzzz * float4(0.000166666679,0,0.000666666718,0) + v2.xyxy;
  r3.xyzw = cb2[33].xyxy * r3.xyzw;
  r0.w = t1.SampleLevel(s1_s, r3.xy, 0).x;
  r0.w = cb0[83].y + r0.w;
  r0.w = cb0[83].z / r0.w;
  r0.w = r0.y + -r0.w;
  r0.w = saturate(r0.x * abs(r0.w));
  r4.xyz = t0.SampleLevel(s3_s, r3.xy, 0).xyz;
  r5.xyz = -r4.xyz + r1.xyz;
  r4.xyz = r0.www * r5.xyz + r4.xyz;
  r2.xyz = r4.xyz * float3(0.0324461982,0.0656718016,0.0532821007) + r2.xyz;
  r0.w = t1.SampleLevel(s1_s, r3.zw, 0).x;
  r3.xyz = t0.SampleLevel(s3_s, r3.zw, 0).xyz;
  r0.w = cb0[83].y + r0.w;
  r0.w = cb0[83].z / r0.w;
  r0.w = r0.y + -r0.w;
  r0.w = saturate(r0.x * abs(r0.w));
  r4.xyz = -r3.xyz + r1.xyz;
  r3.xyz = r0.www * r4.xyz + r3.xyz;
  r2.xyz = r3.xyz * float3(0.0582415983,0.0659959018,0.0411329009) + r2.xyz;
  r3.xyzw = r0.zzzz * float4(0.00150000013,0,0.00266666687,0) + v2.xyxy;
  r3.xyzw = cb2[33].xyxy * r3.xyzw;
  r0.w = t1.SampleLevel(s1_s, r3.xy, 0).x;
  r0.w = cb0[83].y + r0.w;
  r0.w = cb0[83].z / r0.w;
  r0.w = r0.y + -r0.w;
  r0.w = saturate(r0.x * abs(r0.w));
  r4.xyz = t0.SampleLevel(s3_s, r3.xy, 0).xyz;
  r5.xyz = -r4.xyz + r1.xyz;
  r4.xyz = r0.www * r5.xyz + r4.xyz;
  r2.xyz = r4.xyz * float3(0.0571056008,0.0287432,0.0172844008) + r2.xyz;
  r0.w = t1.SampleLevel(s1_s, r3.zw, 0).x;
  r3.xyz = t0.SampleLevel(s3_s, r3.zw, 0).xyz;
  r0.w = cb0[83].y + r0.w;
  r0.w = cb0[83].z / r0.w;
  r0.w = r0.y + -r0.w;
  r0.w = saturate(r0.x * abs(r0.w));
  r4.xyz = -r3.xyz + r1.xyz;
  r3.xyz = r0.www * r4.xyz + r3.xyz;
  r2.xyz = r3.xyz * float3(0.034731701,0.0151084997,0.00871982984) + r2.xyz;
  r3.xyzw = r0.zzzz * float4(0.00416666688,0,0.00600000052,0) + v2.xyxy;
  r4.xyzw = r0.zzzz * float4(0.00816666707,0,0.0106666675,0) + v2.xyxy;
  r4.xyzw = cb2[33].xyxy * r4.xyzw;
  r3.xyzw = cb2[33].xyxy * r3.xyzw;
  r0.z = t1.SampleLevel(s1_s, r3.xy, 0).x;
  r0.z = cb0[83].y + r0.z;
  r0.z = cb0[83].z / r0.z;
  r0.z = r0.y + -r0.z;
  r0.z = saturate(r0.x * abs(r0.z));
  r5.xyz = t0.SampleLevel(s3_s, r3.xy, 0).xyz;
  r6.xyz = -r5.xyz + r1.xyz;
  r5.xyz = r0.zzz * r6.xyz + r5.xyz;
  r2.xyz = r5.xyz * float3(0.0216301009,0.00794618018,0.00376990996) + r2.xyz;
  r0.z = t1.SampleLevel(s1_s, r3.zw, 0).x;
  r3.xyz = t0.SampleLevel(s3_s, r3.zw, 0).xyz;
  r0.z = cb0[83].y + r0.z;
  r0.z = cb0[83].z / r0.z;
  r0.z = r0.y + -r0.z;
  r0.z = saturate(r0.x * abs(r0.z));
  r5.xyz = -r3.xyz + r1.xyz;
  r3.xyz = r0.zzz * r5.xyz + r3.xyz;
  r2.xyz = r3.xyz * float3(0.0144608999,0.00317269005,0.00106399006) + r2.xyz;
  r0.z = t1.SampleLevel(s1_s, r4.xy, 0).x;
  r0.z = cb0[83].y + r0.z;
  r0.z = cb0[83].z / r0.z;
  r0.z = r0.y + -r0.z;
  r0.z = saturate(r0.x * abs(r0.z));
  r3.xyz = t0.SampleLevel(s3_s, r4.xy, 0).xyz;
  r5.xyz = -r3.xyz + r1.xyz;
  r3.xyz = r0.zzz * r5.xyz + r3.xyz;
  r2.xyz = r3.xyz * float3(0.0100386003,0.000914679025,0.000275702012) + r2.xyz;
  r0.z = t1.SampleLevel(s1_s, r4.zw, 0).x;
  r3.xyz = t0.SampleLevel(s3_s, r4.zw, 0).xyz;
  r0.z = cb0[83].y + r0.z;
  r0.z = cb0[83].z / r0.z;
  r0.y = r0.y + -r0.z;
  r0.x = saturate(r0.x * abs(r0.y));
  r0.yzw = -r3.xyz + r1.xyz;
  r0.xyz = r0.xxx * r0.yzw + r3.xyz;
  o0.xyz = r0.xyz * float3(0.00317393988,0.000134823,3.77268989e-05) + r2.xyz;
  o0.w = r1.w;
  return;
}