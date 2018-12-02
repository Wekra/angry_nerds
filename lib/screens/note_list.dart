import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/note.dart';
import 'package:service_app/screens/drawer_page.dart';
import 'package:service_app/screens/note_detail.dart';
import 'package:service_app/widgets/animated_operations_list.dart';

class NoteListPage extends DrawerPage {
  @override
  _NoteListPageState createState() {
    return _NoteListPageState();
  }

  @override
  String get title => "Notes";

  @override
  IconData get icon => Icons.note;
}

class _NoteListPageState extends State<NoteListPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: AnimatedOperationsList(
          stream: FirebaseRepository.instance.getNotesOfTechnician(), itemBuilder: _buildListItem),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NoteDetailPage(null))),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Note note, Animation<double> animation, int index) {
    return FadeTransition(
      opacity: animation,
      child: ListTile(
        title: Text(
          note.title,
          style: note.status == NoteStatus.completed ? TextStyle(decoration: TextDecoration.lineThrough) : null,
        ),
        subtitle: Text(note.description),
        trailing: _getTrailingCheckbox(note),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NoteDetailPage(note))),
        onLongPress: () => _showDeleteDialog(context, note),
      ),
    );
  }

  Widget _getTrailingCheckbox(Note note) {
    if (note.status == NoteStatus.undefined) {
      return null;
    } else {
      return Checkbox(
        value: note.status == NoteStatus.completed,
        onChanged: (checked) => _onCheckboxChanged(note.id, checked),
      );
    }
  }

  void _onCheckboxChanged(String noteId, bool checked) {
    FirebaseRepository.instance.setNoteStatus(noteId, checked ? NoteStatus.completed : NoteStatus.open);
  }

  void _showDeleteDialog(BuildContext context, Note note) {
    AlertDialog dialog = AlertDialog(
      title: Text("Delete note \"${note.title}\"?"),
      actions: <Widget>[
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Yes"),
          onPressed: () {
            FirebaseRepository.instance.deleteNoteForTechnician(note.id);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(context: context, builder: (context) => dialog);
  }
}
