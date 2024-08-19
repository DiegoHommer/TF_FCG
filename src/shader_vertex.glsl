#version 330 core

// Atributos de vértice recebidos como entrada ("in") pelo Vertex Shader.
// Veja a função BuildTrianglesAndAddToVirtualScene() em "main.cpp".
layout (location = 0) in vec4 model_coefficients;
layout (location = 1) in vec4 normal_coefficients;
layout (location = 2) in vec2 texture_coefficients;

// Matrizes computadas no código C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

// Parâmetros da axis-aligned bounding box (AABB) do modelo
uniform vec4 bbox_min;
uniform vec4 bbox_max;

// Identificador que define qual objeto está sendo desenhado no momento
#define CUBE 0
#define PLANE  1
#define COW 2
#define BUNNY 3
#define MADELINE 4
uniform int object_id;

// Variáveis para acesso das imagens de textura
uniform sampler2D TextureImage1;

// Atributos de vértice que serão gerados como saída ("out") pelo Vertex Shader.
// ** Estes serão interpolados pelo rasterizador! ** gerando, assim, valores
// para cada fragmento, os quais serão recebidos como entrada pelo Fragment
// Shader. Veja o arquivo "shader_fragment.glsl".
out vec4 position_world;
out vec4 position_model;
out vec4 normal;
out vec2 texcoords;
out vec3 gouraud_color; // added for Gouraud shading

// Texture mapping functions
vec2 computePlanarTextureCoords(vec4 position_model, vec4 bbox_min, vec4 bbox_max) {
    float U = (position_model.x - bbox_min.x) / (bbox_max.x - bbox_min.x);
    float V = (position_model.y - bbox_min.y) / (bbox_max.y - bbox_min.y);
    return vec2(U, V);
}


// Lighting functions
vec3 computeLambertLighting(vec4 n, vec4 l, vec3 Kd0, vec3 Kd1, vec3 Ka) {
    // Calculo do Termo difuso (Lambert)
    float lambert = max(0.0, dot(n, l));
    vec3 diffuse = (Kd0 * (lambert + 0.01)) + (Kd1 * max((0.3 - lambert), 0.0));

    // Calculo do Termo ambiente
    vec3 ambient = Ka;

    return diffuse + ambient;
}

vec3 computeBlinnPhongLighting(vec4 n, vec4 l, vec4 v, vec3 Kd0, vec3 Kd1, vec3 Ka, vec3 Ks, float q) {
    // Calculo do Termo difuso (Lambert)
    float lambert = max(0.0, dot(n, l));
    vec3 diffuse = (Kd0 * (lambert + 0.01)) + (Kd1 * max((0.3 - lambert), 0.0));

    // Calculo do Termo ambiente
    vec3 ambient = Ka;

    // Calulo do Termo Especular (Blinn-Phong)
    vec4 h = normalize(v + l);
    float spec = pow(max(dot(n, h), 0.0), q);
    vec3 specular = Ks * spec;

    return ambient + diffuse + specular;
}

void main()
{
    gl_Position = projection * view * model * model_coefficients;
    position_world = model * model_coefficients;
    position_model = model_coefficients;
    normal = inverse(transpose(model)) * normal_coefficients;
    normal.w = 0.0;

    vec4 n = normalize(normal);
    vec4 l = normalize(vec4(2.0, 1.0, 2.0, 0.0));

    // Mapeamento de textura e propriedades do objeto
    vec3 Kd0, Kd1, Ka, Ks;
    float q;

    if(object_id == COW){
        texcoords = computePlanarTextureCoords(position_model, bbox_min, bbox_max);
        Kd0 = texture(TextureImage1, texcoords).rgb;
        Kd1 = vec3(0.0, 0.0, 0.0);
        Ka = vec3(0.0, 0.0, 0.0);

        gouraud_color = computeLambertLighting(n, l, Kd0, Kd1, Ka);
    }else{
        texcoords = texture_coefficients;
        gouraud_color = vec3(0.0,0.0,0.0);
    }
}