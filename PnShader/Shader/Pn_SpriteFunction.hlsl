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
        // AllAxis Billboard
        float3 viewPos = TransformWorldToView(TransformObjectToWorld(float3(0,0,0)));
        float3 scaleRotatePos = mul((float3x3)unity_ObjectToWorld, positionOS);
        viewPos += float3(scaleRotatePos.xy, -scaleRotatePos.z);
        return mul(UNITY_MATRIX_P, float4(viewPos, 1));
    }
}

#endif