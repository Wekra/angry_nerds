import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quiver/core.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/appointment.dart';
import 'package:service_app/data/model/customer.dart';
import 'package:service_app/data/model/part.dart';
import 'package:service_app/data/model/part_bundle.dart';
import 'package:service_app/screens/appointment_edit.dart';
import 'package:service_app/screens/customer_detail.dart';
import 'package:service_app/screens/part_list.dart';
import 'package:service_app/screens/signature_pad.dart';
import 'package:service_app/widgets/animated_operations_list.dart';
import 'package:service_app/widgets/appointment.dart';
import 'package:service_app/widgets/part.dart';

class AppointmentDetailPage extends StatefulWidget {
  final String _appointmentId;

  AppointmentDetailPage(this._appointmentId) {
    assert(this._appointmentId != null);
  }

  @override
  _AppointmentDetailPageState createState() {
    return _AppointmentDetailPageState(_appointmentId);
  }
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> with SingleTickerProviderStateMixin {
  final String _appointmentId;
  final List<Tab> tabs = [Tab(text: "Data"), Tab(text: "Parts"), Tab(text: "Intervals")];

  TabController _tabController;
  FloatingActionButton _floatingActionButton;

  bool _measurementSaving = false;
  DateTime _measurementStart;

  AppointmentData _appointment;
  Customer _customer;
  StreamSubscription _appointmentSubscription;

  _AppointmentDetailPageState(this._appointmentId);

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(_refreshFloatingActionButton);

    _floatingActionButton = _buildFloatingActionButton();

    _appointmentSubscription =
      FirebaseRepository.instance.getAppointmentDataById(_appointmentId).listen(_applyAppointmentOrFinish);
  }

  void _applyAppointmentOrFinish(Optional<AppointmentData> appointmentOpt) {
    if (appointmentOpt.isPresent) {
      AppointmentData appointment = appointmentOpt.value;
      FirebaseRepository.instance.getCustomerById(appointment.customerId).then((customerOpt) {
        setState(() {
          _appointment = appointment;
          _customer = customerOpt.orNull;
          _floatingActionButton = _buildFloatingActionButton();
        });
      });
    } else {
      debugPrint("Received empty AppointmentData, finishing AppointmentDetailPage");
      Navigator.pop(context);
    }
  }

  void _refreshFloatingActionButton() {
    setState(() {
      _floatingActionButton = _buildFloatingActionButton();
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building AppointmentDetailPageState");
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment details"),
        actions: _buildActions(),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _appointment == null ? Center(child: CircularProgressIndicator()) : ListView(children: _buildDataWidgets()),
          AnimatedOperationsList(
            stream: FirebaseRepository.instance.getPartsOfAppointment(_appointmentId),
            itemBuilder: _buildPartBundleWidget,
          ),
          AnimatedOperationsList(
            stream: FirebaseRepository.instance.getIntervalsOfAppointment(_appointmentId),
            itemBuilder: _buildIntervalWidget,
          ),
        ],
      ),
      floatingActionButton: _floatingActionButton,
    );
  }

  List<Widget> _buildDataWidgets() {
    List<Widget> widgets = [
      ListTile(
        title: Text(_appointment.description),
        subtitle: Text("Description"),
      ),
      ListTile(
        title: Text(_appointment.scheduledStartDateTime.toString()),
        subtitle: Text("Scheduled start"),
      ),
      ListTile(
        title: Text(_appointment.scheduledEndDateTime.toString()),
        subtitle: Text("Scheduled end"),
      ),
      ListTile(
        title: Text(_appointment.creationDateTime.toString()),
        subtitle: Text("Creation"),
      ),
      ListTile(
        title: Text(_customer != null ? _customer.name : ""),
        subtitle: Text("Customer"),
        onTap: _openCustomerDetailPage,
      ),
      ListTile(
        title: Text(_appointment.signatureDateTime?.toString() ?? "Not signed yet"),
        subtitle: Text("Signed at"),
      ),
    ];

    if (_appointment.signatureBase64 != null) {
      widgets.add(Divider());
      widgets.add(Container(
        constraints: BoxConstraints.tight(Size(300, 300)),
        margin: EdgeInsets.only(bottom: 16),
        child: Image(
          image: MemoryImage(base64.decode(_appointment.signatureBase64)),
          fit: BoxFit.scaleDown,
        ),
      ));
    }

    return widgets;
  }

  List<Widget> _buildActions() {
    if (_appointment == null || _appointment.signatureDateTime != null) {
      return [];
    } else {
      return [
        IconButton(
          icon: Icon(Icons.assignment_turned_in),
          onPressed: _completeAppointment,
        ),
      ];
    }
  }

  FloatingActionButton _buildFloatingActionButton() {
    if (_appointment == null || _appointment.signatureDateTime != null) return null;

    switch (_tabController.index) {
      case 0:
        return FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: _openAppointmentEditPage,
        );

      case 1:
        return FloatingActionButton(
          child: new Icon(Icons.add),
          onPressed: _selectPart,
        );

      case 2:
        return FloatingActionButton(
          child: Icon(_measurementStart != null ? Icons.stop : Icons.play_arrow),
          onPressed: () {
            if (!_measurementSaving) {
              if (_measurementStart != null) {
                _finishMeasurement();
              } else {
                _measurementStart = DateTime.now();
              }
              _refreshFloatingActionButton();
            }
          });

      default:
        return null;
    }
  }

  Widget _buildPartBundleWidget(BuildContext context, PartBundle bundle, Animation<double> animation, int index) {
    return FadeTransition(
      opacity: animation,
      child: PartBundleWidget(
        bundle,
        modifiable: _appointment.signatureDateTime == null,
        onBundleChanged: _handleBundleChanged,
      ),
    );
  }

  void _handleBundleChanged(PartBundle newBundle) {
    FirebaseRepository.instance.addOrUpdateAppointmentPartBundle(_appointmentId, newBundle);
  }

  void _openCustomerDetailPage() {
    if (_customer != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerDetailPage(_customer)));
    }
  }

  void _openAppointmentEditPage() {
    if (_appointment != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentEditPage(_appointment)));
    }
  }

  void _selectPart() {
    Navigator.push<Part>(context, MaterialPageRoute(builder: (context) => PartListPage())).then((Part part) {
      if (part != null) {
        PartBundle bundle = PartBundle(1, part.id);
        FirebaseRepository.instance.addOrUpdateAppointmentPartBundle(_appointmentId, bundle);
      }
    });
  }

  Widget _buildIntervalWidget(BuildContext context, AppointmentInterval interval, Animation<double> animation,
    int index) {
    return FadeTransition(
      opacity: animation,
      child: AppointmentIntervalListTile(
        interval,
      ),
    );
  }

  void _finishMeasurement() {
    _measurementSaving = true;
    DateTime measurementEnd = DateTime.now();
    AppointmentInterval interval = new AppointmentInterval(_measurementStart, measurementEnd);
    _measurementStart = null;
    FirebaseRepository.instance.addAppointmentInterval(_appointmentId, interval).then((unused) {
      _measurementSaving = false;
    });
  }

  void _completeAppointment() {
    Navigator.push<String>(context, MaterialPageRoute(builder: (context) => SignaturePadPage()))
      .then((String signatureBase64) {
      if (signatureBase64 != null) {
        FirebaseRepository.instance.completeAppointment(_appointmentId, signatureBase64);
      }
    });
  }

  @override
  void dispose() {
    _appointmentSubscription?.cancel();
    _appointmentSubscription = null;
    _tabController.dispose();
    super.dispose();
  }
}
