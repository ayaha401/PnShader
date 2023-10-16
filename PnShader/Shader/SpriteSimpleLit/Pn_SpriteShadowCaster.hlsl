#ifndef PN_SPRITE_SHADOWCASTER
#define PN_SPRITE_SHADOWCASTER

#include "Assets/AyahaShader/PnShader/Shader/Pn_Macro.hlsl"
#include "Assets/AyahaShader/PnShader/Shader/SpriteSimpleLit/Pn_SpriteFunction.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

float3 _LightDirection;

// Source from ShadowCasterPass.hlsl GetShadowPositionHClip()
float4 GetShadowPositionHClip(Attributes input)
{
    float3 positionWS = TransformObjectToWorld(input.positionOS.xyz);
    float3 normalWS = TransformObjectToWorldNormal(float3(0.0, 1.0, 0.0));
    float4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, _LightDirection));

    #if UNITY_REVERSED_Z
        positionCS.z = min(positionCS.z, positionCS.w * UNITY_NEAR_CLIP_VALUE);
    #else
        positionCS.z = max(positionCS.z, positionCS.w * UNITY_NEAR_CLIP_VALUE);
    #endif
        
    return positionCS;
}

Varyings vert(Attributes v)
{
    Varyings o = (Varyings)0;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    o.color = v.color * _Color;
    o.positionCS = GetShadowPositionHClip(v);

    return o;
}

float4 frag(Varyings i) : SV_Target
{
    float alpha = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv).a * i.color.a;
    clip(alpha - PN_EPS);
    return 0;
}

#endif