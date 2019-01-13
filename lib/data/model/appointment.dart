import 'package:service_app/util/base_entity.dart';
import 'package:service_app/util/id_generator.dart';

class AppointmentData implements BaseEntity {
  @override
  final String id;

  final String description;
  final DateTime scheduledStartDateTime;
  final DateTime scheduledEndDateTime;
  final DateTime creationDateTime;
  final String customerId;
  final DateTime signatureDateTime;
  final String signatureBase64;

  const AppointmentData(this.id, this.description, this.scheduledStartDateTime, this.scheduledEndDateTime,
    this.creationDateTime, this.customerId, this.signatureDateTime, this.signatureBase64);

  static AppointmentData fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return AppointmentData(
      id,
      map["description"],
      DateTime.parse(map["scheduledStartDateTime"]),
      DateTime.parse(map["scheduledEndDateTime"]),
      DateTime.parse(map["creationDateTime"]),
      map["customerId"],
      map.containsKey("signatureDateTime") ? DateTime.parse(map["signatureDateTime"]) : null,
      map["signatureBase64"],
    );
  }

  @override
  Map<String, dynamic> toJsonMap() {
    return {
      "description": description,
      "scheduledStartDateTime": scheduledStartDateTime.toIso8601String(),
      "scheduledEndDateTime": scheduledEndDateTime.toIso8601String(),
      "creationDateTime": creationDateTime.toIso8601String(),
      "customerId": customerId,
      "signatureDateTime": signatureDateTime?.toIso8601String(),
      "signatureBase64": signatureBase64,
    };
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
