import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/appointment.dart';
import 'package:service_app/data/model/customer.dart';
import 'package:service_app/data/model/service_product.dart';
import 'package:service_app/widgets/animated_operations_list.dart';
import 'package:service_app/widgets/appointment.dart';
import 'package:service_app/widgets/service_product.dart';

class CustomerDetailPage extends StatelessWidget {
  final Customer _customer;
  final int _initialTabIndex;

  CustomerDetailPage(this._customer, this._initialTabIndex);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: _initialTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Customer: ${_customer.name}"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: "Data"),
              Tab(text: "Appointments"),
              Tab(text: "Service products"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            CustomerDataTab(_customer),
            CustomerAppointmentTab(_customer),
            CustomerServiceProductTab(_customer),
          ],
        ),
      ),
    );
  }
}

class CustomerDataTab extends StatelessWidget {
  final Customer _customer;

  CustomerDataTab(this._customer);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 16),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(_customer.name),
                subtitle: Text("Name"),
              ),
              ListTile(
                title: Text(_customer.phone),
                subtitle: Text("Phone"),
              ),
              ListTile(
                title: Text(_customer.mail),
                subtitle: Text("Mail"),
              ),
              ListTile(
                title: Text(_customer.address.toMultiLineString()),
                subtitle: Text("Address"),
              ),
            ],
          ),
        ),
        Expanded(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            options: GoogleMapOptions(
              cameraPosition: CameraPosition(
                target: LatLng(_customer.address.latitude, _customer.address.longitude),
                zoom: 15.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    controller.addMarker(MarkerOptions(
      position: LatLng(_customer.address.latitude, _customer.address.longitude),
      infoWindowText: InfoWindowText("${_customer.name}", "${_customer.address}"),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }
}

class CustomerAppointmentTab extends StatelessWidget {
  final Customer _customer;

  const CustomerAppointmentTab(this._customer);

  @override
  Widget build(BuildContext context) {
    return AnimatedOperationsList(
      stream: FirebaseRepository.instance.getAppointmentDataOfCustomer(_customer.id),
      itemBuilder: _buildListItem,
    );
  }

  Widget _buildListItem(BuildContext context, AppointmentData appointment, Animation<double> animation, int index) {
    return FadeTransition(
      opacity: animation,
      child: AppointmentDataListTile(
        appointment,
      ),
    );
  }
}

class CustomerServiceProductTab extends StatelessWidget {
  final Customer _customer;

  const CustomerServiceProductTab(this._customer);

  @override
  Widget build(BuildContext context) {
    return AnimatedOperationsList(
      stream: FirebaseRepository.instance.getServiceProductsOfCustomer(_customer.id),
      itemBuilder: _buildServiceProductWidget,
    );
  }

  Widget _buildServiceProductWidget(BuildContext context, ServiceProduct serviceProduct, Animation<double> animation,
    int index) {
    return FadeTransition(
      opacity: animation,
      child: ServiceProductListTile(
        serviceProduct,
      ),
    );
  }
}
