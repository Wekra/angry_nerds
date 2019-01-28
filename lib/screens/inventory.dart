import 'package:flutter/material.dart';
import 'package:service_app/screens/drawer_page.dart';
import 'package:service_app/widgets/inventory_orderstab.dart';
import 'package:service_app/widgets/inventory_warehousetab.dart';

class InventoryPage extends DrawerPage {
  InventoryPage();

  @override
  String get title => "Inventory";

  @override
  IconData get icon => Icons.shopping_cart;

  @override
  _InventoryPageState createState() {
    return _InventoryPageState();
  }
}

class _InventoryPageState extends State<InventoryPage> {
  _InventoryPageState();

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 2,
        child: new Scaffold(
            appBar: new TabBar(
              tabs: <Widget>[new Tab(text: "Orders"), new Tab(text: "Warehouse")],
            ),
            body: new TabBarView(
              children: <Widget>[
                new InventoryOrdersTab(),
                new InventoryWarehouseTab()
                //new Center(
                //child: Text("Here goes the warehouse"),
                //)
              ],
            )));
  }
}
