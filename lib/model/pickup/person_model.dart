class PersonModel {
  final String email, lastName, firstName, secondaryPhoneNumber, phoneNumber;
  final int id;

  // final int defaultPerson;
  PersonModel({
    this.id,
    this.email,
    this.lastName,
    this.firstName,
    // this.defaultPerson,
    this.secondaryPhoneNumber,
    this.phoneNumber,
  });

  factory PersonModel.fromJson(Map<String, dynamic> jsonObject) {
    return PersonModel(
      id: jsonObject["id"],
      email: jsonObject["email"],
      lastName: jsonObject["last_name"],
      firstName: jsonObject["first_name"],
      // defaultPerson: jsonObject["default"],
      secondaryPhoneNumber: jsonObject["secondary_phone_number"],
      phoneNumber: jsonObject["phone_number"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      // "default": this.defaultPerson,
      "first_name": this.firstName,
      "last_name": this.lastName,
      "phone_number": this.phoneNumber,
      "secondary_phone_number": this.secondaryPhoneNumber,
      "email": this.email,
    };
  }
}
