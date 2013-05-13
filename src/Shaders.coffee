window.XylemShaders = {
    albedoFromGbuffer : {
        f   :   "
                precision mediump float;
                varying vec2 vTextureCoord;
                uniform sampler2D albedos;
                uniform vec3 ambientColor;
                void main(void) {
                    vec4 albedo = texture2D(albedos, vTextureCoord);
                    gl_FragColor = vec4(albedo.rgb * ambientColor, albedo.a);
                }
                ",
        v   :   "
                attribute vec3 vertexPosition;
                attribute vec2 textureCoord;
                varying vec2 vTextureCoord;
                void main(void) {
                    gl_Position = vec4(vertexPosition, 1.0);
                    vTextureCoord = textureCoord;
                }
                "
    },
    lightOverGbuffer : {
        f   :   "
                precision mediump float;
                varying vec2 vTextureCoord;
                varying vec4 vPosition;
                uniform sampler2D normals;
                uniform sampler2D albedos;
                uniform vec3 ambientColor;
                uniform vec3 pointLightingLocation;
                uniform vec3 pointLightingSpecularColor;
                uniform vec3 pointLightingDiffuseColor;
                uniform float specularHardness;
                uniform float farClip;
                void main(void) {
                    vec4 normal = texture2D(normals, vTextureCoord);
                    vec4 albedo = texture2D(albedos, vTextureCoord);
                    float depth = texture2D(normals, vTextureCoord).a;
                    vec3 viewRay = vec3(vPosition.xy * (-farClip/vPosition.z), -farClip);
                    vec3 position = viewRay * depth;
                    vec3 lightDirection = normalize(pointLightingLocation - position);
                    vec3 eyeDirection = normalize(-position);
                    vec3 reflectionDirection = reflect(-lightDirection, normal.xyz);
                    float specularLightWeighting = pow(max(dot(reflectionDirection, eyeDirection), 0.0), specularHardness);
                    float diffuseLightWeighting = max(dot(normal.xyz, lightDirection), 0.0);
                    vec3 lightWeighting = pointLightingSpecularColor * specularLightWeighting
                        + pointLightingDiffuseColor * diffuseLightWeighting;

                    gl_FragColor = vec4(albedo.rgb * lightWeighting, albedo.a);
                }
                ",
        v   :   "
                attribute vec3 vertexPosition;
                attribute vec2 textureCoord;
                varying vec2 vTextureCoord;
                varying vec4 vPosition;
                uniform mat4 pMatrix;
                void main(void) {
                    gl_Position = vec4(vertexPosition, 1.0);
                    vPosition =  pMatrix * gl_Position;
                    vTextureCoord = textureCoord;
                }
                "
    },
    generateGbufferNormals : {
        f   :   "
                precision mediump float;
                varying vec2 vTextureCoord;
                varying vec3 vTransformedNormal;
                varying vec3 vColor;
                varying vec4 vPosition;
                varying float vDepth;
                uniform float textureOpacity;
                uniform sampler2D sampler;
                void main(void) {
                    gl_FragColor = vec4(normalize(vTransformedNormal), vDepth);
                }
                ",
        v   :   "
                attribute vec3 vertexPosition;
                attribute vec3 vertexNormal;
                attribute vec3 vertexColor;
                attribute vec2 textureCoord;
                uniform mat4 mvMatrix;
                uniform mat4 pMatrix;
                uniform mat3 nMatrix;
                uniform float farClip;
                varying vec2 vTextureCoord;
                varying vec3 vTransformedNormal;
                varying vec3 vColor;
                varying vec4 vPosition;
                varying float vDepth;
                void main(void) {
                    vPosition = mvMatrix * vec4(vertexPosition, 1.0);
                    gl_Position = pMatrix * vPosition;
                    vTextureCoord = textureCoord;
                    vColor = vertexColor;
                    vTransformedNormal = nMatrix * vertexNormal;
                    vDepth = -vPosition.z / farClip;
                }
                "
    },
    generateGbufferAlbedo : {
        f   :   "
                precision mediump float;
                varying vec2 vTextureCoord;
                varying vec3 vTransformedNormal;
                varying vec3 vColor;
                varying vec4 vPosition;
                uniform float textureOpacity;
                uniform sampler2D sampler;
                void main(void) {
                    gl_FragColor =  vec4(vColor, 1.0) * (1.0 - textureOpacity) + texture2D(sampler, vec2(vTextureCoord.s, vTextureCoord.t)) * textureOpacity;
                }
                ",
        v   :   "
                attribute vec3 vertexPosition;
                attribute vec3 vertexNormal;
                attribute vec3 vertexColor;
                attribute vec2 textureCoord;
                uniform mat4 mvMatrix;
                uniform mat4 pMatrix;
                uniform mat3 nMatrix;
                varying vec2 vTextureCoord;
                varying vec3 vTransformedNormal;
                varying vec3 vColor;
                varying vec4 vPosition;
                void main(void) {
                    vPosition = mvMatrix * vec4(vertexPosition, 1.0);
                    gl_Position = pMatrix * vPosition;
                    vTextureCoord = textureCoord;
                    vColor = vertexColor;
                    vTransformedNormal = nMatrix * vertexNormal;
                }
                "
    },
    generateGbufferPosition : {
        f   :   "
                precision mediump float;
                varying vec2 vTextureCoord;
                varying vec3 vTransformedNormal;
                varying vec3 vColor;
                varying vec4 vPosition;
                uniform float textureOpacity;
                uniform sampler2D sampler;
                void main(void) {
                    gl_FragColor = vPosition;
                }
                ",
        v   :   "
                attribute vec3 vertexPosition;
                attribute vec3 vertexNormal;
                attribute vec3 vertexColor;
                attribute vec2 textureCoord;
                uniform mat4 mvMatrix;
                uniform mat4 pMatrix;
                uniform mat3 nMatrix;
                varying vec2 vTextureCoord;
                varying vec3 vTransformedNormal;
                varying vec3 vColor;
                varying vec4 vPosition;
                void main(void) {
                    vPosition = mvMatrix * vec4(vertexPosition, 1.0);
                    gl_Position = pMatrix * vPosition;
                    vTextureCoord = textureCoord;
                    vColor = vertexColor;
                    vTransformedNormal = nMatrix * vertexNormal;
                }
                "
    }
}