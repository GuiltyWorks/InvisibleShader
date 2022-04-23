// Copyright (c) 2022 Guilty
// MIT License
// GitHub : https://github.com/GuiltyWorks
// Twitter : @GuiltyWorks_VRC
// EMail : guiltyworks@protonmail.com

Shader "Guilty/UnlitInvisibleWithShadow" {
    Properties {
        _PixelColor ("Pixel Color", Color) = (0.5, 0.5, 0.5, 1.0)
        _BackgroundColor ("Background Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _Resolution ("Resolution", Range(1.0, 64.0)) = 16.0
    }

    SubShader {
        Tags {
            "RenderType" = "Opaque"
        }
        LOD 100

        Pass {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
            };

            struct v2f {
                float3 worldPos : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            float4 _PixelColor;
            float4 _BackgroundColor;
            float _Resolution;

            v2f vert(appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                float3 worldPos = mul(UNITY_MATRIX_V, float4(i.worldPos, 1.0)).xyz;
                float2 screenPos = -(round(worldPos.xy / worldPos.z * 100000000.0) / 100000000.0);
                screenPos = abs(((frac(((screenPos * _Resolution) - 0.5)) - 0.5) * 2.0));
                float isInPixelX = step(screenPos.x, 0.5);
                float isInPixelY = step(screenPos.y, 0.5);
                float isInPixel = ((isInPixelX * isInPixelY) + saturate((1.0 - (isInPixelX + isInPixelY))));
                fixed4 col = (_PixelColor * isInPixel) + (_BackgroundColor * (1.0 - isInPixel));
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }

            ENDCG
        }
    }

    FallBack "Diffuse"
}
