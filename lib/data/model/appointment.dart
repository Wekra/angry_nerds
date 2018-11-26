import 'package:service_app/util/id_generator.dart';
import 'package:service_app/util/identifiable.dart';

class Appointment implements Identifiable {
  @override
  final String id;

  final String description;
  final DateTime scheduledStartDateTime;
  final DateTime scheduledEndDateTime;
  final DateTime creationDateTime;
  final List<AppointmentInterval> intervals;

  const Appointment._private(this.id, this.description, this.scheduledStartDateTime, this.scheduledEndDateTime,
      this.creationDateTime, this.intervals);

  Appointment(this.description, this.scheduledStartDateTime, this.scheduledEndDateTime, this.creationDateTime,
      this.intervals)
      : id = IdGenerator.generatePushChildName();

  static Appointment fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return Appointment._private(
      id,
      map["description"],
      DateTime.parse(map["scheduledStartDateTime"]),
      DateTime.parse(map["scheduledEndDateTime"]),
      DateTime.parse(map["creationDateTime"]),
      Identifiable.fromMap(map["intervals"], AppointmentInterval.fromJsonMap),
    );
  }

  @override
  Map<dynamic, dynamic> toJsonMap() {
    return {
      "description": description,
      "scheduledStartDateTime": scheduledStartDateTime.toIso8601String(),
      "scheduledEndDateTime": scheduledEndDateTime.toIso8601String(),
      "creationDateTime": creationDateTime.toIso8601String(),
      "intervals": Identifiable.toMap(intervals),
    };
  }
}

class AppointmentInterval implements Identifiable {
  @override
  final String id;

  final DateTime startDateTime;
  final DateTime endDateTime;

  const AppointmentInterval._private(this.id, this.startDateTime, this.endDateTime);

  AppointmentInterval(this.startDateTime, this.endDateTime) : id = IdGenerator.generatePushChildName();

  static AppointmentInterval fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return AppointmentInterval._private(
      id,
      DateTime.parse(map["startDateTime"]),
      DateTime.parse(map["endDateTime"]),
    );
  }

  @override
  Map<dynamic, dynamic> toJsonMap() {
    return {
      "startDateTime": startDateTime.toIso8601String(),
      "endDateTime": endDateTime.toIso8601String(),
    };
  }
}
