import 'package:service_app/data/model/base_entity.dart';
import 'package:service_app/util/id_generator.dart';

class BaseAppointment implements BaseEntity {
  @override
  final String id;

  final String description;
  final DateTime scheduledStartDateTime;
  final DateTime scheduledEndDateTime;
  final DateTime creationDateTime;

  const BaseAppointment(this.id, this.description, this.scheduledStartDateTime, this.scheduledEndDateTime,
      this.creationDateTime);

  @override
  Map<String, dynamic> toJsonMap() {
    return {
      "description": description,
      "scheduledStartDateTime": scheduledStartDateTime.toIso8601String(),
      "scheduledEndDateTime": scheduledEndDateTime.toIso8601String(),
      "creationDateTime": creationDateTime.toIso8601String(),
    };
  }
}

class Appointment extends BaseAppointment {
  final List<AppointmentInterval> intervals;

  Appointment(String id, String description, DateTime scheduledStartDateTime, DateTime scheduledEndDateTime,
      DateTime creationDateTime, this.intervals)
      : super(id, description, scheduledStartDateTime, scheduledEndDateTime, creationDateTime);

  static Appointment fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return Appointment(
      id,
      map["description"],
      DateTime.parse(map["scheduledStartDateTime"]),
      DateTime.parse(map["scheduledEndDateTime"]),
      DateTime.parse(map["creationDateTime"]),
      BaseEntity.fromMap(map["intervals"], AppointmentInterval.fromJsonMap),
    );
  }

  @override
  Map<String, dynamic> toJsonMap() {
    Map<String, dynamic> map = super.toJsonMap();
    map["intervals"] = BaseEntity.toMap(intervals);
    return map;
  }
}

class AppointmentInterval implements BaseEntity {
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
  Map<String, dynamic> toJsonMap() {
    return {
      "startDateTime": startDateTime.toIso8601String(),
      "endDateTime": endDateTime.toIso8601String(),
    };
  }
}
