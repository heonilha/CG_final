#version 330 core
out vec4 FragColor;

in vec3 FragPos;

uniform vec3 objectColor;
uniform vec3 lightPos;
uniform float lightRadius;

void main()
{
    float distanceToLight = length(FragPos - lightPos);
    float radius = max(lightRadius, 0.001);

    float falloff = clamp(1.0 - distanceToLight / radius, 0.0, 1.0);
    float intensity = mix(0.15, 1.0, falloff * falloff);

    FragColor = vec4(objectColor * intensity, 1.0);
}
