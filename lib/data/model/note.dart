class Note {
  final String id;
  final String text;
  final DateTime creationTime;
  final NoteStatus status;

  const Note(this.id, this.text, this.creationTime, this.status);

  static Note fromJsonMap(String id, Map<String, dynamic> map) {
    return Note(
        id,
        map["text"],
        DateTime.parse(map["creationTime"]),
        NoteStatus.values.firstWhere((v) => v.toString() == "status")
    );
  }

  Map<String, dynamic> toJsonMap() {
    return {
      "text": text,
      "creationTime": creationTime.toIso8601String(),
      "status": status.toString()
    };
  }
}

enum NoteStatus { undefined, open, completed }
