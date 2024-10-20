class PhongLighting {

    PVector normal;
    PVector point;
    PVector lightPos;
    PVector viewer;
    PVector reflection;

    color shapeColor;


    //might want to include booleans that 
    PhongLighting(PVector normal, PVector point, color shapeColor) {
        this.normal = normal;
        this.point = point;
        this.lightPos = PVector.sub(point, LIGHT).normalize();
        this.viewer = PVector.sub(point, EYE).normalize();
        this.reflection = PVector.sub(PVector.mult(normal, 2 * PVector.dot(normal, lightPos)), lightPos).normalize();
        this.shapeColor = shapeColor;
    }

    color calculate(){
        if(shadingMode == shadingMode.FLAT){
            return shapeColor;
        }

        float phongR, phongG, phongB;

        // ambient color
        float ambientR = red(shapeColor) * MATERIAL[A];
        float ambientG = green(shapeColor) * MATERIAL[A];
        float ambientB = blue(shapeColor) * MATERIAL[A];

        // diffuse color
        float dotProd = PVector.dot(normal, lightPos);
        float diffuseR = dotProd * red(shapeColor) * MATERIAL[D];
        float diffuseG = dotProd * green(shapeColor) * MATERIAL[D];
        float diffuseB = dotProd * blue(shapeColor) * MATERIAL[D];

        // specular color
        float specDotProd = PVector.dot(reflection, viewer);
        float specularR, specularG, specularB;
        if(specDotProd > SPECULAR_FLOOR){
            specDotProd = (float)Math.pow(specDotProd, PHONG_SHININESS);
            specularR = red(shapeColor)   * MATERIAL[S] * specDotProd;
            specularG = green(shapeColor) * MATERIAL[S] * specDotProd;
            specularB = blue(shapeColor)  * MATERIAL[S] * specDotProd;
        } else {
            specularR = 0;
            specularG = 0;
            specularB = 0;
        }

        // summing up the colors
        phongR = (ambientR + diffuseR + specularR);
        phongG = (ambientG + diffuseG + specularG);
        phongB = (ambientB + diffuseB + specularB);

        return color(phongR, phongG, phongB);
    }
}