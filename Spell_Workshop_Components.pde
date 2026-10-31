JSONParser parser;
String componentName = "";
String shapeList = "";
int textSize = 16;

int boxPadding = 3;

int nameBoxX = 10;
int nameBoxY = 10;
int nameWidth = 200;
int nameHeight = 30;

int shapeBoxX = 10;
int shapeBoxY = 50;
int shapeBoxWidth = 200;
int shapeBoxHeight = 400;

int activeBox = 0;

int addButtonX = 10;
int addButtonY = 460;
int addButtonWidth = 50;
int addButtonHeight = 30;

int saveButtonX = 70;
int saveButtonY = 460;
int saveButtonWidth = 50;
int saveButtonHeight = 30;

int displayBoxX = 220;
int displayBoxY = 10;
int displayBoxWidth = 400;
int displayBoxHeight = 440;
int displayScrollY = 0;

PGraphics displayScrollBox;

int bgBrightness = 80;

void setup(){
  parser = new JSONParser();
  parser.loadJSON();
  
  displayScrollBox = createGraphics(displayBoxWidth - boxPadding, displayBoxHeight - boxPadding);
  
  textSize(textSize);
  
  size(630,600);
}

void draw(){
  background(bgBrightness);
  bgBrightness --;
  bgBrightness = bgBrightness < 80 ? 80 : bgBrightness;
  
  rect(nameBoxX, nameBoxY, nameWidth, nameHeight);
  rect(shapeBoxX, shapeBoxY, shapeBoxWidth, shapeBoxHeight);
  rect(displayBoxX, displayBoxY, displayBoxWidth, displayBoxHeight);
  
  rect(addButtonX, addButtonY, addButtonWidth, addButtonHeight);
  rect(saveButtonX, saveButtonY, saveButtonWidth, saveButtonHeight);
  
  fill(0);
  textAlign(CENTER, CENTER);
  text(componentName, nameBoxX, nameBoxY, nameWidth, nameHeight);
  text("Add", addButtonX, addButtonY, addButtonWidth, addButtonHeight);
  text("Save", saveButtonX, saveButtonY, saveButtonWidth, saveButtonHeight);
  textAlign(LEFT, TOP);
  text(shapeList, shapeBoxX + boxPadding, shapeBoxY + boxPadding, shapeBoxWidth - boxPadding, shapeBoxHeight - boxPadding);
  fill(255);
  
  displayScrollBox.beginDraw();
  displayScrollBox.background(255);
  displayScrollBox.textSize(textSize);
  displayScrollBox.fill(0);
  displayScrollBox.text(parser.getTree(), 0, displayScrollY);
  displayScrollBox.fill(255);
  displayScrollBox.endDraw();
  image(displayScrollBox, displayBoxX + boxPadding, displayBoxY + boxPadding, displayBoxWidth - boxPadding, displayBoxHeight - boxPadding);
}

void keyPressed() {
  if (key != CODED){
    if (key >= 'a' && key <= 'z'){
      addToBox(key);
    }
    if (key >= 'A' && key <= 'Z'){
      addToBox(key);
    }
    if (key == ' ' || key == ','){
      addToBox(key);
    }
  }
  if (key == BACKSPACE){
    popLastLetter();
  }
  if (key == TAB){
    activeBox++;
    activeBox %= 2;
  }
  if (key == ENTER){
    addToJSON();
  }
}

void addToBox(char letter){
  if (activeBox == 0){
    componentName += letter;
  }
  else{
    shapeList += letter;
  }
}

void popLastLetter(){
  if (activeBox == 0){
    int end = componentName.length() - 1;
    end = end < 0 ? 0 : end;
    componentName = componentName.substring(0, end);
  }
  else{
    int end = shapeList.length() - 1;
    end = end < 0 ? 0 : end;
    shapeList = shapeList.substring(0, end);
  }
}

void mouseClicked(){
  if (mouseX >= nameBoxX && mouseX <= nameBoxX + nameWidth){
    if (mouseY >= nameBoxY && mouseY <= nameBoxY + nameHeight){
      activeBox = 0;
    }
  }
  if (mouseX >= shapeBoxX && mouseX <= shapeBoxX + shapeBoxWidth){
    if (mouseY >= shapeBoxY && mouseY <= shapeBoxY + shapeBoxHeight){
      activeBox = 1;
    }
  }
  if (mouseX >= addButtonX && mouseX <= addButtonX + addButtonWidth){
    if (mouseY >= addButtonY && mouseY <= addButtonY + addButtonHeight){
      addToJSON();
    }
  }
  if (mouseX >= saveButtonX && mouseX <= saveButtonX + saveButtonWidth){
    if (mouseY >= saveButtonY && mouseY <= saveButtonY + saveButtonHeight){
      parser.saveJSON();
      println("Saved!");
      bgBrightness = 200;
    }
  }
}

void mouseWheel(MouseEvent event){
  displayScrollY += event.getCount() * -10;
}

void addToJSON(){
  parser.addComponent(componentName);
  JSONObject shapesJSON = parser.getShapes(componentName);
  String[] shapes = shapeList.split(",");
  for (String shape: shapes){
    parser.addShape(shapesJSON, shape.trim(), 5);
  }
}
