import 'package:service_app/util/id_generator.dart';
import 'package:service_app/util/identifiable.dart';

class Technician implements Identifiable {
  @override
  final String id;

  final String name;
  final String mail;
  final String phone;
  final List<Note> notes;

  const Technician._private(this.id, this.name, this.mail, this.phone, this.notes);

  Technician(this.name, this.mail, this.phone, this.notes) : id = IdGenerator.generatePushChildName();

  static Technician fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return Technician._private(
      id,
      map["name"],
      map["mail"],
      map["phone"],
      Identifiable.fromMap(map["notes"], Note.fromJsonMap),
    );
  }

  @override
  Map<dynamic, dynamic> toJsonMap() {
    return {
      "name": name,
      "mail": mail,
      "phone": phone,
      "notes": Identifiable.toMap(notes),
    };
  }
}

class Note implements Identifiable {
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
  Map<dynamic, dynamic> toJsonMap() {
    return {
      "title": title,
      "description": description,
      "status": status.toString(),
      "creationDateTime": creationDateTime.toIso8601String(),
    };
  }
}

enum NoteStatus { undefined, open, completed }
