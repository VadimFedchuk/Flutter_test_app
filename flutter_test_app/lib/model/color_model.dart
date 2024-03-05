class ColorModel {
  int id = 0;
  String color = "";

  ColorModel({required this.id, required this.color});

  ColorModel.fromMap(Map<String, dynamic> item) {
    id = item["id"] as int;
    color = item["color"] as String;
  }

  Map<String, Object> toMap(){
    return {'id':id,'color': color};
  }
}
