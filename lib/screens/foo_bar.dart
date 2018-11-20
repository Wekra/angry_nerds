import 'package:flutter/material.dart';
import 'package:service_app/widgets/navigation_drawer.dart';

/// Test page to test nav drawer
class FooBarPage extends StatefulWidget {
  @override
  _FooBarPageState createState() {
    return _FooBarPageState();
  }
}

class _FooBarPageState extends State<FooBarPage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: Text('foobar'),
      drawer: NavDrawer(),
    );
  }
}