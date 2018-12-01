import 'package:service_app/data/model/part_bundle.dart';
import 'package:service_app/util/id_generator.dart';
import 'package:service_app/util/identifiable.dart';

class WarehouseOrder implements Identifiable {
  @override
  final String id;

  final String description;
  final DateTime orderDateTime;
  final WarehouseOrderStatus status;
  final String statusNote;
  final List<PartBundle> partBundles;

  const WarehouseOrder._private(this.id, this.description, this.orderDateTime, this.status, this.statusNote,
      this.partBundles);

  WarehouseOrder(this.description, this.orderDateTime, this.status, this.statusNote, this.partBundles)
      : id = IdGenerator.generatePushChildName();

  static WarehouseOrder fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return WarehouseOrder._private(
      id,
      map["description"],
      DateTime.parse(map["orderDateTime"]),
      WarehouseOrderStatus.values.firstWhere((v) => v.toString() == map["status"]),
      map["statusNote"],
      Identifiable.fromMap(map["partBundles"], PartBundle.fromJsonMap),
    );
  }

  @override
  Map<String, dynamic> toJsonMap() {
    return {
      "description": description,
      "orderDateTime": orderDateTime.toIso8601String(),
      "status": status.toString(),
      "statusNote": statusNote,
      "partBundles": Identifiable.toMap(partBundles),
    };
  }
}

enum WarehouseOrderStatus { open, inProgress, delivered, cancelled }
