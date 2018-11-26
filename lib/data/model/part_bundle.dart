import 'package:service_app/data/model/part.dart';
import 'package:service_app/util/id_generator.dart';
import 'package:service_app/util/identifiable.dart';

class PartBundle implements Identifiable {
  @override
  final String id;

  final int quantity;
  final String unit;
  final Part part;

  const PartBundle._private(this.id, this.quantity, this.unit, this.part);

  PartBundle(this.quantity, this.unit, this.part) : id = IdGenerator.generatePushChildName();

  static PartBundle fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return PartBundle._private(
      id,
      map["quantity"],
      map["unit"],
      Part.fromJsonMap(null, map),
    );
  }

  @override
  Map<dynamic, dynamic> toJsonMap() {
    return {
      "quantity": quantity,
      "unit": unit,
      "part": part.toJsonMap(),
    };
  }
}
