using UnityEngine;
using UnityEditor;
using UnityEngine.Rendering;

namespace AyahaShader.Pn
{
    public static class PnCustomUI
    {
        public static bool Foldout(string label, bool value)
        {
            var style = new GUIStyle("ShurikenModuleTitle");
            style.font = new GUIStyle(EditorStyles.label).font;
            style.border = new RectOffset(15, 7, 4, 4);
            style.fixedHeight = 22;
            style.contentOffset = new Vector2(20f, -2f);

            var rect = GUILayoutUtility.GetRect(16f, 22f, style);
            GUI.Box(rect, label, style);

            var e = Event.current;

            var foldoutRect = new Rect(rect.x + 4f, rect.y + 2f, 13f, 13f);
            if (e.type == UnityEngine.EventType.Repaint)
            {
                EditorStyles.foldout.Draw(foldoutRect, false, false, value, false);
            }

            if (e.type == UnityEngine.EventType.MouseDown && rect.Contains(e.mousePosition))
            {
                value = !value;
                e.Use();
            }

            return value;
        }

        public static bool ToggleFoldout(string label, bool value)
        {
            var style = new GUIStyle("ShurikenModuleTitle");
            style.font = new GUIStyle(EditorStyles.label).font;
            style.border = new RectOffset(15, 7, 4, 4);
            style.fixedHeight = 22;
            style.contentOffset = new Vector2(20f, -2f);

            var rect = GUILayoutUtility.GetRect(16f, 22f, style);
            GUI.Box(rect, label, style);

            var e = Event.current;

            var toggleRect = new Rect(rect.x + 4f, rect.y + 2f, 13f, 13f);
            if (e.type == UnityEngine.EventType.Repaint)
            {
                EditorStyles.toggle.Draw(toggleRect, false, false, value, false);
            }

            if (e.type == UnityEngine.EventType.MouseDown && rect.Contains(e.mousePosition))
            {
                value = !value;
                e.Use();
            }

            return value;
        }

        public static void Title(string label)
        {
            var style = new GUIStyle("ShurikenModuleTitle");
            style.font = new GUIStyle(EditorStyles.label).font;
            style.border = new RectOffset(15, 7, 4, 4);
            style.fixedHeight = 22;
            style.contentOffset = new Vector2(20f, -2f);

            var rect = GUILayoutUtility.GetRect(16f, 22f, style);
            GUI.Box(rect, label, style);
        }

        public static void GUIPartition()
        {
            GUI.color = Color.gray;
            GUILayout.Box("", GUILayout.Height(2), GUILayout.ExpandWidth(true));
            GUI.color = Color.white;
        }

        public static void Information()
        {
            Title("Info");
            using (new EditorGUILayout.VerticalScope())
            {
                using (new EditorGUILayout.HorizontalScope())
                {
                    EditorGUILayout.LabelField("Version");
                    EditorGUILayout.LabelField("Version " + PnVersion.GetPnVersion());
                }

                using (new EditorGUILayout.HorizontalScope())
                {
                    EditorGUILayout.LabelField("How to use (Japanese)");
                    if (GUILayout.Button("How to use (Japanese)"))
                    {
                        System.Diagnostics.Process.Start("");
                    }
                }
            }
        }

        public static void RenderQueue(MaterialEditor materialEditor)
        {
            Title("RenderQueue");
            materialEditor.RenderQueueField();
        }




        public static void StencilPreset(ref StensilType stensilType, StencilParams stencilParams, Material material, MaterialEditor materialEditor)
        {
            Title("Stencil");
            using (new EditorGUILayout.VerticalScope(GUI.skin.box))
            {
                using (new EditorGUILayout.HorizontalScope())
                {
                    EditorGUILayout.LabelField("Preset");
                    stensilType = (StensilType)EditorGUILayout.EnumPopup(stensilType);
                }

                switch (stensilType)
                {
                    case StensilType.Default:
                        stencilParams.stencilNum.floatValue = 0;
                        stencilParams.stencilCompMode.floatValue = (float)CompareFunction.Always;
                        stencilParams.stencilOp.floatValue = (float)StencilOp.Keep;
                        break;
                    case StensilType.Player:
                        stencilParams.stencilNum.floatValue = 1;
                        stencilParams.stencilCompMode.floatValue = (float)CompareFunction.Equal;
                        stencilParams.stencilOp.floatValue = (float)StencilOp.Keep;
                        break;
                    case StensilType.Wall:
                        stencilParams.stencilNum.floatValue = 1;
                        stencilParams.stencilCompMode.floatValue = (float)CompareFunction.Always;
                        stencilParams.stencilOp.floatValue = (float)StencilOp.Replace;
                        break;
                }
                materialEditor.ShaderProperty(stencilParams.stencilNum, new GUIContent("Stencil Number"));
                materialEditor.ShaderProperty(stencilParams.stencilCompMode, new GUIContent("Stencil CompMode"));
                materialEditor.ShaderProperty(stencilParams.stencilOp, new GUIContent("Stencil Operation"));
                material.SetInt("_StencilPreset", (int)stensilType);
            }
        }
    }

}
