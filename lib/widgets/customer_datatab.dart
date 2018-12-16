import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_app/data/model/customer.dart';

class CustomerDataTab extends StatelessWidget {
  final Customer customer;
  GoogleMapController mapController;

  CustomerDataTab(this.customer);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addMarkerToMap();
  }

  void _addMarkerToMap() {
    mapController.addMarker(MarkerOptions(
        position: LatLng(customer.address.latitude, customer.address.longitude),
        infoWindowText: InfoWindowText("${customer.name}", "${customer.address}"),
        icon: BitmapDescriptor.defaultMarker));
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 16),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(customer.name),
                subtitle: Text("Name"),
              ),
              ListTile(
                title: Text(customer.phone),
                subtitle: Text("Phone"),
              ),
              ListTile(
                title: Text(customer.mail),
                subtitle: Text("Mail"),
              ),
              ListTile(
                title: Text(customer.address.toMultiLineString()),
                subtitle: Text("Address"),
              ),
            ],
          ),
        ),
        Expanded(
          child: new GoogleMap(
            onMapCreated: _onMapCreated,
            options: GoogleMapOptions(
              cameraPosition:
              CameraPosition(target: LatLng(customer.address.latitude, customer.address.longitude), zoom: 15.0),
            ),
          ),
        )
      ],
    );
  }
}
