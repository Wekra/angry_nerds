import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {

  @override
  Widget build(context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Service App (Here could be name & img of the current technitian)'),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
          ),
          ListTile(
            title: Text('Service Appointments'),
            onTap: () {
              Navigator.pushNamed(context, '/appointment_list');
            },
          ),
          ListTile(
            title: Text('Test'),
            onTap: () {
              Navigator.pushNamed(context, '/test');
            },
          ),
        ],
      ),
    );
  }
}