using UnityEngine;
using UnityEditor;

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
                // RenderQueue
                PnCustomUI.RenderQueue(materialEditor);
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
        }
    }
}
