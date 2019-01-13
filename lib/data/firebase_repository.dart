import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:quiver/core.dart';
import 'package:service_app/data/model/appointment.dart';
import 'package:service_app/data/model/customer.dart';
import 'package:service_app/data/model/device.dart';
import 'package:service_app/data/model/note.dart';
import 'package:service_app/data/model/part.dart';
import 'package:service_app/data/model/part_bundle.dart';
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
  final Technician technician;

  FirebaseRepository._private(this.technician);

  /// This should be called after the login is done
  static void init(Technician technician) {
    _instance = FirebaseRepository._private(technician);
  }

  // -------------------- Notes

  Stream<ListOperation<Note>> getNotesOfTechnician() {
    Query idsQuery = _databaseReference.child("technicians/${technician.id}/noteIds");
    Query detailQuery = _databaseReference.child("notes");
    return ForeignKeyCollectionOperationStreamBuilder(Note.fromJsonMap, idsQuery, detailQuery).stream;
  }

  Future<void> createNoteForTechnician(Note newNote) {
    return _createOrUpdateNote(newNote)
        .then((unused) => _databaseReference.child("technicians/${technician.id}/noteIds/${newNote.id}").set(true));
  }

  Future<void> _createOrUpdateNote(Note newNote) {
    return _databaseReference.child("notes/${newNote.id}").update(newNote.toJsonMap());
  }

  Future<void> setNoteStatus(String noteId, NoteStatus status) {
    return _databaseReference.child("notes/$noteId/status").set(status.toString());
  }

  Future<void> deleteNoteForTechnician(String noteId) {
    return _databaseReference
        .child("technicians/${technician.id}/noteIds/$noteId")
        .remove()
        .then((unused) => _databaseReference.child("notes/$noteId").remove());
  }

  // -------------------- Warehouse orders

  Stream<ListOperation<WarehouseOrder>> getOrdersOfTechnician() {
    Query idsQuery = _databaseReference.child("technicians/${technician.id}/orderIds");
    Query detailQuery = _databaseReference.child("orders");
    return ForeignKeyCollectionOperationStreamBuilder(WarehouseOrder.fromJsonMap, idsQuery, detailQuery).stream;
  }

  Future<void> createOrderForTechnician(WarehouseOrder newOrder) {
    return _createOrUpdateOrder(newOrder)
        .then((unused) => _databaseReference.child("technicians/${technician.id}/orderIds/${newOrder.id}").set(true));
  }

  Future<void> _createOrUpdateOrder(WarehouseOrder newOrder) {
    return _databaseReference.child("orders/${newOrder.id}").update(newOrder.toJsonMap());
  }

  Stream<ListOperation<Part>> getPartsOfOrder(int orderId) {
    Query query = _databaseReference.child("orders/$orderId");
    return SingleCollectionOperationStreamBuilder(Part.fromJsonMap, query).stream;
  }

  Stream<ListOperation<Part>> getAllParts() {
    Query query = _databaseReference.child("parts");
    return SingleCollectionOperationStreamBuilder(Part.fromJsonMap, query).stream;
  }

  Stream<Optional<Part>> getPartById(String partId) {
    return _databaseReference
        .child("parts/$partId")
        .onValue
        .map((Event event) => buildItemFromSnapshot(event?.snapshot, Part.fromJsonMap));
  }

  Future<void> deleteOrderForTechnician(String orderId) {
    return _databaseReference
        .child("technicians/${technician.id}/orderIds/$orderId")
        .remove()
        .then((unused) => _databaseReference.child("orders/$orderId").remove());
  }

  /// This method can be used to manually set the order status (as we don't have an order system)
  Future<void> setOrderStatus(int orderId, WarehouseOrderStatus status) {
    return _databaseReference.child("orders/$orderId/status").set(status.toString());
  }

  // -------------------- Customers

  Future<Optional<Customer>> getCustomerById(String customerId) {
    return _databaseReference
        .child("customers/$customerId")
        .once()
        .then((snapshot) => buildItemFromSnapshot(snapshot, Customer.fromJsonMap));
  }

  Stream<ListOperation<Customer>> getAllCustomers() {
    Query query = _databaseReference.child("customers");
    return SingleCollectionOperationStreamBuilder(Customer.fromJsonMap, query).stream;
  }

  Stream<ListOperation<Customer>> getCustomersOfTechnician() {
    Query idsQuery = _databaseReference.child("technicians/${technician.id}/customerIds");
    Query detailQuery = _databaseReference.child("customers");
    return ForeignKeyCollectionOperationStreamBuilder(Customer.fromJsonMap, idsQuery, detailQuery).stream;
  }

  Future<void> createCustomerForTechnician(Customer newCustomer) {
    return _createOrUpdateCustomer(newCustomer).then(
        (unused) => _databaseReference.child("technicians/${technician.id}/customerIds/${newCustomer.id}").set(true));
  }

  Future<void> _createOrUpdateCustomer(Customer newCustomer) {
    return _databaseReference.child("customers/${newCustomer.id}").update(newCustomer.toJsonMap());
  }

  // -------------------- Customer details

  Stream<ListOperation<ServiceProduct>> getServiceProductsOfCustomer(String customerId) {
    Query idsQuery = _databaseReference.child("customers/$customerId/serviceProductIds");
    Query detailQuery = _databaseReference.child("serviceProducts");
    return ForeignKeyCollectionOperationStreamBuilder(ServiceProduct.fromJsonMap, idsQuery, detailQuery).stream;
  }

  Stream<ListOperation<Device>> getDevicesOfCustomer(String customerId) {
    Query idsQuery = _databaseReference.child("customers/$customerId/deviceIds");
    Query detailQuery = _databaseReference.child("devices");
    return ForeignKeyCollectionOperationStreamBuilder(Device.fromJsonMap, idsQuery, detailQuery).stream;
  }

  // -------------------- Appointments

  Stream<Optional<AppointmentData>> getAppointmentDataById(String appointmentId) {
    return _databaseReference
        .child("appointments/data/$appointmentId")
        .onValue
        .map((Event event) => buildItemFromSnapshot(event?.snapshot, AppointmentData.fromJsonMap));
  }

  Stream<ListOperation<AppointmentData>> getAppointmentDataOfTechnician() {
    Query idsQuery = _databaseReference.child("technicians/${technician.id}/appointmentIds");
    Query detailQuery = _databaseReference.child("appointments/data");
    return ForeignKeyCollectionOperationStreamBuilder(AppointmentData.fromJsonMap, idsQuery, detailQuery).stream;
  }

  Stream<ListOperation<AppointmentData>> getAppointmentDataOfCustomer(String customerId) {
    Query idsQuery = _databaseReference.child("customers/$customerId/appointmentIds");
    Query detailQuery = _databaseReference.child("appointments/data");
    return ForeignKeyCollectionOperationStreamBuilder(AppointmentData.fromJsonMap, idsQuery, detailQuery).stream;
  }

  Stream<ListOperation<PartBundle>> getPartsOfAppointment(String appointmentId) {
    Query itemQuery = _databaseReference.child("appointments/parts/$appointmentId");
    return SingleCollectionOperationStreamBuilder(PartBundle.fromJsonMap, itemQuery).stream;
  }

  Stream<ListOperation<AppointmentInterval>> getIntervalsOfAppointment(String appointmentId) {
    Query itemQuery = _databaseReference.child("appointments/intervals/$appointmentId");
    return SingleCollectionOperationStreamBuilder(AppointmentInterval.fromJsonMap, itemQuery).stream;
  }

  Future<void> createAppointmentForTechnician(AppointmentData newAppointment) {
    return _createOrUpdateAppointment(newAppointment)
        .then((unused) =>
            _databaseReference.child("technicians/${technician.id}/appointmentIds/${newAppointment.id}").set(true))
        .then((unused) => _databaseReference
            .child("customers/${newAppointment.customerId}/appointmentIds/${newAppointment.id}")
            .set(true));
  }

  Future<void> _createOrUpdateAppointment(AppointmentData newAppointment) {
    return _databaseReference.child("appointments/data/${newAppointment.id}").update(newAppointment.toJsonMap());
  }

  Future<void> addAppointmentInterval(String appointmentId, AppointmentInterval newInterval) {
    return _databaseReference
        .child("appointments/intervals/$appointmentId/${newInterval.id}")
        .set(newInterval.toJsonMap());
  }

  Future<void> addOrUpdateAppointmentPartBundle(String appointmentId, PartBundle newPartBundle) {
    return _databaseReference
        .child("appointments/parts/$appointmentId/${newPartBundle.id}")
        .set(newPartBundle.toJsonMap());
  }

  Future<void> completeAppointment(String appointmentId, String signatureBase64) {
    return _databaseReference.child("appointments/data/$appointmentId").update({
      "signatureDateTime": DateTime.now().toIso8601String(),
      "signatureBase64": signatureBase64,
    });
  }

  Future<void> deleteAppointmentForTechnician(String appointmentId) {
    return _databaseReference
        .child("technicians/${technician.id}/appointmentIds/$appointmentId")
        .remove()
        .then((unused) {
      _databaseReference.child("appointments/data/$appointmentId").remove();
      _databaseReference.child("appointments/intervals/$appointmentId").remove();
      _databaseReference.child("appointments/parts/$appointmentId").remove();
    });
  }

  Future<void> deleteAppointmentForCustomer(String appointmentId, String customerId) {
    return _databaseReference.child("customers/$customerId/appointmentIds/$appointmentId").remove();
  }


}
