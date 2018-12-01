import 'package:service_app/data/model/base_entity.dart';

typedef T JsonMapper<T extends BaseEntity>(String id, Map<dynamic, dynamic> map);
