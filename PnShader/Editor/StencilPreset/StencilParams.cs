using UnityEditor;

namespace AyahaShader.Pn
{
    public struct StencilParams
    {
        public MaterialProperty stencilNum;
        public MaterialProperty stencilCompMode;
        public MaterialProperty stencilOp;

        public StencilParams(MaterialProperty stencilNum, MaterialProperty stencilCompMode, MaterialProperty stencilOp)
        {
            this.stencilNum = stencilNum;
            this.stencilCompMode = stencilCompMode;
            this.stencilOp = stencilOp;
        }
    }
}
