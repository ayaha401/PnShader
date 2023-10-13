Shader "Universal Render Pipeline/Pn/MoveArea"
{
    Properties
    {
        // MoveArea
        _Radius("Radius", Range(0.0, 1.0)) = 0.5
        _LineWidth("Line Width", Range(0.0, 1.0)) = 0.03
        _ObjCrossLineWidth("ObjCrossLine Width", Range(0.0, 1.0)) = 0.25
        _OutlineColor("Outline Color", Color) = (0, 0.25, 0.75, 1.0)
        _MoveableColor("Moveable Color", Color) = (0, 0.6, 0.75, 1.0)
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "RenderPipeline" = "UniversalPipeline"
        }

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite On

        Pass
        {
            Name "Universal2D"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/SimpleLitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Assets/AyahaShader/PnShader/Shader/Pn_Macro.hlsl"
            #include "Assets/AyahaShader/PnShader/Shader/Pn_SDF.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
                float3 positionVS : TEXCOORD2;
                float3 positionWS : TEXCOORD3;
            };
            
            CBUFFER_START(UnityPerMaterial)
            uniform float _Radius;
            uniform float _LineWidth;
            uniform float _ObjCrossLineWidth;
            uniform float4 _OutlineColor;
            uniform float4 _MoveableColor;
            CBUFFER_END

            Varyings vert(Attributes v)
            {
                Varyings o = (Varyings)0;

                VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS.xyz);
                o.positionHCS = vertexInput.positionCS;
                o.positionVS = vertexInput.positionVS;
                o.screenPos = vertexInput.positionNDC;
                o.positionWS = vertexInput.positionWS;
                o.uv = v.uv;
                return o;
            }

            float4 frag(Varyings i) : SV_Target
            {
                // Calc Circle===============================================
                float2 sdfuv = i.uv * 2.0 - 1.0;
                float d0 = sdCircle(sdfuv, _Radius);
                // 割合でアウトラインが変化する方法
                // float d1 = sdCircle(sdfuv, saturate(_Radius - (_Radius * _LineWidth)));
                // 割合でアウトラインが変化しない方法 
                float d1 = sdCircle(sdfuv, saturate(_Radius - _LineWidth));      
                // Calc Circle===============================================

                // Depth
                float2 screenUV = i.screenPos.xy / i.screenPos.w;
                float depth = _CameraDepthTexture.Sample(sampler_CameraDepthTexture, screenUV).r;
                depth = LinearEyeDepth(depth, _ZBufferParams);
                float screenDepth = depth - i.screenPos.w;
                float fragmentEyeDepth = -i.positionVS.z;
                float rawDepth = SampleSceneDepth(screenUV);
                float orthoLinearDepth = _ProjectionParams.x > 0.0 ? rawDepth : 1.0 - rawDepth;
                float sceneEyeDepth = lerp(_ProjectionParams.y, _ProjectionParams.z, orthoLinearDepth);
                
                // depthDifference
                float depthDifference = 1.0 - saturate((sceneEyeDepth - fragmentEyeDepth) * 1.);
                float objCrossOutline = step(depthDifference, 1.0 - _ObjCrossLineWidth);
                
                // Calc MoveArea
                float outlineCircle = step(PN_EPS, -d1);
                float moveArea = outlineCircle * objCrossOutline;
                float3 moveAreaColor = lerp(_OutlineColor.rgb, _MoveableColor.rgb, moveArea);
                float alpha = step(d0, PN_EPS);
                clip(alpha - PN_EPS);
                alpha *= moveArea;
                alpha = lerp(_OutlineColor.a, _MoveableColor.a, alpha);
                return float4(moveAreaColor, alpha);
            }
            ENDHLSL
        }
    }
    CustomEditor "AyahaShader.Pn.Pn_MoveAreaGUI"
}
