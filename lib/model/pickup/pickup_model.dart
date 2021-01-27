import '../shipment/shipment_model.dart';

class PickupModel {
  final String notes,
      personName,
      personPhone,
  pickupLocation,
      repeatType,
      repeatStart,
      repeatEnd,
      date,
      status;

  final int id, repeat;
   ShipmentModel shipment;

  PickupModel({
    this.notes,
    this.personName,
    this.personPhone,
    this.pickupLocation,
    this.repeatType,
    this.repeatStart,
    this.repeatEnd,
    this.date,
    this.id,
    this.repeat,
    this.status,
    this.shipment,
  });

  factory PickupModel.fromJson(Map<String, dynamic> jsonObject) {
    return PickupModel(
      id: jsonObject["id"],
      repeat: jsonObject["repeat"],
      repeatStart: jsonObject["repeat_start_date"],
      pickupLocation: jsonObject["pickup_location_name"],
      repeatEnd: jsonObject["repeat_end_date"],
      repeatType: jsonObject["repeat_type"],
      date: jsonObject["date"],
      status: jsonObject["status"],
      notes: jsonObject["notes"],
      personName: jsonObject["person_name"],
      personPhone: jsonObject["person_phone"],
      shipment: ShipmentModel.fromJson(jsonObject)
    );
  }



  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "shipment_id": this.shipment.id,
      "repeat": this.repeat,
      "repeat_start_date": this.repeatStart,
      "repeat_end_date": this.repeatEnd,
      "repeat_type": this.repeatType,
      "date": this.date,
      "notes": this.notes,
    };
  }
}
