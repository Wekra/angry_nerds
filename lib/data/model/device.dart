import 'package:service_app/util/id_generator.dart';
import 'package:service_app/util/identifiable.dart';

class Device implements Identifiable {
  @override
  final String id;

  final String name;
  final DeviceServiceStatus serviceStatus;

  const Device._private(this.id, this.name, this.serviceStatus);

  Device(this.name, this.serviceStatus) : id = IdGenerator.generatePushChildName();

  static Device fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return Device._private(
      id,
      map["name"],
      DeviceServiceStatus.values.firstWhere((v) => v.toString() == map["serviceStatus"]),
    );
  }

  @override
  Map<dynamic, dynamic> toJsonMap() {
    return {
      "name": name,
      "serviceStatus": serviceStatus.toString(),
    };
  }
}

enum DeviceServiceStatus { ok, maintenance_needed, broken }
