import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/note.dart';
import 'package:service_app/screens/drawer_page.dart';
import 'package:service_app/screens/note_detail.dart';
import 'package:service_app/screens/signature_pad.dart';
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
  final SlidableController slidableController = new SlidableController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: AnimatedOperationsList(
        stream: FirebaseRepository.instance.getNotesOfTechnician(), itemBuilder: _buildNoteWidget),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignaturePadPage())),
      ),
    );
  }

  Widget _buildNoteWidget(BuildContext context, Note note, Animation<double> animation, int index) {
    return Slidable(
      key: Key(note.id),
      delegate: SlidableScrollDelegate(),
      controller: slidableController,
      showAllActionsThreshold: 1,
      // Always show all actions
      child: ListTile(
        title: Text(
          note.title,
          style: note.status == NoteStatus.completed ? TextStyle(decoration: TextDecoration.lineThrough) : null,
        ),
        subtitle: Text(note.description),
        trailing: _getTrailingCheckbox(note),
        onTap: () => _openEditNoteScreen(note),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: "Delete",
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {},
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: "Edit",
          color: Theme
            .of(context)
            .accentColor,
          icon: Icons.edit,
          onTap: () {},
        ),
      ],
      slideToDismissDelegate: SlideToDismissDrawerDelegate(
        closeOnCanceled: true,
        onWillDismiss: (SlideActionType actionType) {
          switch (actionType) {
            case SlideActionType.primary:
              return _showDeleteDialog(context, note);
            case SlideActionType.secondary:
              _openEditNoteScreen(note);
              return false;
          }
        },
        dismissThresholds: { // Close actions immediately after swiping
          SlideActionType.primary: 0,
          SlideActionType.secondary: 0,
        },
      ),
    );
  }

  Widget _getTrailingCheckbox(Note note) {
    if (note.status == NoteStatus.undefined) return null;

    return Checkbox(
      value: note.status == NoteStatus.completed,
      onChanged: (checked) => _onCheckboxChanged(note.id, checked),
    );
  }

  void _openEditNoteScreen(Note note) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NoteDetailPage(note)));
  }

  void _onCheckboxChanged(String noteId, bool checked) {
    FirebaseRepository.instance.setNoteStatus(noteId, checked ? NoteStatus.completed : NoteStatus.open);
  }

  /// Always returns false after closing to prevent actual dismissing of the item.
  /// Dismissing causes rendering errors as the item cannot be deleted immediately from Firebase.
  FutureOr<bool> _showDeleteDialog(BuildContext context, Note note) {
    AlertDialog dialog = AlertDialog(
      title: Text("Delete note \"${note.title}\"?"),
      actions: <Widget>[
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: Text("Yes"),
          onPressed: () {
            FirebaseRepository.instance.deleteNoteForTechnician(note.id);
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
    return showDialog(context: context, builder: (context) => dialog);
  }
}
