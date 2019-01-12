import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:service_app/data/model/warehouse_order.dart';

class StatusIndicatorWidget extends StatelessWidget {
  final WarehouseOrderStatus _status;

  const StatusIndicatorWidget(this._status);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (_status) {
      case WarehouseOrderStatus.open:
        icon = FontAwesomeIcons.hourglassStart;
        color = Colors.black;
        break;
      case WarehouseOrderStatus.inProgress:
        icon = FontAwesomeIcons.spinner;
        color = Colors.orange;
        break;
      case WarehouseOrderStatus.delivered:
        icon = FontAwesomeIcons.check;
        color = Colors.green;
        break;
      case WarehouseOrderStatus.cancelled:
        icon = Icons.cancel;
        color = Colors.red;
        break;
    }

    return new Container(
        child: new Directionality(
            textDirection: TextDirection.ltr,
            child: new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              new Icon(
                icon,
                color: color,
                size: 20,
                semanticLabel: _status.toString().substring(0, 1).toUpperCase() +
                    _status.toString().substring(1),
              ),
            ])));
  }
}
