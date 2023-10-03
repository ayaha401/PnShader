Shader "Universal Render Pipeline/Pn/SpriteSimpleLit"
{
    Properties
    {
        // Main
        _MainTex("Sprite Texture", 2D) = "white" {}

        // Outline
        _UseOutline("Use Outline", int) = 0
        _OutlineColor("Outline Color", Color) = (1,1,1,1)
        _HideOutlineColor("Hide Outline Color", Color) = (1,1,1,1)
        _Width("Width", float) = 0.5
        _WidthMult("Width Mult", float) = 10

        // Billboard
        _UseBillboard("Use Billboard", int) = 0
        
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

        // Pass
        // {
        //     Name "Universal2D"
        //     Tags
        //     {
        //         "LightMode" = "Universal2D" 
        //     }

        //     HLSLPROGRAM
        //     #pragma vertex UnlitVertex
        //     #pragma fragment UnlitFragment
        //     #pragma multi_compile _ DEBUG_DISPLAY
        //     #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        //     #if defined(DEBUG_DISPLAY)
        //     #include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/InputData2D.hlsl"
        //     #include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/SurfaceData2D.hlsl"
        //     #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Debug/Debugging2D.hlsl"
        //     #endif
        //     #include "Assets/AyahaShader/PnShader/Shader/SpriteSimpleLit/Pn_SpriteSimpleLitCore.hlsl"
        //     #include "Assets/AyahaShader/PnShader/Shader/SpriteSimpleLit/Pn_SpriteFunction.hlsl"
        //     #include "Assets/AyahaShader/PnShader/Shader/SpriteSimpleLit/Pn_SpriteLitForwardPass.hlsl"

        //     ENDHLSL
        // }

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
            #include "Assets/AyahaShader/PnShader/Shader/SpriteSimpleLit/Pn_SpriteSimpleLitCore.hlsl"
            #include "Assets/AyahaShader/PnShader/Shader/SpriteSimpleLit/Pn_SpriteFunction.hlsl"
            #include "Assets/AyahaShader/PnShader/Shader/SpriteSimpleLit/Pn_SpriteLitForwardPass.hlsl"

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
            #include "Assets/AyahaShader/PnShader/Shader/SpriteSimpleLit/Pn_SpriteFunction.hlsl"

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

            // Main
            uniform float4 _MainTex_ST;
            uniform float4 _HideColor;

            // HideOutline
            uniform int _UseOutline;
            uniform float4 _HideOutlineColor;
            uniform float _Width;
            uniform float _WidthMult;
            
            // Billboard
            uniform int _UseBillboard;

            Varyings UnlitVertex(Attributes v)
            {
                Varyings o = (Varyings)0;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                // Billboard
                o.positionCS = Billboard(_UseBillboard, v.positionOS);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
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
                    outlineCol.rgb = outline.xxx * _HideOutlineColor.rgb;
                    outlineCol.a = outline.x * _HideOutlineColor.a * i.color.a;
                }

                // LastColor
                float4 lastCol = float4(_HideColor.rgb + outlineCol.rgb, mainTex.a * i.color.a + outlineCol.a);
                return lastCol;
            }

            ENDHLSL
        }
    }

    Fallback "Sprites/Default"
    CustomEditor "AyahaShader.Pn.Pn_SpriteSimpleLitGUI"
}
