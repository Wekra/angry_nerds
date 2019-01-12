import 'package:service_app/util/base_entity.dart';
import 'package:service_app/util/id_generator.dart';

class PartBundle implements BaseEntity {
  @override
  final String id;

  final int quantity;
  final String partId;

  const PartBundle._private(this.id, this.quantity, this.partId);

  PartBundle(this.quantity, this.partId) : id = IdGenerator.generatePushChildName();

  static PartBundle fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return PartBundle._private(
      id,
      map["quantity"],
      map["partId"],
    );
  }

  @override
  Map<String, dynamic> toJsonMap() {
    return {
      "quantity": quantity,
      "partId": partId,
    };
  }
}
