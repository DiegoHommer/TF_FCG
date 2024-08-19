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

// Cor obtida em casos de Gouraud shading
in vec3 gouraud_color;

// Matrizes computadas no código C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;


// Identificador que define qual objeto está sendo desenhado no momento
#define CUBE 0
#define PLANE  1
#define COW 2
#define BUNNY 3
#define MADELINE 4
#define WINGED_BERRY 5
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


// Funcoes de mapeamento de textura (COM AUXILIO DE CHAT GPT)
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

vec2 computeCubeTextureCoords(vec4 position_model, vec4 bbox_min, vec4 bbox_max) {
    vec4 bbox_center = (bbox_min + bbox_max) / 2.0;
    vec4 p_linha = position_model - bbox_center;
    float U, V;

    if (abs(p_linha.x) >= abs(p_linha.y) && abs(p_linha.x) >= abs(p_linha.z)) {
        U = (p_linha.z / abs(p_linha.x) + 1.0) / 2.0;
        V = (p_linha.y / abs(p_linha.x) + 1.0) / 2.0;
    } else if (abs(p_linha.y) >= abs(p_linha.x) && abs(p_linha.y) >= abs(p_linha.z)) {
        U = (p_linha.x / abs(p_linha.y) + 1.0) / 2.0;
        V = (p_linha.z / abs(p_linha.y) + 1.0) / 2.0;
    } else {
        U = (p_linha.x / abs(p_linha.z) + 1.0) / 2.0;
        V = (p_linha.y / abs(p_linha.z) + 1.0) / 2.0;
    }
    return vec2(U, V);
}

vec2 computePlanarTextureCoords(vec4 position_model, vec4 bbox_min, vec4 bbox_max) {
    float U = (position_model.x - bbox_min.x) / (bbox_max.x - bbox_min.x);
    float V = (position_model.y - bbox_min.y) / (bbox_max.y - bbox_min.y);
    return vec2(U, V);
}

// Funcoes de iluminação (COM AUXILIO DE CHAT GPT)
vec3 computeLambertLighting(vec4 n, vec4 l, vec3 Kd, vec3 Ka) {
    // Calculo do Termo difuso (Lambert)
    float lambert = max(0.0, dot(n, l));
    vec3 I = vec3(1.0,1.0,1.0);
    vec3 diffuse = Kd * I * lambert;

    // Calculo do Termo ambiente
    vec3 Ia = vec3(0.2,0.2,0.2);
    vec3 ambient = Ka * Ia;

    return diffuse + ambient;
}

vec3 computeBlinnPhongLighting(vec4 n, vec4 l, vec4 v, vec3 Kd, vec3 Ka, vec3 Ks, float q) {
    // Calculo do Termo difuso (Lambert)
    float lambert = max(0.0, dot(n, l));
    vec3 I = vec3(1.0,1.0,1.0);

    vec3 diffuse = Kd * I * lambert;

    // Calculo do Termo ambiente
    vec3 Ia = vec3(0.2,0.2,0.2);
    vec3 ambient = Ka * Ia;

    // Calulo do Termo Especular (Blinn-Phong)
    vec4 h = normalize(v + l);
    float spec = pow(max(dot(n, h), 0.0), q);
    vec3 specular = Ks * spec;

    return ambient + diffuse + specular;
}

// Aqui definimos o modelo de iluminacao usado para cada objeto
vec3 computeLighting(vec4 n, vec4 l, vec4 v, vec3 Kd, vec3 Ks, vec3 Ka, float q, int object_id) {
    if (object_id == BUNNY || object_id == PLANE) {
        return computeBlinnPhongLighting(n, l, v, Kd, Ka, Ks, q);
    } else {
        return computeLambertLighting(n, l, Kd, Ka);
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
    vec4 l = normalize(vec4(2.0, 1.0, 3.0, 0.0));
    vec4 v = normalize(camera_position - p);

    // Texture coordinates calculation
    vec2 texCoords;
    if (object_id == CUBE) {
        texCoords = computeCubeTextureCoords(position_model, bbox_min, bbox_max);
    } else if (object_id == BUNNY) {
        texCoords = computePlanarTextureCoords(position_model, bbox_min, bbox_max);
    }else if (object_id == CUBE){
        texCoords = computeSphericalTextureCoords(position_model, bbox_min, bbox_max);
    } else if (object_id == PLANE || object_id == WINGED_BERRY || object_id == MADELINE) {
        texCoords = texcoords;
    }

    // Mapeamento de textura e propriedades do objeto
    vec3 Kd, Ka, Ks;
    float q;

    // Aqui definimos qual modelo de interpolacao de iluminacao usamos 
    if (gouraud_color != vec3(0.0,0.0,0.0)){
        // Gouraud Shading Interpolation (para cada vertice)
        color.rgb = gouraud_color;

    }else {
        // Phong Shading Interpolation (para cada fragmento)

        if (object_id == MADELINE) {
            Kd = texture(TextureImage2, texCoords).rgb;
            Ks = vec3(0.0, 0.0, 0.0);
            Ka = vec3(0.1, 0.1, 0.1);
            q = 0.0;
        } else if (object_id == CUBE) {
            Kd = texture(TextureImage0, texCoords).rgb;
            Ks = vec3(0.0, 0.0, 0.0);
            Ka = vec3(0.0, 0.0, 0.0);
            q = 0.0;
        } else if (object_id == BUNNY) {
            Kd = texture(TextureImage1, texCoords).rgb; 
            Ks = vec3(0.1, 0.1, 0.1); 
            Ka = vec3(0.0, 0.0, 0.0); 
            q = 10.0; 
        }  else if (object_id == PLANE) {
            Kd = texture(TextureImage0, texCoords).rgb; 
            Ks = vec3(0.3,0.3,0.3);
            Ka = vec3(0.0,0.0,0.0);
            q = 10.0;
        } else if (object_id == WINGED_BERRY) {
            Kd = texture(TextureImage3, texCoords).rgb; 
            Ks = vec3(0.0,0.0,0.0);
            Ka = vec3(0.0,0.0,0.0);
            q = 0.0;       
        }

        // Cálculo da iluminação
        color.rgb = computeLighting(n, l, v, Kd, Ks, Ka, q, object_id);
    }

    // Transparency and gamma correction
    color.a = 1.0;
    color.rgb = pow(color.rgb, vec3(1.0) / 2.2);

}