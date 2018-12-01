import 'package:service_app/util/identifiable.dart';

class Technician implements Identifiable {
  @override
  final String id;

  final String name;
  final String mail;
  final String phone;
  final String warehouseName;

  const Technician(this.id, this.name, this.mail, this.phone, this.warehouseName);

  static Technician fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return Technician(
      id,
      map["name"],
      map["mail"],
      map["phone"],
      map["warehouseName"],
    );
  }

  @override
  Map<String, dynamic> toJsonMap() {
    return {
      "name": name,
      "mail": mail,
      "phone": phone,
      "warehouseName": warehouseName,
    };
  }
}
