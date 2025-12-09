#version 330 core
in vec3 FragPos;
in vec3 Normal;
out vec4 FragColor;
uniform vec3 objectColor;  
uniform vec3 lightPos;      // 조명 위치 (플레이어 근처로 설정)
uniform vec3 viewPos;       // 카메라(눈) 위치
uniform int lightingMode;

void main()
{
    if (lightingMode == 0) {
    // 미니맵용: 조명 0, 색만 표시
    FragColor = vec4(objectColor, 1.0);
    return;
    }

    // 정규화된 법선
    vec3 norm = normalize(Normal);

    // --- Ambient (환경광: 기본 밝기, 전체 약간 보이게) ---
    float ambientStrength = 0.5;
    vec3 ambient = ambientStrength * objectColor;

    // --- Diffuse (확산광: 법선과 빛 방향 각도에 따라) ---
    vec3 lightDir = normalize(lightPos - FragPos);
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = diff * objectColor;

    // --- Specular (반사광: 살짝 번쩍이는 효과) ---
    vec3 viewDir = normalize(viewPos - FragPos);
    vec3 reflectDir = reflect(-lightDir, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 16.0);
    float specStrength = 0.4;
    vec3 specular = specStrength * spec * vec3(1.0, 1.0, 1.0);

    // --- Attenuation (거리 감쇠: 멀어질수록 어두워짐) ---
    float distance = length(lightPos - FragPos);
    float constant = 1.0;
    float linear = 0.35;
    float quadratic = 0.44;
    float attenuation = 1.0 / (constant + linear * distance + quadratic * distance * distance);

    // Ambient는 너무 어둡지 않게 그대로 두고,
    // Diffuse + Specular에만 감쇠를 적용해서 가까울수록 확실히 밝게
    vec3 color = ambient + (diffuse + specular) * attenuation;

    FragColor = vec4(color, 1.0);
}
