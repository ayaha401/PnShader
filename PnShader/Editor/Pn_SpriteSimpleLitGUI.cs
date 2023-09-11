using UnityEngine;
using UnityEditor;

namespace AyahaShader.Pn
{
    public class Pn_SpriteSimpleLitGUI : ShaderGUI
    {
        // Main
        private MaterialProperty mainTex;

        // Stencil
        private MaterialProperty hideColor;
        private MaterialProperty stencilNum;
        private MaterialProperty stencilCompMode;
        private MaterialProperty stencilOp;

        private bool isBaseUi = false;
        private bool advancedSettingsFoldout = false;

        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] prop)
        {
            var material = (Material)materialEditor.target;
            FindProperties(prop);

            // シェーダーのバージョンを表記
            PnCustomUI.Information();

            PnCustomUI.GUIPartition();

            // 初期状態のGUIを表示させる
            if(isBaseUi)
            {
                base.OnGUI(materialEditor, prop);
                return;
            }

            PnCustomUI.Title("Main");
            using (new EditorGUILayout.VerticalScope(GUI.skin.box))
            {
                materialEditor.TextureProperty(mainTex, "MainTex");
                materialEditor.ColorProperty(hideColor, "HideColor");
            }

            PnCustomUI.GUIPartition();

            // アドバイス設定
            advancedSettingsFoldout = PnCustomUI.Foldout("Advanced Settings", advancedSettingsFoldout);
            if (advancedSettingsFoldout)
            {
                // Stencil
                PnCustomUI.Title("Stencil");
                using (new EditorGUILayout.VerticalScope(GUI.skin.box))
                {
                    materialEditor.ShaderProperty(stencilNum, new GUIContent("Stencil Number"));
                    materialEditor.ShaderProperty(stencilCompMode, new GUIContent("Stencil CompMode"));
                    materialEditor.ShaderProperty(stencilOp, new GUIContent("Stencil Operation"));
                }
            }
        }

        private void FindProperties(MaterialProperty[] _Prop)
        {
            // Main
            mainTex = FindProperty("_MainTex", _Prop, false);

            // Stencil
            hideColor = FindProperty("_HideColor", _Prop, false);
            stencilNum = FindProperty("_StencilNum", _Prop, false);
            stencilCompMode = FindProperty("_StencilCompMode", _Prop, false);
            stencilOp = FindProperty("_StencilOp", _Prop, false);
        }
    }

}
