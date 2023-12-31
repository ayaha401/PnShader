﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.Rendering.Universal.ShaderGUI;
using System;

namespace AyahaShader.Pn
{
    public class Pn_SimpleLitGUI : BaseShaderGUI
    {
        // Properties
        private SimpleLitGUI.SimpleLitProperties shadingModelProperties;

        // Advanced Options
        private MaterialProperty zWrite;

        // Dither
        private MaterialProperty useDither;
        private MaterialProperty ditherSize;
        private MaterialProperty fade;

        // Stensil
        private StensilType stensilType = StensilType.Default;
        private MaterialProperty stencilPreset;
        private MaterialProperty stencilNum;
        private MaterialProperty stencilCompMode;
        private MaterialProperty stencilOp;

        private bool useDitherFoldout = false;

        // collect properties from the material properties
        public override void FindProperties(MaterialProperty[] properties)
        {
            base.FindProperties(properties);
            shadingModelProperties = new SimpleLitGUI.SimpleLitProperties(properties);

            // Advanced Options
            zWrite = FindProperty("_Pn_ZWrite", properties, false);

            // Dither
            useDither = FindProperty("_UseDither", properties, false);
            ditherSize = FindProperty("_DitherSize", properties, false);
            fade = FindProperty("_Fade", properties, false);

            // Stensil
            stencilPreset = FindProperty("_StencilPreset", properties, false);
            stencilNum = FindProperty("_StencilNum", properties, false);
            stencilCompMode = FindProperty("_StencilCompMode", properties, false);
            stencilOp = FindProperty("_StencilOp", properties, false);
        }

        // material changed check
        public override void ValidateMaterial(Material material)
        {
            SetMaterialKeywords(material, SimpleLitGUI.SetMaterialKeywords);
        }

        // material main surface options
        public override void DrawSurfaceOptions(Material material)
        {
            if (material == null)
                throw new ArgumentNullException("material");

            // Use default labelWidth
            EditorGUIUtility.labelWidth = 0f;

            base.DrawSurfaceOptions(material);
        }

        // material main surface inputs
        public override void DrawSurfaceInputs(Material material)
        {
            base.DrawSurfaceInputs(material);
            SimpleLitGUI.Inputs(shadingModelProperties, materialEditor, material);
            DrawEmissionProperties(material, true);
            DrawTileOffset(materialEditor, baseMapProp);
        }

        public override void DrawAdvancedOptions(Material material)
        {
            SimpleLitGUI.Advanced(shadingModelProperties);
            base.DrawAdvancedOptions(material);

            // Advanced Options
            if(zWrite != null)
            {
                materialEditor.ShaderProperty(zWrite, new GUIContent("ZWrite"));
            }

            // Stensil
            if(stencilPreset != null)
            {
                stensilType = (StensilType)material.GetInt("_StencilPreset");
                StencilParams stencilParams = new StencilParams(stencilNum, stencilCompMode, stencilOp);
                PnCustomUI.StencilPreset(ref stensilType, stencilParams, material, materialEditor);
            }
            

            // Dither
            if (useDither != null)
            {
                useDitherFoldout = material.GetInt("_UseDither") == 1 ? true : false;
                useDitherFoldout = PnCustomUI.ToggleFoldout("Dither", useDitherFoldout);
                if(useDitherFoldout)
                {
                    material.SetInt("_UseDither", 1);
                    using (new EditorGUILayout.VerticalScope(GUI.skin.box))
                    {
                        materialEditor.ShaderProperty(ditherSize, new GUIContent("Dither Size"));
                        materialEditor.ShaderProperty(fade, new GUIContent("Fade"));
                    }
                }
                else
                {
                    material.SetInt("_UseDither", 0);
                }
            }

            // RenderQueue
            PnCustomUI.RenderQueue(materialEditor);
        }

        public override void AssignNewShaderToMaterial(Material material, Shader oldShader, Shader newShader)
        {
            if (material == null)
                throw new ArgumentNullException("material");

            // _Emission property is lost after assigning Standard shader to the material
            // thus transfer it before assigning the new shader
            if (material.HasProperty("_Emission"))
            {
                material.SetColor("_EmissionColor", material.GetColor("_Emission"));
            }

            base.AssignNewShaderToMaterial(material, oldShader, newShader);

            if (oldShader == null || !oldShader.name.Contains("Legacy Shaders/"))
            {
                SetupMaterialBlendMode(material);
                return;
            }

            SurfaceType surfaceType = SurfaceType.Opaque;
            BlendMode blendMode = BlendMode.Alpha;
            if (oldShader.name.Contains("/Transparent/Cutout/"))
            {
                surfaceType = SurfaceType.Opaque;
                material.SetFloat("_AlphaClip", 1);
            }
            else if (oldShader.name.Contains("/Transparent/"))
            {
                // NOTE: legacy shaders did not provide physically based transparency
                // therefore Fade mode
                surfaceType = SurfaceType.Transparent;
                blendMode = BlendMode.Alpha;
            }
            material.SetFloat("_Surface", (float)surfaceType);
            material.SetFloat("_Blend", (float)blendMode);
        }
    }
}
