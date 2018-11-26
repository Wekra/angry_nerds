import 'package:service_app/util/id_generator.dart';
import 'package:service_app/util/identifiable.dart';

class WarehouseOrder implements Identifiable {
  @override
  final String id;

  final String description;
  final DateTime orderDateTime;
  final WarehouseOrderStatus status;

  const WarehouseOrder._private(this.id, this.description, this.orderDateTime, this.status);

  WarehouseOrder(this.description, this.orderDateTime, this.status) : id = IdGenerator.generatePushChildName();

  static WarehouseOrder fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return WarehouseOrder._private(
      id,
      map["description"],
      DateTime.parse(map["orderDateTime"]),
      WarehouseOrderStatus.values.firstWhere((v) => v.toString() == "status"),
    );
  }

  @override
  Map<dynamic, dynamic> toJsonMap() {
    return {
      "description": description,
      "orderDateTime": orderDateTime.toIso8601String(),
      "status": status.toString(),
    };
  }
}

enum WarehouseOrderStatus { open, inProgress, delivered, cancelled }
