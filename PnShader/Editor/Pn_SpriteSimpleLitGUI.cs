using UnityEngine;
using UnityEditor;

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

            // �V�F�[�_�[�̃o�[�W������\�L
            PnCustomUI.Information();

            PnCustomUI.GUIPartition();

            // ������Ԃ�GUI��\��������
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
                    }
                }
                else
                {
                    material.SetInt("_UseOutline", 0);
                }
            }
            
            

            PnCustomUI.GUIPartition();

            // �A�h�o�C�X�ݒ�
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

            // Stencil
            hideColor = FindProperty("_HideColor", _Prop, false);
            stencilNum = FindProperty("_StencilNum", _Prop, false);
            stencilCompMode = FindProperty("_StencilCompMode", _Prop, false);
            stencilOp = FindProperty("_StencilOp", _Prop, false);
        }
    }

}
