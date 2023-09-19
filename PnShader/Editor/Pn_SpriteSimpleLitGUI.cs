using UnityEngine;
using UnityEditor;
using System;

namespace AyahaShader.Pn
{
    public class Pn_SpriteSimpleLitGUI : ShaderGUI
    {
        // Main
        private MaterialProperty mainTex;
        private MaterialProperty subTex;

        // Outline
        private MaterialProperty useOutline;
        private MaterialProperty outlineColor;
        private MaterialProperty hideOutlineColor;

        // Stencil
        private MaterialProperty hideColor;
        private MaterialProperty stencilNum;
        private MaterialProperty stencilCompMode;
        private MaterialProperty stencilOp;

        // Billboard
        private MaterialProperty useBillboard;

        private bool isBaseUi = false;
        private bool useOutlineFoldout = false;
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
                materialEditor.TextureProperty(subTex, "SubTex");
                materialEditor.ColorProperty(hideColor, "HideColor");
            }

            if(useOutline != null)
            {
                useOutlineFoldout = material.GetInt("_UseOutline") == 1 ? true : false;
                useOutlineFoldout = PnCustomUI.ToggleFoldout("Outline", useOutlineFoldout);
                if (useOutlineFoldout)
                {
                    material.SetInt("_UseOutline", 1);
                    using (new EditorGUILayout.VerticalScope(GUI.skin.box))
                    {
                        materialEditor.ShaderProperty(outlineColor, new GUIContent("OutlineColor"));
                        materialEditor.ShaderProperty(hideOutlineColor, new GUIContent("HideOutlineColor"));
                    }
                }
                else
                {
                    material.SetInt("_UseOutline", 0);
                }
            }

            PnCustomUI.Title("Billboard");
            using (new EditorGUILayout.VerticalScope(GUI.skin.box))
            {
                bool useBillboardToggle = material.GetInt("_UseBillboard") == 1 ? true : false;
                useBillboardToggle = GUILayout.Toggle(useBillboardToggle, new GUIContent("Use Billboard"));
                material.SetInt("_UseBillboard", Convert.ToInt32(useBillboardToggle));
            }


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
            subTex = FindProperty("_SubTex", _Prop, false);

            // Outline
            useOutline = FindProperty("_UseOutline", _Prop, false);
            outlineColor = FindProperty("_OutlineColor", _Prop, false);
            hideOutlineColor = FindProperty("_HideOutlineColor", _Prop, false);

            // Stencil
            hideColor = FindProperty("_HideColor", _Prop, false);
            stencilNum = FindProperty("_StencilNum", _Prop, false);
            stencilCompMode = FindProperty("_StencilCompMode", _Prop, false);
            stencilOp = FindProperty("_StencilOp", _Prop, false);

            // Billboard
            useBillboard = FindProperty("_UseBillboard", _Prop, false);
        }
    }

}
