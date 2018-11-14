import 'package:startup_namer/data/model/appointment.dart';
import 'package:startup_namer/data/model/part_bundle.dart';

class ServiceProduct {
  final int id;
  final String name;
  final String description;
  final Appointment appointment;
  final List<PartBundle> parts;

  const ServiceProduct(this.id, this.name, this.description, this.appointment, this.parts);
}
