import 'package:startup_namer/data/model/address.dart';

class Customer {
  final int id;
  final String name;
  final String mail;
  final String phone;
  final Address address;

  const Customer(this.id, this.name, this.mail, this.phone, this.address);
}
