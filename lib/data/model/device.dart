class Device {
  final String id;
  final String name;
  final DeviceServiceStatus serviceStatus;

  const Device(this.id, this.name, this.serviceStatus);

  static Device fromJsonMap(String id, Map<String, dynamic> map) {
    return Device(
        id,
        map["name"],
        DeviceServiceStatus.values.firstWhere((v) => v.toString() == map["serviceStatus"])
    );
  }

  Map<String, dynamic> toJsonMap() {
    return {
      "name": name,
      "serviceStatus": serviceStatus.toString()
    };
  }
}

enum DeviceServiceStatus { ok, maintenance_needed, broken }
