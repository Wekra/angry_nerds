import 'package:startup_namer/data/model/appointment.dart';
import 'package:startup_namer/data/model/customer.dart';
import 'package:startup_namer/data/model/device.dart';
import 'package:startup_namer/data/model/note.dart';
import 'package:startup_namer/data/model/service_product.dart';
import 'package:startup_namer/data/model/warehouse_order.dart';

abstract class AppRepository {
  // -------------------- Notes
  Future<List<Note>> getNotesOfTechnician(int technicianId);

  Future<void> createNoteForTechnician(int technicianId, Note newNote);

  Future<void> setNoteStatus(int noteId, NoteStatus status);

  // -------------------- Warehouse orders
  Future<List<WarehouseOrder>> getOrdersOfTechnician(int technicianId);

  Future<void> createOrderForTechnician(int technicianId, WarehouseOrder newOrder);

  Future<void> markOrderAsDelivered(int orderId);

  // -------------------- Customers
  Future<List<Customer>> getCustomersOfTechnician(int technicianId);

  Future<void> createCustomer(Customer newCustomer);

  // -------------------- Customer details
  Future<List<ServiceProduct>> getServiceProductsOfCustomer(int customerId);

  Future<List<Device>> getDevicesOfCustomer(int customerId);

  // -------------------- Appointments
  Future<List<Appointment>> getAppointmentsOfTechnician(int technicianId);

  Future<void> createAppointmentForTechnician(int technicianId, Appointment newAppointment);

  Future<void> addAppointmentInterval(int appointmentId, AppointmentInterval interval);
}
