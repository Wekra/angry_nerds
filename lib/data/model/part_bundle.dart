import 'package:service_app/data/model/part.dart';

class PartBundle {
  final String id;
  final int quantity;
  final String unit;
  final Part part;

  const PartBundle(this.id, this.quantity, this.unit, this.part);

  static PartBundle fromJsonMap(String id, Map<String, dynamic> map) {
    return PartBundle(
        id,
        map["quantity"],
        map["unit"],
        Part.fromJsonMap(null, map)
    );
  }

  Map<String, dynamic> toJsonMap() {
    return {
      "quantity": quantity,
      "unit": unit,
      "part": part.toJsonMap()
    };
  }
}
