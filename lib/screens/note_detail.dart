import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/note.dart';
import 'package:service_app/util/id_generator.dart';
import 'package:service_app/widgets/pickers.dart';

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
  final TextEditingController _creation = TextEditingController();

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
    _creation.text = note.creationDateTime.toIso8601String();
  }

  void _initForNewNote() {
    DateTime now = DateTime.now();
    _editMode = true;

    _noteId = IdGenerator.generatePushChildName();
    _title.text = "";
    _description.text = "";
    _status = NoteStatus.undefined;
    _creation.text = now.toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Note details"),
        actions: <Widget>[
          IconButton(
            icon: Icon(_editMode ? Icons.check : Icons.edit),
            onPressed: _onActionIconClicked,
          )
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
                  decoration: InputDecoration(labelText: "Title", disabledBorder: InputBorder.none),
                ),
                TextFormField(
                  enabled: _editMode,
                  controller: _description,
                  validator: _isNotEmpty,
                  decoration: InputDecoration(labelText: "Description", disabledBorder: InputBorder.none),
                ),
                _buildDateTimeFormItem(context, _creation, "Creation"),
                ListTile(
                  enabled: _editMode,
                  title: Text("Has status"),
                  trailing: Checkbox(
                    value: _status != NoteStatus.undefined,
                    onChanged: _handleCheckboxClick,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void _handleCheckboxClick(bool checked) {
    if (_editMode) {
      setState(() {
        _status = checked ? NoteStatus.open : NoteStatus.undefined;
      });
    }
  }

  Widget _buildDateTimeFormItem(BuildContext context, TextEditingController controller, String labelText) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: InkWell(
        child: TextFormField(
          enabled: false,
          controller: controller,
          decoration: InputDecoration(labelText: labelText, disabledBorder: InputBorder.none),
        ),
        onTap: _editMode
            ? () => showDateAndTimePicker(context).then((dateTime) => controller.text = dateTime.toIso8601String())
            : null,
      ),
    );
  }

  String _isNotEmpty(String value) {
    if (value.isEmpty) return 'Please enter some text';
    return null;
  }

  void _onActionIconClicked() {
    if (_editMode) {
      if (_formKey.currentState.validate()) {
        Note note = Note(_noteId, _title.text, _description.text, _status, DateTime.parse(_creation.text));
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
