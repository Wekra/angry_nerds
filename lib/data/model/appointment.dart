import 'package:service_app/util/id_generator.dart';
import 'package:service_app/util/identifiable.dart';

class Appointment implements Identifiable {
  @override
  final String id;

  final String description;
  final DateTime scheduledStartTime;
  final DateTime scheduledEndTime;
  final DateTime creationTime;
  final List<AppointmentInterval> intervals;

  const Appointment._private(this.id, this.description, this.scheduledStartTime, this.scheduledEndTime,
      this.creationTime, this.intervals);

  Appointment(this.description, this.scheduledStartTime, this.scheduledEndTime, this.creationTime, this.intervals)
      : id = IdGenerator.generatePushChildName();

  static Appointment fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return Appointment._private(
      id,
      map["description"],
      DateTime.parse(map["scheduledStartTime"]),
      DateTime.parse(map["scheduledEndTime"]),
      DateTime.parse(map["creationTime"]),
      Identifiable.fromMap(map["intervals"], AppointmentInterval.fromJsonMap),
    );
  }

  @override
  Map<dynamic, dynamic> toJsonMap() {
    return {
      "description": description,
      "scheduledStartTime": scheduledStartTime.toIso8601String(),
      "scheduledEndTime": scheduledEndTime.toIso8601String(),
      "creationTime": creationTime.toIso8601String(),
      "intervals": Identifiable.toMap(intervals),
    };
  }
}

class AppointmentInterval implements Identifiable {
  @override
  final String id;

  final DateTime startTime;
  final DateTime endTime;

  const AppointmentInterval._private(this.id, this.startTime, this.endTime);

  AppointmentInterval(this.startTime, this.endTime) : id = IdGenerator.generatePushChildName();

  static AppointmentInterval fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return AppointmentInterval._private(
      id,
      DateTime.parse(map["startTime"]),
      DateTime.parse(map["endTime"]),
    );
  }

  @override
  Map<dynamic, dynamic> toJsonMap() {
    return {
      "startTime": startTime.toIso8601String(),
      "endTime": endTime.toIso8601String(),
    };
  }
}
