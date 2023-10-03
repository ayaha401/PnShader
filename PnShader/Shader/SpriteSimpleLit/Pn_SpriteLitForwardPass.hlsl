#ifndef PN_SPRITE_SIMPLELIT_FORWARDPASS
#define PN_SPRITE_SIMPLELIT_FORWARDPASS

Varyings UnlitVertex(Attributes v)
{
    Varyings o = (Varyings)0;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    
    // Billboard
    o.positionCS = Billboard(_UseBillboard, v.positionOS);
    
    #if defined(DEBUG_DISPLAY)
    o.positionWS = TransformObjectToWorld(v.positionOS);
    #endif
    
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    o.color = v.color * _Color * _RendererColor;
    o.color.rgb *= _MainLightColor.rgb;
    return o;
}

float4 UnlitFragment(Varyings i) : SV_Target
{
    // Main
    float4 mainTex = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv);

    // Outline
    float4 outlineCol = float4(0, 0, 0, 0);
    if(_UseOutline)
    {                    
        float width = max(_Width, 0.0) / _WidthMult;
        float outline = Outline(_MainTex, sampler_MainTex, i.uv, mainTex.a, width);
        outlineCol.rgb = outline.xxx * _OutlineColor.rgb;
        outlineCol.a = outline.x * _OutlineColor.a * i.color.a;
    }

    // LastColor
    float alpha = (mainTex.a * i.color.a) + outlineCol.a;
    float3 lastColor = (mainTex.rgb * i.color.rgb) + outlineCol;

    #if defined(DEBUG_DISPLAY)
    SurfaceData2D surfaceData;
    InputData2D inputData;
    half4 debugColor = 0;

    InitializeSurfaceData(mainTex.rgb, mainTex.a, surfaceData);
    InitializeInputData(i.uv, inputData);
    SETUP_DEBUG_DATA_2D(inputData, i.positionWS);

    if (CanDebugOverrideOutputColor(surfaceData, inputData, debugColor))
    {
        return debugColor;
    }
    #endif

    return float4(lastColor, alpha);
}

#endif