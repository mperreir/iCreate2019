
Branch currentBranch;
PGraphics currentGraphic;

import fisica.*;
FWorld world;

Arbre arbre;


void setup() {
  fullScreen();
  currentBranch = new Branch();
  currentGraphic = createGraphics(width, height);
  Fisica.init(this);
  world = new FWorld();
  arbre = new Arbre(world);
}

void draw() {
  background(204);
  image(currentGraphic, 0, 0);
  arbre.step();
  arbre.draw();
  world.step();
  world.draw();
}


void mousePressed() {
  if (currentBranch.points.size() == 0 ) {
    currentBranch.growBranch(new Point(mouseX, mouseY));
  }
  currentBranch.growBranch(new Point(mouseX, mouseY));
  currentGraphic = currentBranch.drawBranchCurve(100);
}

void keyPressed() {
  println(keyCode);
  //n to create new branch
  if (keyCode == 78) {
    arbre.branchesArbre.add(currentBranch);
    arbre.graphicBranches.add(currentBranch.drawBranchCurve(0));
    arbre.drawBranchage();
    currentBranch = new Branch();
    currentGraphic = createGraphics(width, height);
  }
  //r to register in file
  if (keyCode == 82) {
    selectOutput("Save branch to file :", "saveBranches");
  }
  //t to load branches file
  if (keyCode == 84) {
    selectInput("Load branches from file :", "loadBranches");
  }

  //u to load leaf
  if (keyCode == 85) {
    arbre.brancheFeuille();
  }
  //v to remove the actual branch
  if (keyCode == 86) {
    currentBranch = new Branch();
    currentGraphic = createGraphics(width, height);
  }
  //w to remove leaf
  if (keyCode == 87) {
    arbre.destroyLeaf(15);
  }

  //x to remove actual branch and come back to last branch
  if (keyCode == 88) {
    if (arbre.branchesArbre.size() > 0) {
      currentBranch = arbre.branchesArbre.get(arbre.branchesArbre.size()-1);
      arbre.branchesArbre.remove(arbre.branchesArbre.size()-1);
      currentGraphic = currentBranch.drawBranchCurve(160);
      arbre.graphicBranches.remove(arbre.graphicBranches.size()-1);
      arbre.drawBranchage();
    } else {
      currentBranch = new Branch();
      currentGraphic = currentBranch.drawBranchCurve(160);
      arbre.drawBranchage();
    }
  }

  //y to activate wind
  if (keyCode == 89) {
    arbre.setTimeFrame(100);
  }
}


void saveBranches(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    saveBranchesToJson(selection.getAbsolutePath());
  }
}


void saveBranchesToJson(String file) {

  JSONArray tree = new JSONArray();

  for (int i = 0; i < arbre.branchesArbre.size(); i++) {

    JSONObject branch = new JSONObject();
    branch.setJSONArray("branch", arbre.branchesArbre.get(i).toJSONArray());

    tree.setJSONObject(i, branch);
  }

  saveJSONArray(tree, file);
}

void loadBranches(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    arbre.loadBranchesFromJson(selection.getAbsolutePath());
  }
}
