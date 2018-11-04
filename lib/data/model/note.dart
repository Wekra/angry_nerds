import 'package:quiver/core.dart';

class Note {
  final int id;
  final String text;
  final DateTime creationTime;
  final Optional<NoteStatus> status;

  const Note(this.id, this.text, this.creationTime, this.status);
}

enum NoteStatus { open, completed }
