import 'package:startup_namer/data/model/part.dart';

class PartBundle {
  final int id;
  final int quantity;
  final String unit;
  final Part part;

  const PartBundle(this.id, this.quantity, this.unit, this.part);
}
