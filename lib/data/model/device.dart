class Device {
  final int id;
  final String name;
  final DeviceServiceStatus serviceStatus;

  const Device(this.id, this.name, this.serviceStatus);
}

enum DeviceServiceStatus { ok, maintenance_needed, broken }
