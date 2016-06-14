Shader "Water/ReflectionMask" {
    Properties {
        _RefractionIntensity ("Refraction Intensity", Range(0, 1)) = 0.172701
        _Refraction ("Refraction", 2D) = "bump" {}
        _cubemap_power ("cubemap_power", Range(0, 10)) = 9.48719
        _cubemap ("cubemap", Cube) = "_Skybox" {}
        _mask ("mask", 2D) = "white" {}
        LightColor ("Light Color", Color) = (1, 1, 1, 1)
        LightDir ("Light Dir", Vector) = (0,0,0) 
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="Always"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            uniform float4 LightColor;
            uniform float4 LightDir;

            uniform float _RefractionIntensity;
            uniform sampler2D _Refraction; uniform float4 _Refraction_ST;
            uniform float _cubemap_power;
            uniform samplerCUBE _cubemap;
            uniform sampler2D _mask; uniform float4 _mask_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float2 uv = (i.uv0*1.0);
                float4 _Refraction_var = tex2D(_Refraction,TRANSFORM_TEX(uv, _Refraction));
                float3 normalLocal = lerp(float3(0,0,1),_Refraction_var.rgb,_RefractionIntensity);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightColor = LightColor.rgb;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, normalize(LightDir.xyz) ));
                float3 directDiffuse = max( 0.0, NdotL) * LightColor.xyz * LightDir.w;
                float3 indirectDiffuse = (texCUBE(_cubemap,viewReflectDirection).rgb*_cubemap_power); // Diffuse Ambient Light
                float node_219 = lerp(0.02,0.2,(1.0-max(0,dot(normalDirection, viewDirection))));
                float3 diffuseColor = float3(node_219,node_219,node_219);
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
/// Final Color:
                float4 _mask_var = tex2D(_mask,TRANSFORM_TEX(i.uv0, _mask));
                return fixed4(diffuse,_mask_var.r);
            }
            ENDCG
        }
    }
    FallBack "Mobile/Diffuse"
}
