#ifndef PN_SPRITE_SIMPLELIT_CORE_INCLUDED
#define PN_SPRITE_SIMPLELIT_CORE_INCLUDED

// Texture
TEXTURE2D(_MainTex);
SAMPLER(sampler_MainTex);
TEXTURE2D(_SubTex);

// Main
uniform half4 _MainTex_ST;
uniform float4 _Color;
uniform half4 _RendererColor;

// Outline
uniform int _UseOutline;
uniform float4 _OutlineColor;

// Billboard
uniform int _UseBillboard;

struct Attributes
{
    float3 positionOS   : POSITION;
    float4 color        : COLOR;
    float2 uv           : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct Varyings
{
    float4  positionCS  : SV_POSITION;
    half4   color       : COLOR;
    float2  uv          : TEXCOORD0;
    #if defined(DEBUG_DISPLAY)
    float3  positionWS  : TEXCOORD2;
    #endif
    UNITY_VERTEX_OUTPUT_STEREO
};

#endif