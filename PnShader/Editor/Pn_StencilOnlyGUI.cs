using UnityEngine;
using UnityEditor;
using System;

namespace AyahaShader.Pn
{
    public class Pn_StencilOnlyGUI : ShaderGUI
    {
        // Stencil
        private MaterialProperty stencilNum;
        private MaterialProperty stencilCompMode;
        private MaterialProperty stencilOp;

        private bool isBaseUi = true;

        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] prop)
        {
            var material = (Material)materialEditor.target;

            // シェーダーのバージョンを表記
            PnCustomUI.Information();

            PnCustomUI.GUIPartition();

            // 初期状態のGUIを表示させる
            if (isBaseUi)
            {
                base.OnGUI(materialEditor, prop);
                return;
            }
        }
    }
}
