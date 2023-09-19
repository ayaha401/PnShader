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
                useOutlineFoldout = material.GetInt(PnSpriteSimpleLitPropNames.USE_OUTLINE_PROP_NAME) == 1 ? true : false;
                useOutlineFoldout = PnCustomUI.ToggleFoldout("Outline", useOutlineFoldout);
                if (useOutlineFoldout)
                {
                    material.SetInt(PnSpriteSimpleLitPropNames.USE_OUTLINE_PROP_NAME, 1);
                    using (new EditorGUILayout.VerticalScope(GUI.skin.box))
                    {
                        materialEditor.ShaderProperty(outlineColor, new GUIContent("OutlineColor"));
                        materialEditor.ShaderProperty(hideOutlineColor, new GUIContent("HideOutlineColor"));
                    }
                }
                else
                {
                    material.SetInt(PnSpriteSimpleLitPropNames.USE_OUTLINE_PROP_NAME, 0);
                }
            }

            PnCustomUI.Title("Billboard");
            using (new EditorGUILayout.VerticalScope(GUI.skin.box))
            {
                bool useBillboardToggle = material.GetInt(PnSpriteSimpleLitPropNames.USE_BILLBOARD_PROP_NAME) == 1 ? true : false;
                useBillboardToggle = GUILayout.Toggle(useBillboardToggle, new GUIContent("Use Billboard"));
                material.SetInt(PnSpriteSimpleLitPropNames.USE_BILLBOARD_PROP_NAME, Convert.ToInt32(useBillboardToggle));
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
            mainTex = FindProperty(PnSpriteSimpleLitPropNames.MAIN_TEX_PROP_NAME, _Prop, false);
            subTex = FindProperty(PnSpriteSimpleLitPropNames.SUB_TEX_PROP_NAME, _Prop, false);

            // Outline
            useOutline = FindProperty(PnSpriteSimpleLitPropNames.USE_OUTLINE_PROP_NAME, _Prop, false);
            outlineColor = FindProperty(PnSpriteSimpleLitPropNames.OUTLINE_COLOR_PROP_NAME, _Prop, false);
            hideOutlineColor = FindProperty(PnSpriteSimpleLitPropNames.HIDE_OUTLINE_COLOR_PROP_NAME, _Prop, false);

            // Stencil
            hideColor = FindProperty(PnSpriteSimpleLitPropNames.HIDE_COLOR_PROP_NAME, _Prop, false);
            stencilNum = FindProperty(PnSpriteSimpleLitPropNames.STENCIL_NUM_PROP_NAME, _Prop, false);
            stencilCompMode = FindProperty(PnSpriteSimpleLitPropNames.STENCIL_COMP_MODE_PROP_NAME, _Prop, false);
            stencilOp = FindProperty(PnSpriteSimpleLitPropNames.STENCIL_OP_PROP_NAME, _Prop, false);
        }
    }

}
