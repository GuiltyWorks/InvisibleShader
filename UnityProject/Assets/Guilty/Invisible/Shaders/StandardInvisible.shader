// Copyright (c) 2022 Guilty
// MIT License
// GitHub : https://github.com/GuiltyWorks
// Twitter : @GuiltyWorks_VRC
// EMail : guiltyworks@protonmail.com

Shader "Guilty/StandardInvisible" {
    Properties {
        _PixelColor ("Pixel Color", Color) = (0.8, 0.8, 0.8, 1.0)
        _BackgroundColor ("Background Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _Glossiness ("Smoothness", Range(0.0, 1.0)) = 0.5
        _Metallic ("Metallic", Range(0.0, 1.0)) = 0.0
        _Resolution ("Resolution", Range(1.0, 64.0)) = 16.0
    }

    SubShader {
        Tags {
            "RenderType" = "Opaque"
        }
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        struct Input {
            float3 worldPos;
        };

        float4 _PixelColor;
        float4 _BackgroundColor;
        float _Glossiness;
        float _Metallic;
        float _Resolution;

        void surf(Input IN, inout SurfaceOutputStandard o) {
            float3 worldPos = mul(UNITY_MATRIX_V, float4(IN.worldPos, 1.0)).xyz;
            float2 screenPos = -(round(worldPos.xy / worldPos.z * 100000000.0) / 100000000.0);
            screenPos = abs(((frac(((screenPos * _Resolution) - 0.5)) - 0.5) * 2.0));
            float isInPixelX = step(screenPos.x, 0.5);
            float isInPixelY = step(screenPos.y, 0.5);
            float isInPixel = ((isInPixelX * isInPixelY) + saturate((1.0 - (isInPixelX + isInPixelY))));
            float4 c = (_PixelColor * isInPixel) + (_BackgroundColor * (1.0 - isInPixel));
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }

        ENDCG
    }

    FallBack "Diffuse"
}
