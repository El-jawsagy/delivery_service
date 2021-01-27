class PickupLocationModel {
  final String name, street, buildingNumber, floor, apartment, city, area;
  final int id;

  PickupLocationModel({
    this.id,
    this.name,
    this.street,
    this.buildingNumber,
    this.floor,
    this.apartment,
    this.city,
    this.area,
  });

  factory PickupLocationModel.fromJson(Map<String, dynamic> jsonObject) {
    return PickupLocationModel(
       id: jsonObject["id"],
       name: jsonObject["name"],
       street: jsonObject["street"],
       buildingNumber: jsonObject["building_number"],
       floor: jsonObject["floor"],
       apartment: jsonObject["apartment"],
       city: jsonObject["city"],
       area: jsonObject["area"],

    );
  }

}
