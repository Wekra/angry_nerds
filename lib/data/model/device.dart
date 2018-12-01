import 'package:service_app/data/model/base_entity.dart';
import 'package:service_app/util/id_generator.dart';

class Device implements BaseEntity {
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
  Map<String, dynamic> toJsonMap() {
    return {
      "name": name,
      "serviceStatus": serviceStatus.toString(),
    };
  }
}

enum DeviceServiceStatus { ok, maintenance_needed, broken }
