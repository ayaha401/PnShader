#ifndef PN_SDF
#define PN_SDF

float sdCircle(float2 p, float r)
{
    return length(p) - r;
}

float opUni( float d1, float d2 ) 
{
    return min(d1,d2); 
}

float opSub( float d1, float d2 )
{
    return max(-d1,d2); 
}

float opInt( float d1, float d2 ) 
{
    return max(d1,d2); 
}

#endif