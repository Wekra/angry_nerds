import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/appointment.dart';
import 'package:service_app/util/id_generator.dart';
import 'package:service_app/widgets/animated_operations_list.dart';
import 'package:service_app/widgets/pickers.dart';

class AppointmentDetailPage extends StatefulWidget {
  final Appointment appointment;

  const AppointmentDetailPage(this.appointment);

  @override
  _AppointmentDetailPageState createState() {
    return _AppointmentDetailPageState(appointment);
  }
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  DateTime measurementStart;

  bool _editMode;
  bool _appointmentStored;

  final _formKey = GlobalKey<FormState>();

  String appointmentId;
  final TextEditingController _description = TextEditingController();
  final TextEditingController _scheduledStart = TextEditingController();
  final TextEditingController _scheduledEnd = TextEditingController();
  final TextEditingController _creation = TextEditingController();

  _AppointmentDetailPageState(Appointment appointment) {
    if (appointment != null) {
      _initForExistingAppointment(appointment);
    } else {
      _initForNewAppointment();
    }
  }

  void _initForExistingAppointment(Appointment appointment) {
    _editMode = false;
    _appointmentStored = true;

    appointmentId = appointment.id;
    _description.text = appointment.description;
    _scheduledStart.text = appointment.scheduledStartDateTime.toIso8601String();
    _scheduledEnd.text = appointment.scheduledEndDateTime.toIso8601String();
    _creation.text = appointment.creationDateTime.toIso8601String();
  }

  void _initForNewAppointment() {
    DateTime now = DateTime.now();
    _editMode = true;
    _appointmentStored = false;

    appointmentId = IdGenerator.generatePushChildName();
    _description.text = "";
    _scheduledStart.text = now.toIso8601String();
    _scheduledEnd.text = now.toIso8601String();
    _creation.text = now.toIso8601String();
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
          Container(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    enabled: _editMode,
                    controller: _description,
                    validator: _isNotEmpty,
                    decoration: InputDecoration(labelText: "Description"),
                  ),
                  _buildDateTimeFormItem(context, _scheduledStart, "Scheduled start time"),
                  _buildDateTimeFormItem(context, _scheduledEnd, "Scheduled end time"),
                  _buildDateTimeFormItem(context, _creation, "Creation time"),
                ],
              ),
            ),
          ),
          Text("Intervals:"),
          Expanded(
            child: AnimatedOperationsList(
                stream: FirebaseRepository.instance.getIntervalsOfAppointment(appointmentId),
                itemBuilder: _buildIntervalWidget),
          )
        ],
      ),
      floatingActionButton: _appointmentStored
          ? FloatingActionButton(
          child: Icon(measurementStart != null ? Icons.stop : Icons.play_arrow),
          onPressed: () {
            if (measurementStart != null) {
              _finishMeasurement();
            } else {
              _startMeasurement();
            }
          })
          : null,
    );
  }

  Widget _buildDateTimeFormItem(BuildContext context, TextEditingController controller, String labelText) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: InkWell(
        child: TextFormField(
          enabled: false,
          controller: controller,
          decoration: InputDecoration(labelText: labelText),
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
      Appointment appointment = Appointment(_description.text, DateTime.parse(_scheduledStart.text),
          DateTime.parse(_scheduledEnd.text), DateTime.parse(_creation.text), []);
      FirebaseRepository.instance.createAppointmentForTechnician(appointment).then((unused) {
        setState(() {
          _appointmentStored = true;
        });
      });
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
    FirebaseRepository.instance.addAppointmentInterval(appointmentId, interval).then((unused) {
      setState(() {
        measurementStart = null;
      });
    });
  }
}
