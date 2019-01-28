import 'package:service_app/data/model/part_bundle.dart';
import 'package:service_app/util/base_entity.dart';

class WarehouseOrder implements BaseEntity {
  @override
  final String id;

  final String description;
  final DateTime orderDateTime;
  final WarehouseOrderStatus status;
  final String statusNote;
  final List<PartBundle> partBundles;

  const WarehouseOrder(this.id, this.description, this.orderDateTime, this.status, this.statusNote,
      this.partBundles);

  static WarehouseOrder fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return WarehouseOrder(
      id,
      map["description"],
      DateTime.parse(map["orderDateTime"]),
      WarehouseOrderStatus.values.firstWhere((v) => v.toString() == map["status"]),
      map["statusNote"],
      BaseEntity.fromMap(map["partBundles"], PartBundle.fromJsonMap),
    );
  }

  @override
  Map<String, dynamic> toJsonMap() {
    return {
      "description": description,
      "orderDateTime": orderDateTime.toIso8601String(),
      "status": status.toString(),
      "statusNote": statusNote,
      "partBundles": BaseEntity.toMap(partBundles),
    };
  }
}

enum WarehouseOrderStatus { open, inProgress, delivered, cancelled }
