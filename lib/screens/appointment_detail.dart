import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/appointment.dart';
import 'package:service_app/widgets/animated_operations_list.dart';
import 'package:service_app/widgets/pickers.dart';

class AppointmentDetailPage extends StatefulWidget {
  final Appointment appointment;

  const AppointmentDetailPage(this.appointment);

  @override
  _AppointmentDetailPageState createState() {
    return _AppointmentDetailPageState(appointment == null);
  }
}

// TODO Finish this page
class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  Appointment appointment;
  DateTime measurementStart;

  bool _editMode = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descriptionController = TextEditingController();
  DateTime scheduledStartTime;
  DateTime scheduledEndTime;
  final DateTime creationTime = DateTime.now();

  _AppointmentDetailPageState(this._editMode) {
    DateTime now = DateTime.now();
    scheduledStartTime = now;
    scheduledEndTime = now;
  }

  @override
  void initState() {
    super.initState();
    appointment = widget.appointment;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Appointment details"),
        actions: <Widget>[
          IconButton(
            icon: Icon(_editMode ? Icons.check : Icons.edit),
            onPressed: _onActionIconClicked,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          buildForm(context),
          Text("Description: ${appointment.description}"),
          Text("Creation time: ${appointment.creationDateTime}"),
          Text("Scheduled start time: ${appointment.scheduledStartDateTime}"),
          Text("Scheduled end time: ${appointment.scheduledEndDateTime}"),
          Text("Intervals:"),
          Expanded(
            child: AnimatedOperationsList(
                stream: FirebaseRepository.instance.getIntervalsOfAppointment(appointment.id),
                itemBuilder: _buildIntervalWidget),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(measurementStart != null ? Icons.stop : Icons.play_arrow),
          onPressed: () {
            if (measurementStart != null) {
              _finishMeasurement();
            } else {
              _startMeasurement();
            }
          }),
    );
  }

  Widget buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            enabled: _editMode,
            controller: _descriptionController,
            validator: _isNotEmpty,
            decoration: InputDecoration(labelText: "Description"),
          ),
          InkWell(
            child: Text(scheduledStartTime.toString()),
            onTap: () =>
                showDateAndTimePicker(context).then((DateTime dateTime) {
                  setState(() {
                    scheduledStartTime = dateTime;
                  });
                }),
          ),
        ],
      ),
    );
  }

  String _isNotEmpty(String value) {
    if (value.isEmpty) {
      return 'Please enter some text';
    }
  }

  Widget _buildIntervalWidget(BuildContext context, AppointmentInterval interval, Animation<double> animation,
      int index) {
    return FadeTransition(
      opacity: animation,
      child: ListTile(
        title: Text("Start: ${interval.startDateTime}"),
        subtitle: Text("End: ${interval.endDateTime}"),
      ),
    );
  }

  void _onActionIconClicked() {
    if (_editMode) {
      _saveAppointment();
    } else {
      _startEditing();
    }
    setState(() {
      _editMode = !_editMode;
    });
  }

  void _saveAppointment() {
    if (_formKey.currentState.validate()) {
      String text = _descriptionController.text;
    }
  }

  void _startEditing() {}

  void _startMeasurement() {
    setState(() {
      measurementStart = DateTime.now();
    });
  }

  void _finishMeasurement() {
    DateTime measurementEnd = DateTime.now();
    AppointmentInterval interval = new AppointmentInterval(measurementStart, measurementEnd);
    FirebaseRepository.instance.addAppointmentInterval(appointment.id, interval).then((unused) {
      setState(() {
        measurementStart = null;
      });
    });
  }
}
