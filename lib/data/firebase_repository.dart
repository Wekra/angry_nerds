import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:service_app/data/model/appointment.dart';
import 'package:service_app/data/model/customer.dart';
import 'package:service_app/data/model/device.dart';
import 'package:service_app/data/model/service_product.dart';
import 'package:service_app/data/model/technician.dart';
import 'package:service_app/data/model/warehouse_order.dart';
import 'package:service_app/util/list_operations.dart';
import 'package:service_app/util/operation_stream_builders.dart';

class FirebaseRepository {
  static FirebaseRepository _instance;

  static FirebaseRepository get instance =>
      _instance != null ? _instance : throw StateError("Instance not initialized");

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  final int technicianId;

  FirebaseRepository._private(this.technicianId);

  static void init(int technicianId) {
    _instance = FirebaseRepository._private(technicianId);
  }

  // -------------------- Notes

  Future<void> createNoteForTechnician(Note newNote) {
    return _databaseReference.child("technicians/$technicianId/notes/${newNote.id}").set(newNote.toJsonMap());
  }

  Future<void> setNoteStatus(int noteId, NoteStatus status) {
    return _databaseReference.child("technicians/$technicianId/notes/$noteId/status").set(status.toString());
  }

  // -------------------- Warehouse orders

  Stream<ListOperation<WarehouseOrder>> getOrdersOfTechnician() {
    Query idsQuery = _databaseReference.child("technicians/$technicianId/orders");
    Query detailQuery = _databaseReference.child("orders");
    return ForeignKeyCollectionOperationStreamBuilder(WarehouseOrder.fromJsonMap, idsQuery, detailQuery).stream;
  }

  Future<void> createOrderForTechnician(WarehouseOrder newOrder) {
    return createOrUpdateOrder(newOrder)
        .then((unused) => _databaseReference.child("technicians/$technicianId/orders/${newOrder.id}").set(true));
  }

  Future<void> createOrUpdateOrder(WarehouseOrder newOrder) {
    return _databaseReference.child("orders/${newOrder.id}").set(newOrder.toJsonMap());
  }

  Future<void> markOrderAsDelivered(int orderId) {
    return _databaseReference.child("orders/$orderId/status").set(WarehouseOrderStatus.delivered);
  }

  // -------------------- Customers

  Stream<ListOperation<Customer>> getCustomersOfTechnician() {
    Query idsQuery = _databaseReference.child("technicians/$technicianId/customers");
    Query detailQuery = _databaseReference.child("customers");
    return ForeignKeyCollectionOperationStreamBuilder(Customer.fromJsonMap, idsQuery, detailQuery).stream;
  }

  Future<void> createCustomerForTechnician(Customer newCustomer) {
    return createOrUpdateCustomer(newCustomer)
        .then((unused) => _databaseReference.child("technicians/$technicianId/customers/${newCustomer.id}").set(true));
  }

  Future<void> createOrUpdateCustomer(Customer newCustomer) {
    return _databaseReference.child("customers/${newCustomer.id}").set(newCustomer.toJsonMap());
  }

  // -------------------- Customer details

  Stream<ListOperation<ServiceProduct>> getServiceProductsOfCustomer(int customerId) {
    Query idsQuery = _databaseReference.child("customers/$customerId/serviceProducts");
    Query detailQuery = _databaseReference.child("serviceProducts");
    return ForeignKeyCollectionOperationStreamBuilder(ServiceProduct.fromJsonMap, idsQuery, detailQuery).stream;
  }

  Stream<ListOperation<Device>> getDevicesOfCustomer(int customerId) {
    Query idsQuery = _databaseReference.child("customers/$customerId/devices");
    Query detailQuery = _databaseReference.child("devices");
    return ForeignKeyCollectionOperationStreamBuilder(Device.fromJsonMap, idsQuery, detailQuery).stream;
  }

  // -------------------- Appointments

  Stream<ListOperation<Appointment>> getAppointmentsOfTechnician() {
    Query idsQuery = _databaseReference.child("technicians/$technicianId/appointments");
    Query detailQuery = _databaseReference.child("appointments");
    return ForeignKeyCollectionOperationStreamBuilder(Appointment.fromJsonMap, idsQuery, detailQuery).stream;
  }

  Stream<ListOperation<AppointmentInterval>> getIntervalsOfAppointment(String appointmentId) {
    Query itemQuery = _databaseReference.child("appointments/$appointmentId/intervals");
    return SingleCollectionOperationStreamBuilder(AppointmentInterval.fromJsonMap, itemQuery).stream;
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
