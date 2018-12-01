import 'package:service_app/data/model/base_entity.dart';
import 'package:service_app/util/id_generator.dart';

class PartBundle implements BaseEntity {
  @override
  final String id;

  final int quantity;
  final PartUnit unit;
  final int partId;

  const PartBundle._private(this.id, this.quantity, this.unit, this.partId);

  PartBundle(this.quantity, this.unit, this.partId) : id = IdGenerator.generatePushChildName();

  static PartBundle fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return PartBundle._private(
      id,
      map["quantity"],
      PartUnit.values.firstWhere((v) => v.toString() == map["unit"]),
      map["partId"],
    );
  }

  @override
  Map<String, dynamic> toJsonMap() {
    return {
      "quantity": quantity,
      "unit": unit.toString(),
      "partId": partId,
    };
  }
}

enum PartUnit { amount, litres, grams, metres }
