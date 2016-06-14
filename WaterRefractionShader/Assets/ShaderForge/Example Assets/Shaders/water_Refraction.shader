// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:Mobile/Diffuse,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:False,mssp:False,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:0,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:False,igpj:False,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:0,x:34414,y:32442,varname:node_0,prsc:2|diff-219-OUT,normal-215-OUT,amdfl-7555-OUT,alpha-4970-R;n:type:ShaderForge.SFN_Slider,id:13,x:33581,y:32747,ptovrint:False,ptlb:Refraction Intensity,ptin:_RefractionIntensity,varname:node_2899,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.172701,max:1;n:type:ShaderForge.SFN_Tex2d,id:25,x:33737,y:32566,ptovrint:False,ptlb:Refraction,ptin:_Refraction,varname:node_1717,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:bbab0a6f7bae9cf42bf057d8ee2755f6,ntxv:3,isnm:False|UVIN-27-OUT;n:type:ShaderForge.SFN_TexCoord,id:26,x:33379,y:32505,varname:node_26,prsc:2,uv:0;n:type:ShaderForge.SFN_Multiply,id:27,x:33550,y:32566,varname:node_27,prsc:2|A-26-UVOUT,B-28-OUT;n:type:ShaderForge.SFN_Vector1,id:28,x:33379,y:32662,varname:node_28,prsc:2,v1:1;n:type:ShaderForge.SFN_Lerp,id:215,x:33975,y:32524,varname:node_215,prsc:2|A-216-OUT,B-25-RGB,T-13-OUT;n:type:ShaderForge.SFN_Vector3,id:216,x:33737,y:32445,varname:node_216,prsc:2,v1:0,v2:0,v3:1;n:type:ShaderForge.SFN_Fresnel,id:217,x:33975,y:32284,varname:node_217,prsc:2;n:type:ShaderForge.SFN_ConstantLerp,id:219,x:34145,y:32284,varname:node_219,prsc:2,a:0.02,b:0.2|IN-217-OUT;n:type:ShaderForge.SFN_Multiply,id:7555,x:34279,y:32980,varname:node_7555,prsc:2|A-7742-RGB,B-8962-OUT;n:type:ShaderForge.SFN_Slider,id:8962,x:34140,y:33144,ptovrint:False,ptlb:cubemap_power,ptin:_cubemap_power,varname:node_8962,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:9.48719,max:10;n:type:ShaderForge.SFN_Cubemap,id:7742,x:33738,y:32947,ptovrint:False,ptlb:cubemap,ptin:_cubemap,varname:node_7742,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,cube:5cddffede5d8bde43978ec28bef265c7,pvfc:0;n:type:ShaderForge.SFN_Tex2d,id:4970,x:34106,y:32910,ptovrint:False,ptlb:mask,ptin:_mask,varname:node_4970,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:41232aac50fb25a40b390906295f9aa6,ntxv:0,isnm:False;proporder:13-25-8962-7742-4970;pass:END;sub:END;*/

Shader "Water/Reflection_mask" {
    Properties {
        _RefractionIntensity ("Refraction Intensity", Range(0, 1)) = 0.172701
        _Refraction ("Refraction", 2D) = "bump" {}
        _cubemap_power ("cubemap_power", Range(0, 10)) = 9.48719
        _cubemap ("cubemap", Cube) = "_Skybox" {}
        _mask ("mask", 2D) = "white" {}
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
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers gles xbox360 ps3 
            #pragma target 3.0
            uniform float4 _LightColor0;
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
                LIGHTING_COORDS(5,6)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float2 node_27 = (i.uv0*1.0);
                float4 _Refraction_var = tex2D(_Refraction,TRANSFORM_TEX(node_27, _Refraction));
                float3 normalLocal = lerp(float3(0,0,1),_Refraction_var.rgb,_RefractionIntensity);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += (texCUBE(_cubemap,viewReflectDirection).rgb*_cubemap_power); // Diffuse Ambient Light
                float node_219 = lerp(0.02,0.2,(1.0-max(0,dot(normalDirection, viewDirection))));
                float3 diffuseColor = float3(node_219,node_219,node_219);
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                float4 _mask_var = tex2D(_mask,TRANSFORM_TEX(i.uv0, _mask));
                return fixed4(finalColor,_mask_var.r);
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma exclude_renderers gles xbox360 ps3 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float _RefractionIntensity;
            uniform sampler2D _Refraction; uniform float4 _Refraction_ST;
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
                LIGHTING_COORDS(5,6)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float2 node_27 = (i.uv0*1.0);
                float4 _Refraction_var = tex2D(_Refraction,TRANSFORM_TEX(node_27, _Refraction));
                float3 normalLocal = lerp(float3(0,0,1),_Refraction_var.rgb,_RefractionIntensity);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float node_219 = lerp(0.02,0.2,(1.0-max(0,dot(normalDirection, viewDirection))));
                float3 diffuseColor = float3(node_219,node_219,node_219);
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                float4 _mask_var = tex2D(_mask,TRANSFORM_TEX(i.uv0, _mask));
                return fixed4(finalColor * _mask_var.r,0);
            }
            ENDCG
        }
    }
    FallBack "Mobile/Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
