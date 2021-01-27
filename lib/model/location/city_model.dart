class CityModel {
  final int id;
  final String name;

  CityModel({
    this.id,
    this.name,
  });

  factory CityModel.fromJson(Map<String, dynamic> jsonObject) {
    return CityModel(
      id: jsonObject["id"],
      name: jsonObject["name"],
    );
  }
}
