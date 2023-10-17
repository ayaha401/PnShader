#ifndef PN_SPRITE_FUNCTION
#define PN_SPRITE_FUNCTION

// Billboard
// https://gam0022.net/blog/2019/07/23/unity-y-axis-billboard-shader/
// ex) o.positionCS = billboard(_UseBillboard, v.positionOS);
float4 Billboard(int enable, float3 positionOS)
{
    if(enable == 0)
    {
        return TransformObjectToHClip(positionOS);
    }
    else
    {
        // Y Axis Billboard
        float3 viewPos = TransformWorldToView(TransformObjectToWorld((float3)0.0));
        float3 scaleRotatePos = mul((float3x3)unity_ObjectToWorld, positionOS);                
        float3x3 ViewRotateY = float3x3(
            1.0, UNITY_MATRIX_V._m01, 0.0,
            0.0, UNITY_MATRIX_V._m11, 0.0,
            0.0, UNITY_MATRIX_V._m21, -1.0
        );
        viewPos += mul(ViewRotateY, scaleRotatePos);
        
        return mul(UNITY_MATRIX_P, float4(viewPos, 1.0));
    }
}

// https://gam0022.net/blog/2021/12/23/unity-urp-billboard-shader/
float4x4 CalcBillboardMat(int enable)
{
    if(enable == 0)
    {
        return float4x4(1.0, 0.0, 0.0, 0.0,
                        0.0, 1.0, 0.0, 0.0,
                        0.0, 0.0, 1.0, 0.0,
                        0.0, 0.0, 0.0, 1.0);
    }
    else
    {
        float3 yup = float3(0.0, 1.0, 0.0);
        float3 up = mul((float3x3)unity_ObjectToWorld, yup);
        float3 worldPos = unity_ObjectToWorld._m03_m13_m23;
        float3 toCamera = _WorldSpaceCameraPos - worldPos;
        float3 right = normalize(cross(toCamera, up)) * length(unity_ObjectToWorld._m00_m10_m20);
        float3 forward = normalize(cross(up, right)) * length(unity_ObjectToWorld._m02_m12_m22);

        float4x4 mat = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    0, 0, 0, 1,
                };
                mat._m00_m10_m20 = right;
                mat._m01_m11_m21 = up;
                mat._m02_m12_m22 = forward;
                mat._m03_m13_m23 = worldPos;
        return mat;
    }
}

// Outline
// ex) float outline = Outline(_MainTex, sampler_MainTex, i.uv, mainTex.a, width);
float Outline(Texture2D tex, SamplerState state,  float2 uv, float alpha, float2 outlineWidth)
{
    float leftShift = SAMPLE_TEXTURE2D(tex, state, float2(uv.x + outlineWidth.x, uv.y)).a;
    float rightShift = SAMPLE_TEXTURE2D(tex, state, float2(uv.x - outlineWidth.x, uv.y)).a;
    float upShift = SAMPLE_TEXTURE2D(tex, state, float2(uv.x, uv.y + outlineWidth.y)).a;
    float downShift = SAMPLE_TEXTURE2D(tex, state, float2(uv.x, uv.y - outlineWidth.y)).a;

    return saturate((leftShift - alpha) + (rightShift - alpha) + (upShift - alpha) + (downShift - alpha));
}

// https://docs.unity3d.com/ja/Packages/com.unity.shadergraph@10.0/manual/Colorspace-Conversion-Node.html
float3 RGBtoHSV(float3 In)
{
    float4 K = float4(0.0, -0.333333333, 0.666666667, -1.0);
    float4 P = lerp(float4(In.bg, K.wz), float4(In.gb, K.xy), step(In.b, In.g));
    float4 Q = lerp(float4(P.xyw, In.r), float4(In.r, P.yzx), step(P.x, In.r));
    float D = Q.x - min(Q.w, Q.y);
    float  E = 1e-10;
    return float3(abs(Q.z + (Q.w - Q.y)/(6.0 * D + E)), D / (Q.x + E), Q.x);
}

// https://docs.unity3d.com/ja/Packages/com.unity.shadergraph@10.0/manual/Colorspace-Conversion-Node.html
float3 HSVtoRGB(float3 In)
{
    float4 K = float4(1.0, 0.666666667, 0.333333333, 3.0);
    float3 P = abs(frac(In.xxx + K.xyz) * 6.0 - K.www);
    return In.z * lerp(K.xxx, saturate(P - K.xxx), In.y);
}

#endif