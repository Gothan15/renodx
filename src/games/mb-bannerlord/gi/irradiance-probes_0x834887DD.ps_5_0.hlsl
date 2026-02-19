// ---- Created with 3Dmigoto v1.4.1 on Wed Feb 18 22:50:56 2026
struct t89_t {
  float val[24];
};
StructuredBuffer<t89_t> t89 : register(t89);

struct t88_t {
  float val[4];
};
StructuredBuffer<t88_t> t88 : register(t88);

struct t87_t {
  float val[1];
};
StructuredBuffer<t87_t> t87 : register(t87);

Texture2D<float4> t56 : register(t56);

Texture2D<float4> t28 : register(t28);

Texture2D<float4> t16 : register(t16);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[108];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,r21,r22;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t16.Sample(s0_s, v2.xy).x;
  r0.yz = v2.xy / cb0[105].xy;
  r0.y = r0.y * 2 + -1;
  r0.z = 1 + -r0.z;
  r0.z = r0.z * 2 + -1;
  r1.xyzw = cb0[44].xyzw * r0.zzzz;
  r1.xyzw = cb0[43].xyzw * r0.yyyy + r1.xyzw;
  r0.xyzw = cb0[45].xyzw * r0.xxxx + r1.xyzw;
  r0.xyzw = cb0[46].xyzw + r0.xyzw;
  r0.xyz = r0.xyz / r0.www;
  r1.x = t1.Gather(s1_s, v2.xy).w;
  r1.y = t1.GatherGreen(s1_s, v2.xy).w;
  r1.xy = r1.xy * float2(3.55539989,3.55539989) + float2(-1.77769995,-1.77769995);
  r1.z = 1;
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = 2 / r0.w;
  r1.xy = r0.ww * r1.xy;
  r0.w = -1 + r0.w;
  r1.yzw = cb0[59].xyz * r1.yyy;
  r1.xyz = cb0[58].xyz * r1.xxx + r1.yzw;
  r1.xyz = cb0[60].xyz * r0.www + r1.xyz;
  r2.x = t2.Gather(s1_s, v2.xy).w;
  r2.y = t2.GatherGreen(s1_s, v2.xy).w;
  r2.xy = r2.xy * float2(3.55539989,3.55539989) + float2(-1.77769995,-1.77769995);
  r2.z = 1;
  r0.w = dot(r2.xyz, r2.xyz);
  r0.w = 2 / r0.w;
  r2.xy = r0.ww * r2.xy;
  r0.w = -1 + r0.w;
  r2.yzw = cb0[59].xyz * r2.yyy;
  r2.xyz = cb0[58].xyz * r2.xxx + r2.yzw;
  r2.xyz = cb0[60].xyz * r0.www + r2.xyz;
  r3.xyz = cb0[90].zxy + -cb0[89].zxy;
  r4.xyz = -cb0[89].zxy + r0.zxy;
  r3.xyz = r4.xyz / r3.xyz;
  r4.y = cb0[89].w;
  r4.z = cb0[90].w;
  r4.x = cb0[91].w;
  r3.xyz = r4.xyz * r3.xyz;
  r4.xyz = float3(-0.5,-0.5,-0.5) + r4.xyz;
  r3.xyz = max(float3(0.5,0.5,0.5), r3.xyz);
  r3.xyz = min(r3.xyz, r4.xyz);
  r4.xyz = cmp(cb0[89].xyz < r0.xyz);
  r0.w = r4.y ? r4.x : 0;
  r0.w = r4.z ? r0.w : 0;
  r4.xyz = cmp(r0.xyz < cb0[90].xyz);
  r0.w = r4.x ? r0.w : 0;
  r0.w = r4.y ? r0.w : 0;
  r0.w = r4.z ? r0.w : 0;
  r4.xyz = cb0[93].xyz / cb0[91].xyz;
  r4.xyz = cb0[89].xyz + r4.xyz;
  r0.xyz = r0.www ? r0.xyz : r4.xyz;
  r3.xyz = r0.www ? r3.xyz : cb0[93].zxy;
  r4.xyz = frac(r3.yzx);
  r5.xyz = cmp(r4.zxy >= float3(0.5,0.5,0.5));
  r5.xyz = r5.xyz ? float3(1,1,1) : float3(-1,-1,-1);
  r4.xyz = float3(0.5,0.5,0.5) + -r4.xyz;
  r4.xyz = float3(1,1,1) + -abs(r4.xyz);
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = rsqrt(r0.w);
  r1.xyz = r1.xyz * r0.www;
  r6.xyz = saturate(r1.xyz);
  r0.w = r6.x + r6.y;
  r7.xyz = saturate(-r1.xyz);
  r0.w = r7.x + r0.w;
  r0.w = r0.w + r7.y;
  r0.w = r0.w + r7.z;
  r0.w = r0.w + r6.z;
  r8.xyz = r4.xyz * float3(-2,-2,-2) + float3(1,1,1);
  r1.w = dot(r2.xyz, r2.xyz);
  r1.w = rsqrt(r1.w);
  r2.xyz = r2.xyz * r1.www;
  r9.xyz = cmp(float3(0,0,0) < r7.xyz);
  r10.xyz = cmp(float3(0,0,0) < r6.xyz);
  r11.w = 1;
  r12.yw = float2(1,1);
  r13.xyzw = float4(0,0,0,0);
  r1.w = 0;
  r2.w = 0;
  while (true) {
    r3.w = cmp((uint)r2.w >= 8);
    if (r3.w != 0) break;
    r3.w = (int)r2.w & 1;
    if (1 == 0) r4.w = 0; else if (1+1 < 32) {     r4.w = (uint)r2.w << (32-(1 + 1)); r4.w = (uint)r4.w >> (32-1);    } else r4.w = (uint)r2.w >> 1;
    r5.w = (uint)r2.w >> 2;
    r14.x = (int)r3.w;
    r14.y = (int)r4.w;
    r14.z = (int)r5.w;
    r15.xyz = r14.zxy * r5.xyz + r3.xyz;
    r15.xyz = trunc(r15.xyz);
    r3.w = r15.z * cb0[89].w + r15.y;
    r3.w = cb0[91].w * r3.w + r15.x;
    uint probeData = asuint(t87[(int)r3.w].val[0/4]);
    if (!(probeData & 0x80000000u)) {
      r4.w = (int)r2.w + 1;
      r2.w = r4.w;
      continue;
    }
    r14.xyz = r14.xyz * r8.xyz + r4.xyz;
    r4.w = probeData & 0x0007ffffu;
    r5.w = (int)r4.w * 7;
    r15.x = t88[r5.w].val[0/4];
    r15.y = t88[r5.w].val[0/4+1];
    r15.z = t88[r5.w].val[0/4+2];
    r15.xyz = r15.xyz + -r0.xyz;
    r5.w = dot(r15.xyz, r15.xyz);
    r5.w = sqrt(r5.w);
    r6.w = r14.x * r14.y;
    r6.w = r6.w * r14.z;
    r7.w = cmp(9.99999975e-05 < r5.w);
    if (r7.w != 0) {
      r5.w = rcp(r5.w);
      r14.xyz = r15.xyz * r5.www;
      r5.w = saturate(dot(r14.xyz, r1.xyz));
      r6.w = r6.w * r5.w;
    }
    r5.w = max(9.99999975e-05, r6.w);
    r3.w = (probeData >> 19u) & 0xFFFu;
    r6.w = cmp((int)r3.w != 4095);
    if (r6.w != 0) {
      r14.xyz = -r2.xyz * float3(0.0500000007,0.0500000007,0.0500000007) + r15.xyz;
      r11.xyz = -r14.xyz;
      r15.xy = cmp(abs(r14.yz) < abs(r14.xx));
      r6.w = r15.y ? r15.x : 0;
      if (r6.w != 0) {
        r6.w = cmp(0 < r11.x);
        r15.z = dot(float2(1.00100088,-0.0100100096), r11.xw);
        r16.x = t89[r3.w].val[0/4+2];
        r16.y = t89[r3.w].val[0/4+3];
        r16.z = t89[r3.w].val[0/4];
        r16.w = t89[r3.w].val[0/4+1];
        r17.z = dot(float2(-1.00100088,-0.0100100096), r11.xw);
        r18.xz = float2(-0.99999994,0.99999994) * r14.xx;
        r19.x = t89[r3.w].val[16/4];
        r19.y = t89[r3.w].val[16/4+1];
        r19.z = t89[r3.w].val[16/4+2];
        r19.w = t89[r3.w].val[16/4+3];
        r15.xy = float2(0.99999994,-1) * r14.yz;
        r17.xy = float2(-0.99999994,-1) * r14.yz;
        r15.xyz = r6.www ? r15.xyz : r17.xyz;
        r17.xy = r6.ww ? r16.zw : r19.xy;
        r16.z = r18.x;
        r18.xy = r19.zw;
        r16.xyz = r6.www ? r16.xyz : r18.xyz;
      } else {
        r17.zw = cmp(abs(r14.xz) < abs(r14.yy));
        r6.w = r17.w ? r17.z : 0;
        if (r6.w != 0) {
          r6.w = cmp(0 < r11.y);
          r12.x = r11.y;
          r18.z = dot(float2(1.00100088,-0.0100100096), r12.xy);
          r19.x = t89[r3.w].val[32/4+2];
          r19.y = t89[r3.w].val[32/4+3];
          r19.z = t89[r3.w].val[32/4];
          r19.w = t89[r3.w].val[32/4+1];
          r20.z = dot(float2(-1.00100088,-0.010001), r12.xy);
          r21.xz = float2(-0.99999994,0.99999994) * r14.yy;
          r22.x = t89[r3.w].val[48/4];
          r22.y = t89[r3.w].val[48/4+1];
          r22.z = t89[r3.w].val[48/4+2];
          r22.w = t89[r3.w].val[48/4+3];
          r18.xy = float2(-0.99999994,-1) * r14.xz;
          r20.xy = float2(0.99999994,-1) * r14.xz;
          r15.xyz = r6.www ? r18.xyz : r20.xyz;
          r17.xy = r6.ww ? r19.zw : r22.xy;
          r19.z = r21.x;
          r21.xy = r22.zw;
          r16.xyz = r6.www ? r19.xyz : r21.xyz;
        } else {
          r6.w = cmp(0 < r11.z);
          r12.z = r11.z;
          r11.z = dot(float2(1.00100088,-0.0100100096), r12.zw);
          r18.x = t89[r3.w].val[64/4+2];
          r18.y = t89[r3.w].val[64/4+3];
          r18.z = t89[r3.w].val[64/4];
          r18.w = t89[r3.w].val[64/4+1];
          r19.z = dot(float2(-1.00100088,-0.0100100096), r12.zw);
          r20.xz = float2(-0.99999994,0.99999994) * r14.zz;
          r21.x = t89[r3.w].val[80/4];
          r21.y = t89[r3.w].val[80/4+1];
          r21.z = t89[r3.w].val[80/4+2];
          r21.w = t89[r3.w].val[80/4+3];
          r11.xy = float2(0.99999994,-1) * r14.xy;
          r19.xy = float2(0.99999994,1) * r14.xy;
          r15.xyz = r6.www ? r11.xyz : r19.xyz;
          r17.xy = r6.ww ? r18.zw : r21.xy;
          r18.z = r20.x;
          r20.xy = r21.zw;
          r16.xyz = r6.www ? r18.xyz : r20.xyz;
        }
      }
      r11.xyz = r15.xyz / r16.zzz;
      r14.xy = r11.xy * float2(0.5,0.5) + float2(0.5,0.5);
      r14.z = 1 + -r14.y;
      r11.xy = r14.xz * r17.xy + r16.xy;
      r12.xz = r17.xy * float2(0.5,0.5) + r16.xy;
      r11.xy = -r12.xz + r11.xy;
      r11.xy = r11.xy * float2(0.899999976,0.899999976) + r12.xz;
      r3.w = t56.SampleLevel(s2_s, r11.xy, 0).x;
      r3.w = 0.000216 + r3.w;
      r3.w = cmp(r11.z < r3.w);
      r3.w = r3.w ? 1.000000 : 0;
      r5.w = r5.w * r3.w;
    }
    r3.w = cmp(0 < r5.w);
    if (r3.w != 0) {
      if (r10.x != 0) {
        r3.w = mad((int)r4.w, 7, 1);
        r14.x = t88[r3.w].val[0/4];
        r14.y = t88[r3.w].val[0/4+1];
        r14.z = t88[r3.w].val[0/4+2];
        r14.w = t88[r3.w].val[0/4+3];
        r14.xyzw = r14.wxyz * r6.xxxx;
        r11.xyz = cb0[94].xyz * r14.xxx + r14.yzw;
      } else {
        r11.xyz = float3(0,0,0);
        r14.x = 0;
      }
      if (r10.y != 0) {
        r3.w = mad((int)r4.w, 7, 2);
        r15.x = t88[r3.w].val[0/4];
        r15.y = t88[r3.w].val[0/4+1];
        r15.z = t88[r3.w].val[0/4+2];
        r15.w = t88[r3.w].val[0/4+3];
        r3.w = r15.w * r6.y;
        r14.yzw = r15.xyz * r6.yyy + r11.xyz;
        r11.xyz = cb0[95].xyz * r3.www + r14.yzw;
        r14.x = r15.w * r6.y + r14.x;
      }
      if (r9.x != 0) {
        r3.w = mad((int)r4.w, 7, 3);
        r15.x = t88[r3.w].val[0/4];
        r15.y = t88[r3.w].val[0/4+1];
        r15.z = t88[r3.w].val[0/4+2];
        r15.w = t88[r3.w].val[0/4+3];
        r3.w = r15.w * r7.x;
        r14.yzw = r15.xyz * r7.xxx + r11.xyz;
        r11.xyz = cb0[96].xyz * r3.www + r14.yzw;
        r14.x = r15.w * r7.x + r14.x;
      }
      if (r9.y != 0) {
        r3.w = mad((int)r4.w, 7, 4);
        r15.x = t88[r3.w].val[0/4];
        r15.y = t88[r3.w].val[0/4+1];
        r15.z = t88[r3.w].val[0/4+2];
        r15.w = t88[r3.w].val[0/4+3];
        r3.w = r15.w * r7.y;
        r14.yzw = r15.xyz * r7.yyy + r11.xyz;
        r11.xyz = cb0[97].xyz * r3.www + r14.yzw;
        r14.x = r15.w * r7.y + r14.x;
      }
      if (r9.z != 0) {
        r3.w = mad((int)r4.w, 7, 5);
        r15.x = t88[r3.w].val[0/4];
        r15.y = t88[r3.w].val[0/4+1];
        r15.z = t88[r3.w].val[0/4+2];
        r15.w = t88[r3.w].val[0/4+3];
        r3.w = r15.w * r7.z;
        r14.yzw = r15.xyz * r7.zzz + r11.xyz;
        r11.xyz = cb0[98].xyz * r3.www + r14.yzw;
        r14.x = r15.w * r7.z + r14.x;
      }
      if (r10.z != 0) {
        r3.w = mad((int)r4.w, 7, 6);
        r15.x = t88[r3.w].val[0/4];
        r15.y = t88[r3.w].val[0/4+1];
        r15.z = t88[r3.w].val[0/4+2];
        r15.w = t88[r3.w].val[0/4+3];
        r3.w = r15.w * r6.z;
        r14.yzw = r15.xyz * r6.zzz + r11.xyz;
        r11.xyz = cb0[99].xyz * r3.www + r14.yzw;
        r14.x = r15.w * r6.z + r14.x;
      }
      r11.xyz = cb0[82].xyz * r11.xyz;
      r13.xyz = r11.xyz * r5.www + r13.xyz;
      r13.w = r14.x * r5.w + r13.w;
      r1.w = r5.w + r1.w;
    }
    r2.w = (int)r2.w + 1;
  }
  r0.x = cmp(0 < r0.w);
  r2.xyzw = r13.xyzw / r0.wwww;
  r0.xyzw = r0.xxxx ? r2.xyzw : r13.xyzw;
  r1.x = cmp(r1.w < 9.99999975e-06);
  if (r1.x != 0) {
    r1.xyz = trunc(cb0[93].zxy);
    r1.y = r1.z * cb0[89].w + r1.y;
    r1.x = cb0[91].w * r1.y + r1.x;
    r1.x = asuint(t87[(int)r1.x].val[0/4]) & 0x0007ffffu;
    if (r10.x != 0) {
      r1.y = mad((int)r1.x, 7, 1);
      r2.x = t88[r1.y].val[0/4];
      r2.y = t88[r1.y].val[0/4+1];
      r2.z = t88[r1.y].val[0/4+2];
      r2.w = t88[r1.y].val[0/4+3];
      r3.xyzw = r2.xyzw * r6.xxxx;
      r2.xyz = cb0[94].xyz * r3.www + r3.xyz;
      r0.w = r2.w * r6.x + r0.w;
    } else {
      r2.xyz = float3(0,0,0);
    }
    if (r10.y != 0) {
      r1.y = mad((int)r1.x, 7, 2);
      r3.x = t88[r1.y].val[0/4];
      r3.y = t88[r1.y].val[0/4+1];
      r3.z = t88[r1.y].val[0/4+2];
      r3.w = t88[r1.y].val[0/4+3];
      r1.y = r3.w * r6.y;
      r3.xyz = r3.xyz * r6.yyy + r2.xyz;
      r2.xyz = cb0[95].xyz * r1.yyy + r3.xyz;
      r0.w = r3.w * r6.y + r0.w;
    }
    if (r9.x != 0) {
      r1.y = mad((int)r1.x, 7, 3);
      r3.x = t88[r1.y].val[0/4];
      r3.y = t88[r1.y].val[0/4+1];
      r3.z = t88[r1.y].val[0/4+2];
      r3.w = t88[r1.y].val[0/4+3];
      r1.y = r3.w * r7.x;
      r3.xyz = r3.xyz * r7.xxx + r2.xyz;
      r2.xyz = cb0[96].xyz * r1.yyy + r3.xyz;
      r0.w = r3.w * r7.x + r0.w;
    }
    if (r9.y != 0) {
      r1.y = mad((int)r1.x, 7, 4);
      r3.x = t88[r1.y].val[0/4];
      r3.y = t88[r1.y].val[0/4+1];
      r3.z = t88[r1.y].val[0/4+2];
      r3.w = t88[r1.y].val[0/4+3];
      r1.y = r3.w * r7.y;
      r3.xyz = r3.xyz * r7.yyy + r2.xyz;
      r2.xyz = cb0[97].xyz * r1.yyy + r3.xyz;
      r0.w = r3.w * r7.y + r0.w;
    }
    if (r9.z != 0) {
      r1.y = mad((int)r1.x, 7, 5);
      r3.x = t88[r1.y].val[0/4];
      r3.y = t88[r1.y].val[0/4+1];
      r3.z = t88[r1.y].val[0/4+2];
      r3.w = t88[r1.y].val[0/4+3];
      r1.y = r3.w * r7.z;
      r3.xyz = r3.xyz * r7.zzz + r2.xyz;
      r2.xyz = cb0[98].xyz * r1.yyy + r3.xyz;
      r0.w = r3.w * r7.z + r0.w;
    }
    if (r10.z != 0) {
      r1.x = mad((int)r1.x, 7, 6);
      r3.x = t88[r1.x].val[0/4];
      r3.y = t88[r1.x].val[0/4+1];
      r3.z = t88[r1.x].val[0/4+2];
      r3.w = t88[r1.x].val[0/4+3];
      r1.x = r3.w * r6.z;
      r3.xyz = r3.xyz * r6.zzz + r2.xyz;
      r2.xyz = cb0[99].xyz * r1.xxx + r3.xyz;
      r0.w = r3.w * r6.z + r0.w;
    }
    r0.xyz = cb0[82].xyz * r2.xyz;
  } else {
    r0.xyzw = r0.xyzw / r1.wwww;
  }
  o0.w = 0.100000001 + r0.w;
  r0.w = cmp(0 != cb0[101].x);
  if (r0.w != 0) {
    r0.w = t28.SampleLevel(s1_s, float2(0.5,0.5), 0).x;
  } else {
    r0.w = cb0[107].y;
  }
  o0.xyz = r0.xyz * r0.www;
  return;
}