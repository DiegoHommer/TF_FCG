#version 330 core

// Atributos de fragmentos recebidos como entrada ("in") pelo Fragment Shader.
// Neste exemplo, este atributo foi gerado pelo rasterizador como a
// interpolação da posição global e a normal de cada vértice, definidas em
// "shader_vertex.glsl" e "main.cpp".
in vec4 position_world;
in vec4 normal;

// Posição do vértice atual no sistema de coordenadas local do modelo.
in vec4 position_model;

// Coordenadas de textura obtidas do arquivo OBJ (se existirem!)
in vec2 texcoords;

// Matrizes computadas no código C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

// Identificador que define qual objeto está sendo desenhado no momento
#define CUBE 0
#define COW 1
#define BUNNY 2
#define PLANE 3
#define MADELINE  4
#define COLLISION 5
uniform int object_id;

// Parâmetros da axis-aligned bounding box (AABB) do modelo
uniform vec4 bbox_min;
uniform vec4 bbox_max;

// Variáveis para acesso das imagens de textura
uniform sampler2D TextureImage0;
uniform sampler2D TextureImage1;
uniform sampler2D TextureImage2;
uniform sampler2D TextureImage3;

// O valor de saída ("out") de um Fragment Shader é a cor final do fragmento.
out vec4 color;

// Constantes
#define M_PI   3.14159265358979323846
#define M_PI_2 1.57079632679489661923


// Funcoes auxiliares
vec2 computeSphericalTextureCoords(vec4 position_model, vec4 bbox_min, vec4 bbox_max) {
    vec4 bbox_center = (bbox_min + bbox_max) / 2.0;
    float radius = 1.0;
    vec4 p_linha = bbox_center + (radius * ((position_model - bbox_center) / length(position_model - bbox_center)));
    vec4 vector_p = p_linha - bbox_center;
    float theta = atan(vector_p.x, vector_p.z);
    float phi = asin(vector_p.y / radius);
    float U = (theta + M_PI) / (2.0 * M_PI);
    float V = (phi + M_PI_2) / M_PI;
    return vec2(U, V);
}

vec2 computePlanarTextureCoords(vec4 position_model, vec4 bbox_min, vec4 bbox_max) {
    float U = (position_model.x - bbox_min.x) / (bbox_max.x - bbox_min.x);
    float V = (position_model.y - bbox_min.y) / (bbox_max.y - bbox_min.y);
    return vec2(U, V);
}

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

// Aqui definimos o modelo de iluminacao usado para cada objeto
vec3 computeLighting(vec4 n, vec4 l, vec4 v, vec3 Kd0, vec3 Kd1, vec3 Ks, vec3 Ka, float q, int object_id) {
    if (object_id == BUNNY) {
        return computeBlinnPhongLighting(n, l, v, Kd0, Kd1, Ka, Ks, q);
    } else {
        return computeLambertLighting(n, l, Kd0, Kd1, Ka);
    }
}

void main()
{
    // Camera position calculation
    vec4 origin = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 camera_position = inverse(view) * origin;

    // Fragment properties
    vec4 p = position_world;
    vec4 n = normalize(normal);
    vec4 l = normalize(vec4(1.0, 1.0, 0.0, 0.0));
    vec4 v = normalize(camera_position - p);

    // Texture coordinates calculation
    vec2 texCoords;
    if (object_id == CUBE || object_id == PLANE || object_id == MADELINE) {
        texCoords = computeSphericalTextureCoords(position_model, bbox_min, bbox_max);
    } else if (object_id == COW || object_id == BUNNY) {
        texCoords = computePlanarTextureCoords(position_model, bbox_min, bbox_max);
    } else if (object_id == BUNNY) {
        texCoords = texcoords;
    }

    // Mapeamento de textura e propriedades do objeto
    vec3 Kd0, Kd1, Ka, Ks;
    float q;
    if (object_id == COW || object_id == MADELINE) {
        Kd0 = texture(TextureImage3, texCoords).rgb;
        Kd1 = vec3(0.0, 0.0, 0.0);
        Ks = vec3(0.0, 0.0, 0.0);
        Ka = vec3(0.0, 0.0, 0.0);
        q = 0.0;
    } else if (object_id == CUBE) {
        Kd0 = texture(TextureImage0, texCoords).rgb;
        Kd1 = texture(TextureImage1, texCoords).rgb;
        Ks = vec3(0.0, 0.0, 0.0);
        Ka = vec3(0.0, 0.0, 0.0);
        q = 0.0;
    } else if (object_id == BUNNY) {
        Kd0 = texture(TextureImage2, texCoords).rgb; // Wood texture
        Kd1 = vec3(0.0, 0.0, 0.0);
        Ks = vec3(0.1, 0.1, 0.1); // Low specular for wood
        Ka = vec3(0.0, 0.0, 0.0); // Ambient color similar to wood
        q = 10.0; // Subtle shininess
    } else if (object_id == PLANE) {
        Kd0 = texture(TextureImage0, texCoords).rgb;
        Kd1 = texture(TextureImage1, texCoords).rgb;
        Ks = vec3(0.0, 0.0, 0.0);
        Ka = vec3(0.0, 0.0, 0.0);
        q = 0.0;
    }

    // Cálculo da iluminação
    color.rgb = computeLighting(n, l, v, Kd0, Kd1, Ks, Ka, q, object_id);

    // Transparency and gamma correction
    color.a = 1.0;
    color.rgb = pow(color.rgb, vec3(1.0) / 2.2);
    if (object_id == COLLISION)
        color = vec4(0.0f,0.0f,0.0f,1.0f);

}

