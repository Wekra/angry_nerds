import 'package:service_app/util/id_generator.dart';
import 'package:service_app/util/identifiable.dart';

class Warehouse implements Identifiable {
  @override
  final String id;

  final String name;

  const Warehouse._private(this.id, this.name);

  Warehouse(this.name) : id = IdGenerator.generatePushChildName();

  static Warehouse fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return Warehouse._private(
      id,
      map["name"],
    );
  }

  @override
  Map<dynamic, dynamic> toJsonMap() {
    return {
      "name": name,
    };
  }
}
