using UnityEngine;
using UnityEditor;
using System;

namespace AyahaShader.Pn
{
    public class Pn_MoveAreaGUI : ShaderGUI
    {
        // MoveArea
        private MaterialProperty radius;
        private MaterialProperty lineWidth;
        private MaterialProperty objCrossLineWidth;
        private MaterialProperty outlineColor;
        private MaterialProperty moveableColor;

        // Stencil
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
            if (isBaseUi)
            { 
                base.OnGUI(materialEditor, prop);
                return;
            }

            PnCustomUI.Title("MoveArea");
            using (new EditorGUILayout.VerticalScope(GUI.skin.box))
            {
                materialEditor.ShaderProperty(radius, new GUIContent("Radius"));
                materialEditor.ShaderProperty(lineWidth, new GUIContent("Line Width"));
                materialEditor.ShaderProperty(objCrossLineWidth, new GUIContent("ObjCrossLine Width"));
                materialEditor.ShaderProperty(outlineColor, new GUIContent("Outline Color"));
                materialEditor.ShaderProperty(moveableColor, new GUIContent("Moveable Color"));
            }

            // アドバンス設定
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

                // RenderQueue
                PnCustomUI.Title("RenderQueue");
                materialEditor.RenderQueueField();
            }
        }

        private void FindProperties(MaterialProperty[] _Prop)
        {
            // MoveArea
            radius = FindProperty("_Radius", _Prop, false);
            lineWidth = FindProperty("_LineWidth", _Prop, false);
            objCrossLineWidth = FindProperty("_ObjCrossLineWidth", _Prop, false);
            outlineColor = FindProperty("_OutlineColor", _Prop, false);
            moveableColor = FindProperty("_MoveableColor", _Prop, false);

            // Stencil
            stencilNum = FindProperty("_StencilNum", _Prop, false);
            stencilCompMode = FindProperty("_StencilCompMode", _Prop, false);
            stencilOp = FindProperty("_StencilOp", _Prop, false);
        }
    }
}
