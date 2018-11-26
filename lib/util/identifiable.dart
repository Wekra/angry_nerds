import 'package:service_app/util/operation_stream_builders.dart';

abstract class Identifiable {
  String get id;

  Map<dynamic, dynamic> toJsonMap();

  static Map<dynamic, dynamic> toMap(List<Identifiable> identifiables) {
    Map<dynamic, dynamic> map = new Map();
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
