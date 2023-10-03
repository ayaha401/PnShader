#ifndef PN_SPRITE_SIMPLELIT_CORE_INCLUDED
#define PN_SPRITE_SIMPLELIT_CORE_INCLUDED

#include "Assets/AyahaShader/PnShader/Shader/Pn_Macro.hlsl"
#include "Assets/AyahaShader/PnShader/Shader/SpriteSimpleLit/Pn_SpriteFunction.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

// Texture
TEXTURE2D(_MainTex);
SAMPLER(sampler_MainTex);

// Main
uniform half4 _MainTex_ST;
uniform float4 _Color;
uniform half4 _RendererColor;
uniform float _lightMaxDistAtten;
uniform float _pixelLightPower;
uniform float _directionalLightPower;

// Outline
uniform int _UseOutline;
uniform float4 _OutlineColor;
uniform float _Width;
uniform float _WidthMult;

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
    float3  positionWS  : TEXCOORD2;
    #if defined(DEBUG_DISPLAY)
    
    #endif
    UNITY_VERTEX_OUTPUT_STEREO
};

#endif