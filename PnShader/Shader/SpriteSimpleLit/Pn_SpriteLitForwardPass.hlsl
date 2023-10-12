#ifndef PN_SPRITE_SIMPLELIT_FORWARDPASS
#define PN_SPRITE_SIMPLELIT_FORWARDPASS

Varyings UnlitVertex(Attributes v)
{
    Varyings o = (Varyings)0;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    
    // Billboard
    float4x4 billboardMat = CalcBillboardMat(_UseBillboard);
    o.positionWS = mul(billboardMat, float4(v.positionOS.xyz, 1.0));
    
    // Vertex
    o.positionCS = Billboard(_UseBillboard, v.positionOS);
    
    // UV
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);

    // Color
    o.color = v.color * _Color * _RendererColor;

    // Lighting
    float3 dlColor = _MainLightColor.rgb;
    float3 dlColorHSV = RGBtoHSV(dlColor);
    dlColorHSV.z = lerp(dlColorHSV.z, 1.0, _DirectionalLightPower);
    dlColorHSV.z = PN_COMPARE_EPS(dlColorHSV.z);
    dlColor = HSVtoRGB(dlColorHSV);
    o.color.rgb *= dlColor;

    return o;
}

float4 UnlitFragment(Varyings i) : SV_Target
{
    // Main
    float4 mainTex = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv);

    // Lighting
    float3 pixelLightColor = (float3)0.0;
    uint pixelLightCount = GetAdditionalLightsCount();
    for (uint lightIndex = 0u; lightIndex < pixelLightCount; ++lightIndex)
    {
        Light light = GetAdditionalLight(lightIndex, i.positionWS);
        float distanceAttenuation = lerp(0.0, PN_COMPARE_EPS(_PixelLightMaxDistAtten), saturate(light.distanceAttenuation));
        pixelLightColor = saturate(pixelLightColor + light.color.rgb * distanceAttenuation * _PixelLightPower);
    }

    // Outline
    float4 outlineCol = (float4)0.0;
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
    lastColor = saturate(lastColor + pixelLightColor);

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