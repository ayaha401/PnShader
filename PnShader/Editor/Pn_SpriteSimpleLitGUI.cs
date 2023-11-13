using UnityEngine;
using UnityEditor;
using System;

namespace AyahaShader.Pn
{
    public class Pn_SpriteSimpleLitGUI : ShaderGUI
    {
        // Main
        private MaterialProperty mainTex;
        private MaterialProperty directionalLightPower;
        private MaterialProperty pixelLightMaxDistAtten;
        private MaterialProperty pixelLightPower;
        private MaterialProperty fillColor;
        private MaterialProperty fillColorMix;

        // Outline
        private MaterialProperty useOutline;
        private MaterialProperty outlineColor;
        private MaterialProperty hideOutlineColor;
        private MaterialProperty width;
        private MaterialProperty widthMult;

        // Stencil
        private StensilType stensilType = StensilType.Default;
        private MaterialProperty stencilPreset;
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

            // 初期状態のGUIを表示させる
            if (isBaseUi)
            {
                base.OnGUI(materialEditor, prop);
                return;
            }

            PnCustomUI.Title("Main");
            using (new EditorGUILayout.VerticalScope(GUI.skin.box))
            {
                materialEditor.TextureProperty(mainTex, "MainTex");
                materialEditor.ColorProperty(hideColor, "HideColor");
                materialEditor.ShaderProperty(directionalLightPower, new GUIContent("DirectionalLight Power"));
                materialEditor.ShaderProperty(pixelLightMaxDistAtten, new GUIContent("PixelLight Max Distance Attenuation"));
                materialEditor.ShaderProperty(pixelLightPower, new GUIContent("PixelLight Power"));
                materialEditor.ShaderProperty(fillColor, "Fill Color");
                materialEditor.ShaderProperty(fillColorMix, "Fill Color Mix");
            }

            if (useOutline != null)
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
                        materialEditor.ShaderProperty(width, new GUIContent("Width"));
                        materialEditor.ShaderProperty(widthMult, new GUIContent("Width Multiply"));
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

            // アドバンス設定
            advancedSettingsFoldout = PnCustomUI.Foldout("Advanced Settings", advancedSettingsFoldout);
            if (advancedSettingsFoldout)
            {
                // Stencil
                if (stencilPreset != null)
                {
                    stensilType = (StensilType)material.GetInt("_StencilPreset");
                    StencilParams stencilParams = new StencilParams(stencilNum, stencilCompMode, stencilOp);
                    PnCustomUI.StencilPreset(ref stensilType, stencilParams, material, materialEditor);
                }

                // RenderQueue
                PnCustomUI.RenderQueue(materialEditor);
            }
        }

        private void FindProperties(MaterialProperty[] _Prop)
        {
            // Main
            mainTex = FindProperty(PnSpriteSimpleLitPropNames.MAIN_TEX_PROP_NAME, _Prop, false);
            directionalLightPower = FindProperty("_DirectionalLightPower", _Prop, false);
            pixelLightMaxDistAtten = FindProperty("_PixelLightMaxDistAtten", _Prop, false);
            pixelLightPower = FindProperty("_PixelLightPower", _Prop, false);
            fillColor = FindProperty("_FillColor", _Prop, false);
            fillColorMix = FindProperty("_FillColorMix", _Prop, false);

            // Outline
            useOutline = FindProperty(PnSpriteSimpleLitPropNames.USE_OUTLINE_PROP_NAME, _Prop, false);
            outlineColor = FindProperty(PnSpriteSimpleLitPropNames.OUTLINE_COLOR_PROP_NAME, _Prop, false);
            hideOutlineColor = FindProperty(PnSpriteSimpleLitPropNames.HIDE_OUTLINE_COLOR_PROP_NAME, _Prop, false);
            width = FindProperty("_Width", _Prop, false);
            widthMult = FindProperty("_WidthMult", _Prop, false);

            // Stencil
            stencilPreset = FindProperty("_StencilPreset", _Prop, false);
            hideColor = FindProperty(PnSpriteSimpleLitPropNames.HIDE_COLOR_PROP_NAME, _Prop, false);
            stencilNum = FindProperty(PnSpriteSimpleLitPropNames.STENCIL_NUM_PROP_NAME, _Prop, false);
            stencilCompMode = FindProperty(PnSpriteSimpleLitPropNames.STENCIL_COMP_MODE_PROP_NAME, _Prop, false);
            stencilOp = FindProperty(PnSpriteSimpleLitPropNames.STENCIL_OP_PROP_NAME, _Prop, false);
        }
    }

}
