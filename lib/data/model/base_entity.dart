import 'package:service_app/util/identifiable.dart';
import 'package:service_app/util/json_serializable.dart';
import 'package:service_app/util/operation_stream_builders.dart';

abstract class BaseEntity implements Identifiable, JsonSerializable {
  static Map<String, dynamic> toMap(List<BaseEntity> entities) {
    Map<String, dynamic> map = new Map();
    entities.forEach((BaseEntity entity) => map[entity.id] = entity.toJsonMap());
    return map;
  }

  static List<T> fromMap<T extends BaseEntity>(Map<dynamic, dynamic> map, JsonMapper<T> mapper) {
    if (map == null) return [];
    List<T> entities = new List();
    map.forEach((dynamic id, dynamic itemMap) => entities.add(mapper(id, itemMap)));
    return entities;
  }
}
