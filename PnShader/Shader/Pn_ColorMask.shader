Shader "Universal Render Pipeline/Pn/ColorMask"
{
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

        Pass
        {
            Name "ColorMask"
        }
    }
}
