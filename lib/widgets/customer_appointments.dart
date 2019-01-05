import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/appointment.dart';
import 'package:service_app/data/model/customer.dart';
import 'package:service_app/screens/appointment_detail.dart';
import 'package:service_app/widgets/animated_operations_list.dart';

class CustomerAppointmentTab extends StatelessWidget {
  final Customer _customer;

  const CustomerAppointmentTab(this._customer);

  @override
  Widget build(BuildContext context) {
    return AnimatedOperationsList(
        stream: FirebaseRepository.instance.getAppointmentsOfCustomer(_customer.id), itemBuilder: _buildListItem);
  }

  Widget _buildListItem(BuildContext context, Appointment appointment, Animation<double> animation, int index) {
    return FadeTransition(
      opacity: animation,
      child: ListTile(
        title: Text(appointment.description),
        subtitle: Text(
            "Starts at ${appointment.scheduledStartDateTime.toString()}, has ${appointment.intervals.length} intervals"),
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentDetailPage(appointment))),
      ),
    );
  }
}
