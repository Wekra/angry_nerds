import 'package:service_app/util/operation_stream_builders.dart';

abstract class Identifiable {
  String get id;

  Map<String, dynamic> toJsonMap();

  static Map<String, dynamic> toMap(List<Identifiable> identifiables) {
    Map<String, dynamic> map = new Map();
    identifiables.forEach((Identifiable identifiable) => map[identifiable.id] = identifiable.toJsonMap());
    return map;
  }

  static List<T> fromMap<T extends Identifiable>(Map<dynamic, dynamic> map, JsonMapper<T> mapper) {
    if (map == null) return [];
    List<T> identifiables = new List();
    map.forEach((dynamic id, dynamic itemMap) => identifiables.add(mapper(id, itemMap)));
    return identifiables;
  }
}
