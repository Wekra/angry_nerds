import 'package:service_app/data/model/base_entity.dart';

typedef T JsonDeserializer<T extends BaseEntity>(String id, Map<dynamic, dynamic> jsonMap);
