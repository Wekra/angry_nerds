import 'package:startup_namer/data/model/part_bundle.dart';

class Warehouse {
  final int id;
  final String name;
  final List<PartBundle> parts;

  const Warehouse(this.id, this.name, this.parts);
}
