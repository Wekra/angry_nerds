import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/note.dart';
import 'package:service_app/util/id_generator.dart';

class NoteDetailPage extends StatefulWidget {
  final Note note;

  const NoteDetailPage(this.note);

  @override
  _NoteDetailPageState createState() {
    return _NoteDetailPageState(note);
  }
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  bool _editMode;

  final _formKey = GlobalKey<FormState>();

  String _noteId;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  NoteStatus _status;
  DateTime _creation;

  _NoteDetailPageState(Note note) {
    if (note != null) {
      _initForExistingNote(note);
    } else {
      _initForNewNote();
    }
  }

  void _initForExistingNote(Note note) {
    _editMode = false;
    _noteId = note.id;
    _title.text = note.title;
    _description.text = note.description;
    _status = note.status;
    _creation = note.creationDateTime;
  }

  void _initForNewNote() {
    _editMode = true;
    _noteId = IdGenerator.generatePushChildName();
    _title.text = "";
    _description.text = "";
    _status = NoteStatus.undefined;
    _creation = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note details"),
        actions: <Widget>[
          IconButton(
            icon: Icon(_editMode ? Icons.check : Icons.edit),
            onPressed: _onActionIconClicked,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                enabled: _editMode,
                controller: _title,
                validator: _isNotEmpty,
                decoration: InputDecoration(
                  labelText: "Title",
                  disabledBorder: InputBorder.none,
                ),
              ),
              TextFormField(
                enabled: false,
                initialValue: _creation.toIso8601String(),
                decoration: InputDecoration(
                  labelText: "Creation",
                  disabledBorder: InputBorder.none,
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Task",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(
                      child: Switch(
                        onChanged: _handleCheckboxClick,
                        value: _status != NoteStatus.undefined,
                      ),
                    )
                  ],
                ),
              ),
              TextFormField(
                enabled: false,
                initialValue: getNoteStatusString(_status),
                decoration: InputDecoration(
                  labelText: "Status",
                  disabledBorder: InputBorder.none,
                ),
              ),
              TextFormField(
                enabled: _editMode,
                maxLines: 5,
                controller: _description,
                validator: _isNotEmpty,
                decoration: InputDecoration(
                  labelText: "Description",
                  disabledBorder: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCheckboxClick(bool checked) {
    if (_editMode) {
      setState(() {
        _status = checked ? NoteStatus.open : NoteStatus.undefined;
      });
    }
  }

  String _isNotEmpty(String value) {
    if (value.isEmpty) return "This field cannot be empty";
    return null;
  }

  void _onActionIconClicked() {
    if (_editMode) {
      if (_formKey.currentState.validate()) {
        Note note = Note(_noteId, _title.text, _description.text, _status, _creation);
        FirebaseRepository.instance.createNoteForTechnician(note).then((unused) {
          setState(() {
            _editMode = false;
          });
        });
      }
    } else {
      setState(() {
        _editMode = true;
      });
    }
  }
}
