Shader "Universal Render Pipeline/Pn/SpriteSimpleLit"
{
    Properties
    {
        // Main
        _MainTex("Sprite Texture", 2D) = "white" {}
        _SubTex("Sub Texture", 2D) = "black" {}

        // Outline
        _UseOutline("Use Outline", int) = 0
        _OutlineColor("Outline Color", Color) = (1,1,1,1)

        // Stencil
        _HideColor("Hide Color", Color) = (1,1,1,1)
        _StencilNum("Stencil Number", int) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)]_StencilCompMode("Stencil CompMode", int) = 0
        [Enum(UnityEngine.Rendering.StencilOp)]_StencilOp("Stencil Operation", int) = 0

        // Legacy properties. They're here so that materials using this shader can gracefully fallback to the legacy sprite shader.
        [HideInInspector] _Color("Tint", Color) = (1,1,1,1)
        [HideInInspector] PixelSnap("Pixel snap", Float) = 0
        [HideInInspector] _RendererColor("RendererColor", Color) = (1,1,1,1)
        [HideInInspector] _Flip("Flip", Vector) = (1,1,1,1)
        [HideInInspector] _AlphaTex("External Alpha", 2D) = "white" {}
        [HideInInspector] _EnableExternalAlpha("Enable External Alpha", Float) = 0
    }

        SubShader
        {
            Tags 
            {
                "Queue" = "Transparent" 
                "RenderType" = "Transparent" 
                "RenderPipeline" = "UniversalPipeline" 
            }

            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off

            Pass
            {
                Name "Universal2D"
                Tags
                {
                    "LightMode" = "Universal2D" 
                }

                HLSLPROGRAM
                #pragma vertex UnlitVertex
                #pragma fragment UnlitFragment
                #pragma multi_compile _ DEBUG_DISPLAY
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                #if defined(DEBUG_DISPLAY)
                #include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/InputData2D.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/SurfaceData2D.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Debug/Debugging2D.hlsl"
                #endif
                #include "Assets/AyahaShader/PnShader/Shader/Pn_SpriteSimpleLitCore.hlsl"

                Varyings UnlitVertex(Attributes v)
                {
                    Varyings o = (Varyings)0;
                    UNITY_SETUP_INSTANCE_ID(v);
                    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                    o.positionCS = TransformObjectToHClip(v.positionOS);
                    #if defined(DEBUG_DISPLAY)
                    o.positionWS = TransformObjectToWorld(v.positionOS);
                    #endif
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    o.color = v.color * _Color * _RendererColor;
                    return o;
                }

                half4 UnlitFragment(Varyings i) : SV_Target
                {
                    // Main
                    float4 mainTex = i.color * SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv);
                    
                    // Outline
                    const float outline = SAMPLE_TEXTURE2D(_SubTex, sampler_MainTex, i.uv).r;
                    float3 outlineCol = (outline.xxx * _OutlineColor) * _UseOutline;
                    float outlineAlpha = (outline * _OutlineColor.a) * _UseOutline;

                    // LastColor
                    float4 lastCol = float4(mainTex.rgb + outlineCol, mainTex.a * i.color.a + outlineAlpha);

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

                    return lastCol;
                }
                ENDHLSL
            }

            Pass
            {
                Name "UniversalForward"
                Tags 
                { 
                    "LightMode" = "UniversalForward"
                    "Queue" = "Transparent"
                    "RenderType" = "Transparent"
                }

                HLSLPROGRAM
                #pragma vertex UnlitVertex
                #pragma fragment UnlitFragment
                #pragma multi_compile_fragment _ DEBUG_DISPLAY
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                #if defined(DEBUG_DISPLAY)
                #include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/InputData2D.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/SurfaceData2D.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Debug/Debugging2D.hlsl"
                #endif
                #include "Assets/AyahaShader/PnShader/Shader/Pn_SpriteSimpleLitCore.hlsl"

                Varyings UnlitVertex(Attributes attributes)
                {
                    Varyings o = (Varyings)0;
                    UNITY_SETUP_INSTANCE_ID(attributes);
                    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                    o.positionCS = TransformObjectToHClip(attributes.positionOS);
                    #if defined(DEBUG_DISPLAY)
                    o.positionWS = TransformObjectToWorld(attributes.positionOS);
                    #endif
                    o.uv = TRANSFORM_TEX(attributes.uv, _MainTex);
                    o.color = attributes.color * _Color * _RendererColor;
                    return o;
                }

                float4 UnlitFragment(Varyings i) : SV_Target
                {
                    // Main
                    float4 mainTex = i.color * SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv);

                    // Outline
                    float outline = SAMPLE_TEXTURE2D(_SubTex, sampler_MainTex, i.uv).r;
                    float3 outlineCol = (outline.xxx * _OutlineColor) * _UseOutline;
                    float outlineAlpha = (outline * _OutlineColor.a) * _UseOutline;

                    // LastColor
                    float4 lastCol = float4(mainTex.rgb + outlineCol, mainTex.a * i.color.a + outlineAlpha);

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

                    return lastCol;
                }
                ENDHLSL
            }

            Pass
            {
                Name "Stencil_Pass"
                Tags
                {
                    "LightMode" = "SRPDefaultUnlit"
                    "Queue" = "Transparent"
                    "RenderType" = "Transparent"
                }

                Blend SrcAlpha OneMinusSrcAlpha
                ZTest Always
                ZWrite Off

                Stencil
                {
                    Ref[_StencilNum]
                    Comp[_StencilCompMode]
                    Pass[_StencilOp]
                }

                HLSLPROGRAM
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                #pragma vertex UnlitVertex
                #pragma fragment UnlitFragment

                struct Attributes
                {
                    float3 positionOS   : POSITION;
                    float4 color        : COLOR;
                    float2 uv           : TEXCOORD0;
                    UNITY_VERTEX_INPUT_INSTANCE_ID
                };

                struct Varyings
                {
                    float4  positionCS      : SV_POSITION;
                    float4  color           : COLOR;
                    float2  uv              : TEXCOORD0;
                    UNITY_VERTEX_OUTPUT_STEREO
                };

                TEXTURE2D(_MainTex);
                SAMPLER(sampler_MainTex);
                TEXTURE2D(_SubTex);

                // Main
                uniform float4 _MainTex_ST;
                uniform float4 _HideColor;

                Varyings UnlitVertex(Attributes attributes)
                {
                    Varyings o = (Varyings)0;
                    UNITY_SETUP_INSTANCE_ID(attributes);
                    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                    o.positionCS = TransformObjectToHClip(attributes.positionOS);
                    o.uv = TRANSFORM_TEX(attributes.uv, _MainTex);
                    o.color = attributes.color;
                    return o;
                }

                float4 UnlitFragment(Varyings i) : SV_Target
                {
                    float4 lastColor = (float4)1.0;
                    float4 mainTex = i.color * SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv);
                    lastColor.rgb = _HideColor.rgb;
                    lastColor.a = mainTex.a;
                    return lastColor;
                }

                ENDHLSL
            }
        }

        Fallback "Sprites/Default"
        CustomEditor "AyahaShader.Pn.Pn_SpriteSimpleLitGUI"
}
