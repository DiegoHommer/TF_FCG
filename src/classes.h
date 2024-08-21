#include <glm/mat4x4.hpp>
#include <glm/vec4.hpp>
#include <glm/gtc/type_ptr.hpp>

struct Character
{
    glm::vec4   position;
    glm::vec4   direction = glm::vec4 (0.0f, 0.0f, 0.0f, 0.0f);
    glm::vec4   direction_dash = glm::vec4 (0.0f, 0.0f, 0.0f, 0.0f);
    float       dash_timer = 0;
    int         dash_counter = 1;
    float       gravity = -4.0;
    int         jump_counter = 0;
    float       velocity = 3.0;
    int         strawberry_count = 0;
};

struct Box
{
    glm::vec4   position;
    glm::vec4   direction;
    float       height;
    float       width;
    float       length;
    bool        status = true;
    int         level;
    Box (glm::vec4 p, glm::vec4 d, float h, float w, float l, int l2){
        position = p;
        direction = d;
        height = h;
        width = w;
        length  = l;
        status = true;
        level = l2;
    }
};


Box planes[] =  {Box(glm::vec4 (0.0f,2.5f,0.0f,1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 1.0, 2.5, 2.5, 0),
                Box(glm::vec4 (0.0f,8.0f,-28.0f,1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 1.0, 2.0, 2.0, 0)};

Box cubes[] =   {Box(glm::vec4 (0.0f, 3.0f, -6.0f, 1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 0.1, 1.0, 1.0, 1),
                 Box(glm::vec4 (-2.0f, 4.0f, -10.0f, 1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 0.1, 1.0, 1.0, 1),
                 Box(glm::vec4 (1.0f, 5.0f, -14.0f, 1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 0.1, 1.0, 1.0, 1),
                 Box(glm::vec4 (2.0f, 6.5f, -16.0f, 1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 0.1, 1.0, 1.0, 1),
                 Box(glm::vec4 (0.0f, 8.0f, -17.0f, 1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 0.1, 1.0, 1.0, 1),
                 Box(glm::vec4 (0.0f,8.51f,-28.0f,1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 0.5, 0.25, 0.25, 1),
                 Box(glm::vec4 (0.0f,9.0f,-28.0f,1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 0.1, 0.5, 0.5, 1),
                 Box(glm::vec4 (-10.0f, 3.5f, 0.0f, 1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 0.1, 1.0, 1.0, 2),
                 Box(glm::vec4 (-10.0f, 4.5f, -8.0f, 1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 0.1, 1.0, 1.0, 2),
                 Box(glm::vec4 (-10.0f, 6.0f, -16.0f, 1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 0.1, 1.0, 1.0, 2),
                 Box(glm::vec4 (-10.0f, 6.0f, -24.0f, 1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 0.1, 1.0, 1.0, 2),
                 Box(glm::vec4 (0.0f,8.51f,-28.0f,1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 0.5, 0.25, 0.25, 2),
                 Box(glm::vec4 (0.0f,9.0f,-28.0f,1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 0.1, 0.5, 0.5, 2),
                 Box(glm::vec4 (5.0f,3.5f,0.0f,1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f),  0.1, 1.0, 1.0, 2),
                 Box(glm::vec4 (16.0f,5.0f,0.0f,1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f),  0.1, 4.0, 0.5, 2),
                 Box(glm::vec4 (16.0f,6.25f,0.0f,1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f),  0.1, 4.0, 0.5, 2),
                 Box(glm::vec4 (16.0f,5.65f,0.38f,1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f),  0.7, 4.0, 0.1, 2),
                 Box(glm::vec4 (16.0f,5.65f,-0.38f,1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f),  0.7, 4.0, 0.1, 2)};

Box strawberries[] = {Box(glm::vec4 (0.0f, 5.0f, -26.0f, 1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 0.25, 0.25, 0.25, 1),
                      Box(glm::vec4 (18.0f,-4.0f,0.0f,1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 0.25, 0.25, 0.25, 2),
                      Box(glm::vec4 (-2.0f,3.5f,0.0f,1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 0.25, 0.25, 0.25, 3)};

Box bunny =      Box(glm::vec4 (0.0f,9.5f,-28.0f,1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 0.35, 0.35, 0.35, 1);

Box cow =      Box(glm::vec4 (0.2f,9.7f,-28.0f,1.0f), glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f), 0.35, 0.35, 0.35, 2);
