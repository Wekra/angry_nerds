import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/appointment.dart';
import 'package:service_app/data/model/customer.dart';
import 'package:service_app/widgets/animated_operations_list.dart';
import 'package:service_app/widgets/appointment.dart';

class CustomerAppointmentTab extends StatelessWidget {
  final Customer _customer;

  const CustomerAppointmentTab(this._customer);

  @override
  Widget build(BuildContext context) {
    return AnimatedOperationsList(
      stream: FirebaseRepository.instance.getAppointmentDataOfCustomer(_customer.id), itemBuilder: _buildListItem);
  }

  Widget _buildListItem(BuildContext context, AppointmentData appointment, Animation<double> animation, int index) {
    return FadeTransition(
      opacity: animation,
      child: AppointmentDataListTile(
        appointment: appointment,
      ),
    );
  }
}
