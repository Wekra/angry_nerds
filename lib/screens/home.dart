import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/screens/appointment_list.dart';
import 'package:service_app/screens/customer_list.dart';
import 'package:service_app/screens/drawer_page.dart';
import 'package:service_app/screens/inventory.dart';
import 'package:service_app/screens/note_list.dart';
import 'package:service_app/services/authentication.dart';

class HomePage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  final List<DrawerPage> pages = [
    AppointmentListPage(),
    NoteListPage(),
    InventoryPage(),
    CustomerListPage(),
  ];

  HomePage({this.auth, this.userId, this.onSignedOut});

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (int index = 0; index < widget.pages.length; index++) {
      var d = widget.pages[index];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: index == _selectedDrawerIndex,
        onTap: () => _onSelectItem(index),
      ));
    }

    /// Logout button
    drawerOptions.add(new ListTile(
      leading: new Icon(Icons.exit_to_app),
      title: new Text('Logout'),
      onTap: () async {
        await widget.auth.signOut();
        widget.onSignedOut();
      },
    ));

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.pages[_selectedDrawerIndex].title),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text(FirebaseRepository.instance.technician.name),
                accountEmail: Text(FirebaseRepository.instance.technician.mail)),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: widget.pages[_selectedDrawerIndex],
    );
  }
}
