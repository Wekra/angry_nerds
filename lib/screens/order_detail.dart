import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/part.dart';
import 'package:service_app/data/model/part_bundle.dart';
import 'package:service_app/data/model/warehouse_order.dart';
import 'package:service_app/screens/part_list.dart';
import 'package:service_app/util/id_generator.dart';

class OrderDetailPage extends StatefulWidget {
  final WarehouseOrder order;

  const OrderDetailPage(this.order);

  @override
  _OrderDetailPageState createState() {
    return _OrderDetailPageState(order);
  }
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool _newOrder;

  final _formKey = GlobalKey<FormState>();

  String _orderId;
  final TextEditingController _description = TextEditingController();
  List<PartBundle> _partBundles;

  _OrderDetailPageState(WarehouseOrder order) {
    if (order != null) {
      _initForExistingOrder(order);
    } else {
      _initForNewOrder();
    }
  }

  void _initForExistingOrder(WarehouseOrder order) {
    _newOrder = false;
    _orderId = order.id;
    _description.text = order.description;
    _partBundles = order.partBundles;
  }

  void _initForNewOrder() {
    _newOrder = true;
    _orderId = IdGenerator.generatePushChildName();
    _description.text = "";
    _partBundles = [];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Order details"),
        actions: _buildActions(),
      ),
      body: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      enabled: _newOrder,
                      controller: _description,
                      decoration: InputDecoration(labelText: "Description", disabledBorder: InputBorder.none),
                    ),
                  ],
                ),
              )),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _partBundles.length,
              itemBuilder: _buildPartBundleWidget,
            ),
          ),
        ],
      ),
      floatingActionButton: _newOrder ? _buildFloatingActionButton() : null,
    );
  }

  List<Widget> _buildActions() {
    if (!_newOrder) return [];
    return [
      IconButton(
        icon: Icon(Icons.check),
        onPressed: _createOrder,
      )
    ];
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: new Icon(Icons.add),
      onPressed: _selectPart,
    );
  }

  void _selectPart() {
    Navigator.push<Part>(context, MaterialPageRoute(builder: (context) => PartListPage())).then((Part part) {
      _partBundles.add(PartBundle(1, part.id));
      setState(() {});
    });
  }

  Widget _buildPartBundleWidget(BuildContext context, int index) {
    PartBundle bundle = _partBundles[index];
    return ListTile(
      title: Text("Part ID: ${bundle.partId}"),
      subtitle: Text("Quantity: ${bundle.quantity}"),
    );
  }

  void _createOrder() {
    WarehouseOrder order = WarehouseOrder(
        _orderId, _description.text, DateTime.now(), WarehouseOrderStatus.open, "Order submitted", _partBundles);
    FirebaseRepository.instance.createOrderForTechnician(order).then((unused) {
      setState(() {
        _newOrder = false;
      });
    });
  }
}
