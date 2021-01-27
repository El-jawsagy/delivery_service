class AreaModel {
  final int id;
  final String name;

  AreaModel({this.id, this.name});

  factory AreaModel.fromJson(Map<String, dynamic> jsonObject) {
    return AreaModel(
      id: jsonObject["id"],
      name: jsonObject["name"],
    );
  }
}
