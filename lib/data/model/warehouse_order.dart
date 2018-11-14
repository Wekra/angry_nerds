import 'package:startup_namer/data/model/part_bundle.dart';

class WarehouseOrder {
  final int id;
  final DateTime orderTime;
  final WarehouseOrderStatus status;
  final List<PartBundle> parts;

  const WarehouseOrder(this.id, this.orderTime, this.status, this.parts);
}

enum WarehouseOrderStatus { open, delivered }
