import 'package:service_app/data/model/base_entity.dart';
import 'package:service_app/util/id_generator.dart';

class ServiceProduct implements BaseEntity {
  @override
  final String id;

  final String name;
  final String description;

  const ServiceProduct._private(this.id, this.name, this.description);

  ServiceProduct(this.name, this.description) : id = IdGenerator.generatePushChildName();

  static ServiceProduct fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return ServiceProduct._private(
      id,
      map["name"],
      map["description"],
    );
  }

  @override
  Map<String, dynamic> toJsonMap() {
    return {
      "name": name,
      "description": description,
    };
  }
}
