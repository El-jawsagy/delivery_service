class PackageTypeModel {
  final int id;
  final String name;

  PackageTypeModel({this.id, this.name});

  factory PackageTypeModel.fromJson(Map<String, dynamic> jsonObject) {
    return PackageTypeModel(
      id: jsonObject["id"],
      name: jsonObject["name"],
    );
  }
}