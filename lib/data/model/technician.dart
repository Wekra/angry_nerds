import 'package:service_app/util/id_generator.dart';
import 'package:service_app/util/identifiable.dart';

class Technician implements Identifiable {
  @override
  final String id;

  final String name;
  final String mail;
  final String phone;

  const Technician._private(this.id, this.name, this.mail, this.phone);

  Technician(this.name, this.mail, this.phone) : id = IdGenerator.generatePushChildName();

  static Technician fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return Technician._private(
      id,
      map["name"],
      map["mail"],
      map["phone"],
    );
  }

  @override
  Map<dynamic, dynamic> toJsonMap() {
    return {
      "name": name,
      "mail": mail,
      "phone": phone,
    };
  }
}
