import 'package:service_app/data/model/part_bundle.dart';

class Warehouse {
  final String id;
  final String name;
  final List<PartBundle> partBundles;

  const Warehouse(this.id, this.name, this.partBundles);

  static Warehouse fromJsonMap(String id, Map<String, dynamic> map) {
    return Warehouse(
        id,
        map["name"],
        map.containsKey("partBundles")
            ? (map["partBundles"] as List<Map<String, dynamic>>)
            .map((partBundleMap) => PartBundle.fromJsonMap(null, partBundleMap))
            : []);
  }

  Map<String, dynamic> toJsonMap() {
    return {"name": name, "partBundles": partBundles.map((part) => part.toJsonMap())};
  }
}
