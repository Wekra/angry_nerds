import 'dart:convert';

class Appointment {
  final String id;
  final String description;
  final DateTime scheduledStartTime;
  final DateTime scheduledEndTime;
  final DateTime creationTime;
  final List<AppointmentInterval> intervals;

  const Appointment(this.id, this.description, this.scheduledStartTime, this.scheduledEndTime, this.creationTime,
      this.intervals);

  static Appointment fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return Appointment(
        id,
        map["description"],
        DateTime.parse(map["scheduledStartTime"]),
        DateTime.parse(map["scheduledEndTime"]),
        DateTime.parse(map["creationTime"]),
        map.containsKey("intervals") ? (map["intervals"] as List<String>).map(AppointmentInterval.fromJson) : []
    );
  }

  Map<dynamic, dynamic> toJsonMap() {
    return {
      "description": description,
      "scheduledStartTime": scheduledStartTime.toIso8601String(),
      "scheduledEndTime": scheduledEndTime.toIso8601String(),
      "creationTime": creationTime.toIso8601String(),
      "intervals": intervals.map((interval) => interval.toJsonMap()).toList()
    };
  }
}

class AppointmentInterval {
  final DateTime startTime;
  final DateTime endTime;

  const AppointmentInterval(this.startTime, this.endTime);

  static AppointmentInterval fromJson(String source) {
    Map<String, dynamic> parsed = json.decode(source);
    return AppointmentInterval(DateTime.parse(parsed["startTime"]), DateTime.parse(parsed["endTime"]));
  }

  Map<String, dynamic> toJsonMap() {
    return {"startTime": startTime.toIso8601String(), "endTime": endTime.toIso8601String()};
  }
}
