class PhongLighting {
    // PVector lightPos;
    // color lightColor;
    // color ambientColor;
    // float shininess;

    // PhongLighting(PVector lightPos, color lightColor, color ambientColor, float shininess) {
    //     this.lightPos = lightPos;
    //     this.lightColor = lightColor;
    //     this.ambientColor = ambientColor;
    //     this.shininess = shininess;
    // }

    // color calculate(PVector normal, PVector point, PVector viewPos, color objectColor) {
    //     // Normalize vectors
    //     normal.normalize();
    //     PVector lightDir = PVector.sub(lightPos, point).normalize();
    //     PVector viewDir = PVector.sub(viewPos, point).normalize();

    //     // Ambient component
    //     color ambient = ambientColor;

    //     // Diffuse component
    //     float diff = max(PVector.dot(normal, lightDir), 0.0);
    //     color diffuse = lightColor * diff;

    //     // Specular component
    //     PVector reflectDir = PVector.sub(PVector.mult(normal, 2 * PVector.dot(normal, lightDir)), lightDir).normalize();
    //     float spec = pow(max(PVector.dot(viewDir, reflectDir), 0.0), shininess);
    //     color specular = lightColor * spec;

    //     // Combine results
    //     color result = ambient + diffuse + specular;
    //     result = color(
    //         red(result) * red(objectColor) / 255,
    //         green(result) * green(objectColor) / 255,
    //         blue(result) * blue(objectColor) / 255
    //     );

    //     return result;
    // }
}