#ifndef PN_SPRITE_SIMPLELIT_CORE_INCLUDED
#define PN_SPRITE_SIMPLELIT_CORE_INCLUDED

#include "Assets/AyahaShader/PnShader/Shader/Pn_Macro.hlsl"
#include "Assets/AyahaShader/PnShader/Shader/SpriteSimpleLit/Pn_SpriteFunction.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

// Texture
TEXTURE2D(_MainTex);
SAMPLER(sampler_MainTex);

CBUFFER_START(UnityPerMaterial)

// Main
uniform half4 _MainTex_ST;
uniform float4 _MainTex_TexelSize;
uniform float4 _Color;
uniform float4 _HideColor;
uniform half4 _RendererColor;
uniform float _DirectionalLightPower;
uniform float _PixelLightMaxDistAtten;
uniform float _PixelLightPower;

// Outline
uniform int _UseOutline;
uniform float4 _OutlineColor;
uniform float _Width;
uniform float _WidthMult;
uniform float4 _HideOutlineColor;

// Billboard
uniform int _UseBillboard;

CBUFFER_END

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
#ifdef PN_SPRITE_SIMPLELIT_UNIVERSAL
    float3  positionWS  : TEXCOORD2;
#endif
    UNITY_VERTEX_OUTPUT_STEREO
};

#endif