class PhongLighting {

    PVector normal;
    PVector point;
    PVector lightPos;
    PVector viewer;
    PVector reflection;

    color lightColor;
    color ambientColor;
    float shininess;


    //might want to include booleans that 
    PhongLighting(PVector normal, PVector point) {
        this.normal = normal;
        this.point = point;
        this.lightPos = PVector.sub(LIGHT, point).normalize();
        this.viewer = PVector.sub(EYE, point).normalize();
        this.reflection = PVector.sub(PVector.mult(normal, 2 * PVector.dot(normal, lightPos)), lightPos).normalize();
    }

    color calculate(){
        float phongR, phongG, phongB;

        // ambient color
        float ambientR = PHONG_COLORS[A][R] * MATERIAL[A];
        float ambientG = PHONG_COLORS[A][G] * MATERIAL[A];
        float ambientB = PHONG_COLORS[A][B] * MATERIAL[A];

        // diffuse color
        float dotProd = PVector.dot(normal, lightPos);
        float diffuseR = dotProd * PHONG_COLORS[D][R] * MATERIAL[D];
        float diffuseG = dotProd * PHONG_COLORS[D][G] * MATERIAL[D];
        float diffuseB = dotProd * PHONG_COLORS[D][B] * MATERIAL[D];

        // specular color
        float specDotProd = PVector.dot(reflection, viewer);
        float specularR, specularG, specularB;
        if(specDotProd > SPECULAR_FLOOR){
            specDotProd = (float)Math.pow(specDotProd, PHONG_SHININESS);
            specularR = PHONG_COLORS[S][R] * MATERIAL[S] * specDotProd;
            specularG = PHONG_COLORS[S][G] * MATERIAL[S] * specDotProd;
            specularB = PHONG_COLORS[S][B] * MATERIAL[S] * specDotProd;
        } else {
            specularR = 0;
            specularG = 0;
            specularB = 0;
        }

        // summing up the colors
        phongR = ambientR + diffuseR + specularR;
        phongG = ambientG + diffuseG + specularG;
        phongB = ambientB + diffuseB + specularB;

        return new color(phongR, phongG, phongB);
    }
}