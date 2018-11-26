import 'package:service_app/util/id_generator.dart';
import 'package:service_app/util/identifiable.dart';

class Customer implements Identifiable {
  @override
  final String id;

  final String name;
  final String mail;
  final String phone;
  final Address address;

  const Customer._private(this.id, this.name, this.mail, this.phone, this.address);

  Customer(this.name, this.mail, this.phone, this.address) : id = IdGenerator.generatePushChildName();

  static Customer fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return Customer._private(
      id,
      map["name"],
      map["mail"],
      map["phone"],
      Address.fromJsonMap(map["address"]),
    );
  }

  @override
  Map<dynamic, dynamic> toJsonMap() {
    return {
      "name": name,
      "mail": mail,
      "phone": phone,
      "address": address.toJsonMap(),
    };
  }
}

class Address {
  final String street;
  final String houseNumber;
  final String zip;
  final String city;
  final String country;
  final double latitude;
  final double longitude;

  const Address(this.street, this.houseNumber, this.zip, this.city, this.country, this.latitude, this.longitude);

  static Address fromJsonMap(Map<dynamic, dynamic> map) {
    return Address(
      map["street"],
      map["houseNumber"],
      map["zip"],
      map["city"],
      map["country"],
      map["latitude"],
      map["longitude"],
    );
  }

  Map<dynamic, dynamic> toJsonMap() {
    return {
      "street": street,
      "houseNumber": houseNumber,
      "zip": zip,
      "city": city,
      "country": country,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
