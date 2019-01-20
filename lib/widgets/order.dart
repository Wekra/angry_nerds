import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_app/data/model/warehouse_order.dart';
import 'package:service_app/screens/order_detail.dart';
import 'package:service_app/widgets/status_indicator.dart';

class OrderListTile extends StatelessWidget {
  final WarehouseOrder order;
  final GestureLongPressCallback onLongPress;

  OrderListTile(this.order, {this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text((order.description.isNotEmpty) ? order.description : "(No description)"),
      subtitle: Text("${order.partBundles.length} part bundles"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[StatusIndicatorWidget(order.status)],
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailPage(order))),
      onLongPress: onLongPress,
    );
  }
}
