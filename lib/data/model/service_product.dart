import 'package:service_app/util/base_entity.dart';
import 'package:service_app/util/id_generator.dart';

class ServiceProduct implements BaseEntity {
  @override
  final String id;

  final String serialNumber;
  final String name;
  final String description;
  final DateTime purchaseDate;

  const ServiceProduct._private(this.id, this.serialNumber, this.name, this.description, this.purchaseDate);

  ServiceProduct(this.serialNumber, this.name, this.description, this.purchaseDate)
    : id = IdGenerator.generatePushChildName();

  static ServiceProduct fromJsonMap(String number, Map<dynamic, dynamic> map) {
    return ServiceProduct._private(
      number,
      map["serialNumber"],
      map["name"],
      map["description"],
      DateTime.parse(map["purchaseDate"]),
    );
  }

  @override
  Map<String, dynamic> toJsonMap() {
    return {
      "serialNumber": serialNumber,
      "name": name,
      "description": description,
      "purchaseDate": purchaseDate,
    };
  }
}
