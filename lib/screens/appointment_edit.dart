import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/appointment.dart';
import 'package:service_app/screens/customer_selection.dart';
import 'package:service_app/util/id_generator.dart';
import 'package:service_app/widgets/pickers.dart';

class AppointmentEditPage extends StatefulWidget {
  final AppointmentData appointment;

  const AppointmentEditPage(this.appointment);

  @override
  _AppointmentEditPageState createState() => _AppointmentEditPageState(appointment);
}

class _AppointmentEditPageState extends State<AppointmentEditPage> {
  final _formKey = GlobalKey<FormState>();

  String _appointmentId;
  String _customerId;
  String _originalCustomerId;

  final TextEditingController _description = TextEditingController();
  final TextEditingController _scheduledStart = TextEditingController();
  final TextEditingController _scheduledEnd = TextEditingController();
  final TextEditingController _creation = TextEditingController();
  final TextEditingController _customerName = TextEditingController();

  _AppointmentEditPageState(AppointmentData appointment) {
    if (appointment != null) {
      _initForExistingAppointment(appointment);
    } else {
      _initForNewAppointment();
    }
  }

  void _initForExistingAppointment(AppointmentData appointment) {
    _appointmentId = appointment.id;
    _description.text = appointment.description;
    _scheduledStart.text = appointment.scheduledStartDateTime.toIso8601String();
    _scheduledEnd.text = appointment.scheduledEndDateTime.toIso8601String();
    _creation.text = appointment.creationDateTime.toIso8601String();

    FirebaseRepository.instance
        .getCustomerById(appointment.customerId)
        .then((customerOpt) => customerOpt.ifPresent((customer) {
              _customerId = customer.id;
              _originalCustomerId = customer.id;
              _customerName.text = customer.name;
            }));
  }

  void _initForNewAppointment() {
    DateTime now = DateTime.now();
    _appointmentId = IdGenerator.generatePushChildName();
    _description.text = "";
    _scheduledStart.text = now.toIso8601String();
    _scheduledEnd.text = now.toIso8601String();
    _creation.text = now.toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment details"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: _saveAppointmentAndFinish,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _description,
                validator: _isNotEmpty,
                decoration: InputDecoration(labelText: "Description", disabledBorder: InputBorder.none),
              ),
              _buildDateTimeFormItem(context, _scheduledStart, "Scheduled start", null),
              _buildDateTimeFormItem(context, _scheduledEnd, "Scheduled end", _isValidEndDate),
              _buildDateTimeFormItem(context, _creation, "Creation", null),
              Container(
                margin: EdgeInsets.only(bottom: 8),
                child: InkWell(
                  child: TextFormField(
                    enabled: false,
                    controller: _customerName,
                    validator: _isNotEmpty,
                    decoration: InputDecoration(labelText: "Customer", disabledBorder: InputBorder.none),
                  ),
                  onTap: _pickCustomer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickCustomer() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerSelection())).then((customer) {
      if (customer != null) {
        _customerId = customer.id;
        _customerName.text = customer.name;
      }
    });
  }

  Widget _buildDateTimeFormItem(
      BuildContext context, TextEditingController controller, String labelText, FormFieldValidator<String> validator) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: InkWell(
        child: TextFormField(
          enabled: false,
          controller: controller,
          decoration: InputDecoration(labelText: labelText, disabledBorder: InputBorder.none),
          validator: validator,
        ),
        onTap: () => showDateAndTimePicker(context).then((dateTime) {
          if (dateTime != null) {
            controller.text = dateTime.toIso8601String();
          }
        }),
      ),
    );
  }

  String _isNotEmpty(String value) {
    if (value == null || value.isEmpty) return "This field cannot be empty";
    return null;
  }

  String _isValidEndDate(String value) {
    if (!DateTime.parse(value).isAfter(DateTime.parse(_scheduledStart.text))) {
      return "End must be after start";
    }
    return null;
  }

  void _saveAppointmentAndFinish() {
    if (_formKey.currentState.validate()) {
      _deleteAppointmentForCustomerIfExisted().then((unused) {
        AppointmentData appointment = AppointmentData(
            _appointmentId,
            _description.text,
            DateTime.parse(_scheduledStart.text),
            DateTime.parse(_scheduledEnd.text),
            DateTime.parse(_creation.text),
            _customerId,
            null,
            // Signature cannot exists at this point because completed appointments cannot be edited
            null);
        FirebaseRepository.instance.createAppointmentForTechnician(appointment).then((unused) {
          Navigator.pop(context, appointment.id);
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
}
