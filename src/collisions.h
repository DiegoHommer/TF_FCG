#include <glm/mat4x4.hpp>
#include <glm/vec4.hpp>
#include <glm/gtc/type_ptr.hpp>
#include "classes.h"
#include "matrices.h"

bool PointPlaneCollision(glm::vec4 point_a, glm::vec4 point_b, Box plane){
    glm::vec4 c = plane.position;
    glm::vec4 n = plane.direction;
    float t = dotproduct(c-point_a,n)/dotproduct(point_b-point_a,n);
    if (t>=0 && t<= 1){
        glm::vec4 p = point_a + t*(point_b-point_a);
        p = p - (plane.position - glm::vec4 (0.0f, 0.0f, 0.0f, 1.0f));
        bool inX = ((p.x >= -plane.width) && (p.x <= plane.width)) || plane.width == 0;
        bool inY = ((p.y >= -plane.height) && (p.y <= plane.height)) || plane.height == 0;
        bool inZ = ((p.z >= -plane.length) && (p.z <= plane.length)) || plane.length == 0;
        if (inX && inY && inZ)
            return true;
    }
    return false;
}


glm::vec4 CubePlaneCollision(Box cube, glm::vec4 direction, Box plane){
    glm::vec4 points[8];
    int x = 0;
    for (float i = -1; i <= 1; i+=2){
        for (float j = -1; j <= 1; j+=2){
            for (float k = -1; k <= 1; k+=2){
                points[x] = glm::vec4 (cube.position.x+cube.width*i ,
                                       cube.position.y+cube.height*j ,
                                       cube.position.z+cube.length*k, 1.0f);
                x++;
            }
        }
    }

    glm::vec4 direction_x = glm::vec4 (direction.x, 0.0f, 0.0f, 0.0f);
    glm::vec4 direction_y = glm::vec4 (0.0f, direction.y, 0.0f, 0.0f);
    glm::vec4 direction_z = glm::vec4 (0.0f, 0.0f, direction.z, 0.0f);

    for (int i = 0; i < 8; i++){
        for (int j = 0; j < 8; j++){
            if (i != j && PointPlaneCollision(points[i]+direction_x,points[j]+direction_x,plane))
                direction.x = 0;
            if (i != j && PointPlaneCollision(points[i]+direction_y,points[j]+direction_y,plane))
                direction.y = 0;
            if (i != j && PointPlaneCollision(points[i]+direction_z,points[j]+direction_z,plane))
                direction.z = 0;
        }
    }

    return direction;
}

bool PointCubeCollision(Box cube1, Box cube2, glm::vec4 direction){
    cube1.position += direction;
    glm::vec4 original_position = cube1.position;
    cube1.position -= (cube2.position - glm::vec4 (0.0f, 0.0f, 0.0f, 1.0f));
    cube2.position -= (original_position - glm::vec4 (0.0f, 0.0f, 0.0f, 1.0f));
    glm::vec4 points1[8];
    glm::vec4 points2[8];

    int x = 0;
    for (float i = -1; i <= 1; i+=2){
        for (float j = -1; j <= 1; j+=2){
            for (float k = -1; k <= 1; k+=2){
                points1[x] = glm::vec4 (cube1.position.x+cube1.width*i ,
                                       cube1.position.y+cube1.height*j ,
                                       cube1.position.z+cube1.length*k, 1.0f);
                points2[x] = glm::vec4 (cube2.position.x+cube2.width*i ,
                                       cube2.position.y+cube2.height*j ,
                                       cube2.position.z+cube2.length*k, 1.0f);
                x++;
            }
        }
    }

    bool inx = false, iny = false, inz = false;

    for (int i = 0; i < 8; i++){
        if ((points1[i].x >= -cube2.width && points1[i].x <= cube2.width) ||
            (points2[i].x >= -cube1.width && points2[i].x <= cube1.width))
            inx = true;

        if ((points1[i].y >= -cube2.height && points1[i].y <= cube2.height) ||
            (points2[i].y >= -cube1.height && points2[i].y <= cube1.height))
            iny = true;

        if ((points1[i].z >= -cube2.length && points1[i].z <= cube2.length) ||
            (points2[i].z >= -cube1.length && points2[i].z <= cube1.length))
            inz = true;

    }
    return (inx && iny && inz);
}

glm::vec4 CubeCubeCollision(Box cube1, Box cube2, glm::vec4 direction){
    glm::vec4 direction_x = glm::vec4 (direction.x, 0.0f, 0.0f, 0.0f);
    glm::vec4 direction_y = glm::vec4 (0.0f, direction.y, 0.0f, 0.0f);
    glm::vec4 direction_z = glm::vec4 (0.0f, 0.0f, direction.z, 0.0f);

    if (PointCubeCollision(cube1, cube2, direction_x))
        direction.x = 0;

    if (PointCubeCollision(cube1, cube2, direction_y))
        direction.y = 0;

    if (PointCubeCollision(cube1, cube2, direction_z))
        direction.z = 0;

    return direction;
}
