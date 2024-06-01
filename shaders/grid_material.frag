#version 460 core

in vec2 fragTexCoord;
in vec4 fragColor;
in vec3 fragPosition;
in vec3 fragNormal;

out vec4 outColor;

float grid_intensity = 0.9;

// Thick lines 
float grid(vec2 fragCoord, float space, float gridWidth)
{
    vec2 p  = fragCoord - vec2(.5);
    vec2 size = vec2(gridWidth);
    
    vec2 a1 = mod(p - size, space);
    vec2 a2 = mod(p + size, space);
    vec2 a = a2 - a1;
       
    float g = min(a.x, a.y);
    return clamp(g, 0., 1.0);
}

void main() {
    float x = step(0.9,mod(fragPosition.z * 2.0, 1.0));
    x += step(0.9,mod(fragPosition.y * 2.0, 1.0));
    float y = step(0.9,mod(fragPosition.x * 2.0, 1.0));
    y += step(0.9,mod(fragPosition.z * 2.0, 1.0));
    float z = step(0.9,mod(fragPosition.x * 2.0, 1.0));
    z += step(0.9,mod(fragPosition.y * 2.0, 1.0));
    outColor = vec4(vec3(x+y+z), 1.0);
    

    outColor = vec4(1.0);

}