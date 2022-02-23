Shader "Custom/Makeup"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Color2 ("Color", Color) = (1,1,1,1)
		_Makeup ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
		_BlendAmount("Blend Amount", Range(0.0, 1.0)) = 1.0
		
		_EmissionColor("Color", Color) = (0,0,0)
        _EmissionMap("Emission", 2D) = "white" {}
		
		_OcclusionStrength("Strength", Range(0.0, 1.0)) = 1.0
        _OcclusionMap("Occlusion", 2D) = "white" {}
		
		_BumpScale("Scale", Float) = 1.0
        _BumpMap("Normal Map", 2D) = "bump" {}
		
		_SpecColor("Specular", Color) = (0.2,0.2,0.2)
        _SpecGlossMap("Specular", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 300

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _Makeup;
		sampler2D _BumpMap;
        sampler2D _GlossMap;
		
		half _Glossiness;
        half _Metallic;
		// half _Shininess;
        fixed4 _Color;
		fixed4 _Color2;
		fixed _BlendAmount;
		fixed4 _EmissionColor;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv2_Makeup;
			float2 uv_BumpMap;
            float2 uv_GlossMap;
        };

        

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			fixed4 v = tex2D (_Makeup, IN.uv2_Makeup) * _Color2;
            o.Albedo = c.rgb;
			o.Albedo = v.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
			o.Alpha = v.a;
			o.Albedo = lerp(c.rgb, v, v.a * _BlendAmount);
			
			o.Emission = c.rgb * tex2D(_MainTex, IN.uv_MainTex).a * _EmissionColor;
			o.Smoothness = _Glossiness;
			o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
			// o.Specular = _Shininess;
			
			
        }
        ENDCG
    }
    FallBack "Diffuse"
}
