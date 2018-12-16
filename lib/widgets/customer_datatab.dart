import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_app/data/model/customer.dart';

class CustomerDataTab extends StatelessWidget {
  final Customer customer;
  GoogleMapController mapController;

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

  CustomerDataTab(this.customer);

  @override
  Widget build(BuildContext context) {
    return new Column(
      verticalDirection: VerticalDirection.down,
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Text("Name:", style: TextStyle(fontWeight: FontWeight.bold)),
            new Text("${customer.name}")
          ],
        ),
        new Row(
          children: <Widget>[
            new Text("Phone:", style: TextStyle(fontWeight: FontWeight.bold)),
            new Text("${customer.phone}")
          ],
        ),
        new Row(
          children: <Widget>[
            new Text("Email:", style: TextStyle(fontWeight: FontWeight.bold)),
            new Text("${customer.mail}")
          ],
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: TextDirection.ltr,
          textBaseline: TextBaseline.alphabetic,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("Address:", style: TextStyle(fontWeight: FontWeight.bold)),
            new Column(
              verticalDirection: VerticalDirection.down,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Text("${customer.address.street} "),
                    new Text("${customer.address.houseNumber}")
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Text("${customer.address.zip} "),
                    new Text("${customer.address.city}")
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Text("${customer.address.country}"),
                  ],
                )
              ],
            )
          ],
        ),
        new Container(
            height: 370,
            width: 350,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: new GoogleMap(
              onMapCreated: _onMapCreated,
              options: GoogleMapOptions(
                cameraPosition: CameraPosition(
                    target: LatLng(customer.address.latitude, customer.address.longitude),
                    zoom: 15.0),
              ),
            ))
      ],
    );
  }
}
