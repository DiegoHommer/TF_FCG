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
};

struct Box
{
    glm::vec4   position;
    glm::vec4   direction;
    float       height;
    float       width;
    float       length;
    bool        status = true;
    Box (glm::vec4 p, glm::vec4 d, float h, float w, float l){
        position = p;
        direction = d;
        height = h;
        width = w;
        length  = l;
        status = true;
    }
};


