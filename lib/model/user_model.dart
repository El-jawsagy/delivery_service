class UserModel {
  final String firstName,
      lastName,
      company,
      email,
      phoneNumber,
      subscripitionType;

  final int id;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.subscripitionType,
    this.company,
  });

  factory UserModel.fromJson(Map<String, dynamic> jsonObject) {
    return UserModel(
      id: jsonObject["id"],
      firstName: jsonObject["first_name"],
      lastName: jsonObject["last_name"],
      email: jsonObject["email"],
      phoneNumber: jsonObject["phone_number"],
      subscripitionType: jsonObject["subscribtion_type"],
      company: jsonObject["company"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "first_name": this.firstName,
      "last_name": this.lastName,
      "email": this.email,
      "phone_number": this.phoneNumber,
      "subscription_type": this.subscripitionType,
      "company": this.company,
    };
  }

  Map<String, dynamic> toJsonForRegister() {
    return {
      "first_name": this.firstName,
      "last_name": this.lastName,
      "email": this.email,
      "phone_number": this.phoneNumber,
      "subscription_type": this.subscripitionType,
    };
  }
}
