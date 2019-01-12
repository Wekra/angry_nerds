import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/warehouse_order.dart';
import 'package:service_app/screens/order_detail.dart';
import 'package:service_app/widgets/animated_operations_list.dart';
import 'package:service_app/widgets/status_indicator.dart';

class InventoryOrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: AnimatedOperationsList(
          stream: FirebaseRepository.instance.getOrdersOfTechnician(), itemBuilder: _buildListItem),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailPage(null))),
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context, WarehouseOrder order, Animation<double> animation, int index) {
    return FadeTransition(
      opacity: animation,
      child: ListTile(
        title: Text((order.description.isNotEmpty) ? order.description : "(No description)"),
        subtitle: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          Text("${order.partBundles.length} part bundles,"),
          new StatusIndicatorWidget(order.status)
        ]),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => OrderDetailPage(order))),
        onLongPress: () => _showDeleteDialog(context, order),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WarehouseOrder order) {
    AlertDialog dialog = AlertDialog(
      title: Text("Delete order \"${order.description}\"?"),
      actions: <Widget>[
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Yes"),
          onPressed: () {
            FirebaseRepository.instance.deleteOrderForTechnician(order.id);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(context: context, builder: (context) => dialog);
  }
}
