import 'package:service_app/data/model/base_entity.dart';
import 'package:service_app/util/id_generator.dart';

class Note implements BaseEntity {
  @override
  final String id;

  final String title;
  final String description;
  final NoteStatus status;
  final DateTime creationDateTime;

  const Note._private(this.id, this.title, this.description, this.status, this.creationDateTime);

  Note(this.title, this.description, this.status, this.creationDateTime) : id = IdGenerator.generatePushChildName();

  static Note fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return Note._private(
      id,
      map["title"],
      map["description"],
      NoteStatus.values.firstWhere((v) => v.toString() == map["status"]),
      DateTime.parse(map["creationDateTime"]),
    );
  }

  @override
  Map<String, dynamic> toJsonMap() {
    return {
      "title": title,
      "description": description,
      "status": status.toString(),
      "creationDateTime": creationDateTime.toIso8601String(),
    };
  }
}

enum NoteStatus { undefined, open, completed }
