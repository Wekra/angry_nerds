import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:service_app/data/model/appointment.dart';
import 'package:service_app/util/list_operation_stream.dart';
import 'package:service_app/util/list_operations.dart';

class FirebaseRepository {
  static FirebaseRepository _instance;

  static FirebaseRepository get instance =>
      _instance != null ? _instance : throw StateError("Instance not initialized");

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  final int technicianId;

  FirebaseRepository._internal(this.technicianId);

  static void init(int technicianId) {
    _instance = FirebaseRepository._internal(technicianId);
  }

  // -------------------- Appointments

  Stream<ListOperation<Appointment>> getAppointmentsOfTechnician() {
    Query idsQuery = _databaseReference.child("technicians/$technicianId/appointments");
    Query detailQuery = _databaseReference.child("appointments");
    return FirebaseQueryOperationStreamBuilder(idsQuery, detailQuery, Appointment.fromJsonMap).stream;
  }

  Stream<ListOperation<AppointmentInterval>> getIntervalsOfAppointment(String appointmentId) {
    Query itemQuery = _databaseReference.child("appointments/$appointmentId/intervals");
    return SingleCollectionOperationStreamBuilder(itemQuery, AppointmentInterval.fromJsonMap).stream;
  }

  Future<void> createAppointmentForTechnician(Appointment newAppointment) {
    return _createOrUpdateAppointment(newAppointment).then(
        (unused) => _databaseReference.child("technicians/$technicianId/appointments/${newAppointment.id}").set(true));
  }

  Future<void> _createOrUpdateAppointment(Appointment newAppointment) {
    return _databaseReference.child("appointments/${newAppointment.id}").set(newAppointment.toJsonMap());
  }

  Future<void> addAppointmentInterval(String appointmentId, AppointmentInterval newInterval) {
    return _databaseReference.child("appointments/$appointmentId/intervals").push().set(newInterval.toJsonMap());
  }
}
