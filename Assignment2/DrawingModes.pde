final char KEY_NEXT_SHADING = 's';
final char KEY_PREV_SHADING = 'w';

final int NUM_SHADING_MODES = ShadingMode.values().length;

enum ShadingMode {
    NONE, // no shading
    FLAT, // solid colour
    PHONG_LIGHTING, // visualize barycentric coords
    REFLECTIONS_SHADOWS, // Phong lighting calculated at triangle centers
}
ShadingMode shadingMode = ShadingMode.NONE;

void keyPressed() {
  if (key == KEY_NEXT_SHADING) {
    int nextShading = getNextOrdinal(shadingMode, NUM_SHADING_MODES);
    shadingMode = ShadingMode.values()[nextShading];
  } else if (key == KEY_PREV_SHADING) {
    int prevShading = getPreviousOrdinal(shadingMode, NUM_SHADING_MODES);
    shadingMode = ShadingMode.values()[prevShading];
  }
  redraw();
  printSettings();
}

int getNextOrdinal(Enum e, int enumLength) {
  return (e.ordinal() + 1) % enumLength;
}

int getPreviousOrdinal(Enum e, int enumLength) {
  return (e.ordinal() + enumLength - 1) % enumLength;
}

void printSettings() {
  String settings = "";
  settings += "Shading Mode: " + shadingMode + "  ";
  println(settings);
}
