import 'package:service_app/data/model/appointment.dart';
import 'package:service_app/data/model/part_bundle.dart';

class ServiceProduct {
  final String id;
  final String name;
  final String description;
  final Appointment appointment;
  final List<PartBundle> parts;

  const ServiceProduct(this.id, this.name, this.description, this.appointment, this.parts);

  static ServiceProduct fromJsonMap(String id, Map<String, dynamic> map) {
    return ServiceProduct(
        id,
        map["name"],
        map["description"],
        Appointment.fromJsonMap(null, map["appointment"]),
        (map.containsKey("appointments")
            ? (map["appointments"] as List<Map<String, dynamic>>).map((appointmentMap) =>
            PartBundle.fromJsonMap(null, appointmentMap))
            : [])
    );
  }

  Map<String, dynamic> toJsonMap() {
    return {
      "name": name,
      "description": description,
      "appointment": appointment.toJsonMap(),
      "parts": parts.map((bundle) => bundle.toJsonMap())
    };
  }
}
