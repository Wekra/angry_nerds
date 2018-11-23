import 'package:service_app/data/model/part_bundle.dart';

class WarehouseOrder {
  final String id;
  final DateTime orderTime;
  final WarehouseOrderStatus status;
  final List<PartBundle> partBundles;

  const WarehouseOrder(this.id, this.orderTime, this.status, this.partBundles);

  static WarehouseOrder fromJsonMap(String id, Map<String, dynamic> map) {
    return WarehouseOrder(
        id,
        DateTime.parse(map["orderTime"]),
        WarehouseOrderStatus.values.firstWhere((v) => v.toString() == "status"),
        map.containsKey("partBundles")
            ? (map["partBundles"] as List<Map<String, dynamic>>)
            .map((partBundleMap) => PartBundle.fromJsonMap(null, partBundleMap))
            : []);
  }

  Map<String, dynamic> toJsonMap() {
    return {
      "orderTime": orderTime.toIso8601String(),
      "status": status.toString(),
      "partBundles": partBundles.map((bundle) => bundle.toJsonMap())
    };
  }
}

enum WarehouseOrderStatus { open, delivered }
