import 'package:service_app/util/base_entity.dart';

class Note implements BaseEntity {
  @override
  final String id;

  final String title;
  final String description;
  final NoteStatus status;
  final DateTime creationDateTime;

  const Note(this.id, this.title, this.description, this.status, this.creationDateTime);

  static Note fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return Note(
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
