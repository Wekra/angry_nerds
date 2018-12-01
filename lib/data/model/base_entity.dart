import 'package:service_app/util/identifiable.dart';
import 'package:service_app/util/json_deserializer.dart';
import 'package:service_app/util/json_serializable.dart';

abstract class BaseEntity implements Identifiable, JsonSerializable {
  static Map<String, dynamic> toMap(List<BaseEntity> entities) {
    Map<String, dynamic> map = new Map();
    entities.forEach((BaseEntity entity) => map[entity.id] = entity.toJsonMap());
    return map;
  }

  static List<T> fromMap<T extends BaseEntity>(Map<dynamic, dynamic> map, JsonDeserializer<T> deserializer) {
    if (map == null) return [];
    List<T> entities = new List();
    map.forEach((dynamic id, dynamic itemMap) => entities.add(deserializer(id, itemMap)));
    return entities;
  }
}
