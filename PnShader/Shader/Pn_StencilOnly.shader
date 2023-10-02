Shader "Universal Render Pipeline/Pn/StencilOnly"
{
    Properties
    {
        // Stencil
        _StencilNum("Stencil Number", int) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)]_StencilCompMode("Stencil CompMode", int) = 0
        [Enum(UnityEngine.Rendering.StencilOp)]_StencilOp("Stencil Operation", int) = 0
    }

    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "Queue"="Transparent-2"
        }

        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0

        Stencil
        {
            Ref[_StencilNum]
            Comp[_StencilCompMode]
            Pass[_StencilOp]
        }

        Pass
        {
            Name "StencilOnly"
        }
    }
    CustomEditor "AyahaShader.Pn.Pn_StencilOnlyGUI"
}

