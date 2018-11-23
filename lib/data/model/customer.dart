import 'package:service_app/data/model/address.dart';

class Customer {
  final String id;
  final String name;
  final String mail;
  final String phone;
  final Address address;

  const Customer(this.id, this.name, this.mail, this.phone, this.address);

  static Customer fromJsonMap(String id, Map<String, dynamic> map) {
    return Customer(
        id,
        map["name"],
        map["mail"],
        map["phone"],
        map["address"]
    );
  }

  Map<String, dynamic> toJsonMap() {
    return {
      "name": name,
      "mail": mail,
      "phone": phone,
      "address": address.toJsonMap(),
    };
  }
}
