#include <glm/mat4x4.hpp>
#include <glm/vec4.hpp>
#include <glm/gtc/type_ptr.hpp>

struct Character
{
    glm::vec4   position;
    glm::vec4   direction = glm::vec4 (0.0f, 0.0f, 0.0f, 0.0f);
    glm::vec4   direction_dash = glm::vec4 (0.0f, 0.0f, 0.0f, 0.0f);
    float       dash = 0;
    float       gravity = -4.0;
    float       velocity = 3.0;
};

struct Box
{
    glm::vec4   position;
    glm::vec4   direction = glm::vec4 (0.0f, 1.0f, 0.0f, 0.0f);
    float       height;
    float       width;
    float       length;
};

struct Sphere
{
    glm::vec4   position;
    float       radius;
};


