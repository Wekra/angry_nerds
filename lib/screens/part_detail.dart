import 'package:flutter/material.dart';
import 'package:service_app/data/model/part.dart';
import 'package:service_app/widgets/price.dart';

class PartDetailPage extends StatefulWidget {
  final Part part;

  const PartDetailPage(this.part);

  @override
  _PartDetailPageState createState() {
    return _PartDetailPageState();
  }
}

class _PartDetailPageState extends State<PartDetailPage> {
  Part part;

  @override
  void initState() {
    super.initState();
    part = widget.part;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        body: Container(
            padding: EdgeInsets.all(2.0),
            child: Card(
                elevation: 2,
                color: Color.fromARGB(50, 250, 250, 250),
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                      verticalDirection: VerticalDirection.down,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("${part.name}", style: TextStyle(fontSize: 45)),
                        Text(
                          "${part.description}",
                          style: TextStyle(fontSize: 20),
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                            child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  new PriceWidget(part.price, part.currency, TextStyle(fontSize: 18))
                                ]))
                      ]),
                ))));
  }
}
