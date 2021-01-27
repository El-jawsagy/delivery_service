class ShipmentModel {
  final String receiverName,
      receiverPhone,
      receiverAddress,
      receiverFloor,
      packageDescription,
      receiverApartment,
      receiverBuildNumber,
      status,
      packageType,
      receiverArea,
      receiverCity,
      packagePrice;

  final int id, packageNumOfItems;

  ShipmentModel({
    this.id,
    this.receiverName,
    this.receiverPhone,
    this.receiverAddress,
    this.receiverApartment,
    this.receiverFloor,
    this.receiverBuildNumber,
    this.packageNumOfItems,
    this.packageType,
    this.status,
    this.packageDescription,
    this.receiverArea,
    this.receiverCity,
    this.packagePrice,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> jsonObject) {
    return ShipmentModel(
      id: jsonObject["id"],
      receiverName: jsonObject["receiver_name"],
      receiverPhone: jsonObject["receiver_phone"],
      receiverAddress: jsonObject["receiver_address"],
      receiverApartment: jsonObject["receiver_apartment"],
      receiverFloor: jsonObject["receiver_floor"],
      receiverBuildNumber: jsonObject["receiver_building_number"],
      packageNumOfItems: jsonObject["package_number_of_items"],
      packageType: jsonObject["package_type"],
      packageDescription: jsonObject["package_description"],
      status: jsonObject["status"],
      receiverArea: jsonObject["area"],
      receiverCity: jsonObject["city"],
      packagePrice: jsonObject["package_price"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "receiver_name": this.receiverName,
      "receiver_phone": this.receiverPhone,
      "receiver_address": this.receiverAddress,
      "receiver_apartment": this.receiverApartment,
      "receiver_building_number": this.receiverApartment,
      "receiver_floor": this.receiverFloor,
      "package_number_of_items": this.packageNumOfItems,
      "package_type": this.packageType,
      "status": this.status,
      "package_description": this.packageDescription,
      "area": this.receiverArea,
      "city": this.receiverCity,
    };
  }
}
