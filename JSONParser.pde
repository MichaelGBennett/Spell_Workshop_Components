class JSONParser{

  String path = "data/components.json";
  String rootObject = "components";
  
  JSONObject json;
  
  void loadJSON(){
    try {
      json = loadJSONObject(path);
    }
    catch(Exception e){
      json = new JSONObject();
      json.setJSONObject(rootObject, new JSONObject());
      println(e);
    }
  }
  
  void addComponent(String componentName){
    JSONObject components = json.getJSONObject(rootObject);
    JSONObject shapes = new JSONObject();
    shapes.setJSONObject("shapes", new JSONObject());
    components.setJSONObject(componentName, shapes);
  }
  
  JSONObject getComponents(){
    return json.getJSONObject(rootObject);
  }
  
  JSONObject addShape(JSONObject component, String shape, int weight){
    return component.setInt(shape, weight);
  }
  
  JSONObject getShapes(String componentName){
    return json.getJSONObject(rootObject).getJSONObject(componentName).getJSONObject("shapes");
  }
  
  void saveJSON(){
    saveJSONObject(json, path);
  }
}
