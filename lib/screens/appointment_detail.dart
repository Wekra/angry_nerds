import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/appointment.dart';
import 'package:service_app/screens/customer_list_all.dart';
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

  String _appointmentId;
  String _customerId;
  String _originalCustomerId;

  final TextEditingController _description = TextEditingController();
  final TextEditingController _scheduledStart = TextEditingController();
  final TextEditingController _scheduledEnd = TextEditingController();
  final TextEditingController _creation = TextEditingController();
  final TextEditingController _customerName = TextEditingController();

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

    _appointmentId = appointment.id;
    _description.text = appointment.description;
    _scheduledStart.text = appointment.scheduledStartDateTime.toIso8601String();
    _scheduledEnd.text = appointment.scheduledEndDateTime.toIso8601String();
    _creation.text = appointment.creationDateTime.toIso8601String();

    FirebaseRepository.instance
      .getCustomerById(appointment.customerId)
      .then((customerOpt) =>
      customerOpt.ifPresent((customer) {
        _customerId = customer.id;
        _originalCustomerId = customer.id;
        _customerName.text = customer.name;
      }));
  }

  void _initForNewAppointment() {
    DateTime now = DateTime.now();
    _editMode = true;
    _appointmentStored = false;

    _appointmentId = IdGenerator.generatePushChildName();
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
      body: AnimatedOperationsList(
        headerWidgets: <Widget>[
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
                      decoration: InputDecoration(labelText: "Description", disabledBorder: InputBorder.none),
                    ),
                    _buildDateTimeFormItem(context, _scheduledStart, "Scheduled start"),
                    _buildDateTimeFormItem(context, _scheduledEnd, "Scheduled end"),
                    _buildDateTimeFormItem(context, _creation, "Creation"),
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        child: TextFormField(
                          enabled: false,
                          controller: _customerName,
                          validator: _isNotEmpty,
                          decoration: InputDecoration(labelText: "Customer", disabledBorder: InputBorder.none),
                        ),
                        onTap: _editMode ? pickCustomer : null,
                      ),
                    ),
                  ],
                ),
              )),
          Divider(),
        ],
        stream: FirebaseRepository.instance.getIntervalsOfAppointment(_appointmentId),
        itemBuilder: _buildIntervalWidget,
      ),
      floatingActionButton: _appointmentStored ? _buildFloatingActionButton() : null,
    );
  }

  void pickCustomer() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerListAll())).then((customer) {
      if (customer != null) {
        _customerId = customer.id;
        _customerName.text = customer.name;
      }
    });
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
        child: Icon(measurementStart != null ? Icons.stop : Icons.play_arrow),
        onPressed: () {
          if (measurementStart != null) {
            _finishMeasurement();
          } else {
            _startMeasurement();
          }
        });
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
    if (value == null || value.isEmpty) return "Please enter a value";
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
  }

  void _saveAppointment() {
    if (_formKey.currentState.validate()) {
      _deleteAppointmentForCustomerIfExisted().then((unused) {
        BaseAppointment appointment = BaseAppointment(
          _appointmentId,
          _description.text,
          DateTime.parse(_scheduledStart.text),
          DateTime.parse(_scheduledEnd.text),
          DateTime.parse(_creation.text),
          _customerId);
        FirebaseRepository.instance.createAppointmentForTechnician(appointment).then((unused) {
          setState(() {
            _appointmentStored = true;
            _editMode = false;
          });
        });
      });
    }
  }

  Future<void> _deleteAppointmentForCustomerIfExisted() {
    if (_originalCustomerId != null && _originalCustomerId != _customerId) {
      return FirebaseRepository.instance.deleteAppointmentForCustomer(_appointmentId, _originalCustomerId);
    } else {
      return Future.value();
    }
  }

  void _startEditing() {
    setState(() {
      _editMode = true;
    });
  }

  void _startMeasurement() {
    setState(() {
      measurementStart = DateTime.now();
    });
  }

  void _finishMeasurement() {
    DateTime measurementEnd = DateTime.now();
    AppointmentInterval interval = new AppointmentInterval(measurementStart, measurementEnd);
    FirebaseRepository.instance.addAppointmentInterval(_appointmentId, interval).then((unused) {
      setState(() {
        measurementStart = null;
      });
    });
  }
}
