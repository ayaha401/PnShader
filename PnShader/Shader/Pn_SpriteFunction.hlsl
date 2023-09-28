#ifndef PN_SPRITE_FUNCTION
#define PN_SPRITE_FUNCTION

// Billboard
// https://gam0022.net/blog/2019/07/23/unity-y-axis-billboard-shader/
// ex) o.positionCS = billboard(_UseBillboard, v.positionOS);
float4 billboard(int enable, float3 positionOS)
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

#endif