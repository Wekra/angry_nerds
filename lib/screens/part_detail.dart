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
      appBar: AppBar(
        title: Text("Part Details"),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Name: ${part.name}"),
            Text("Description: ${part.description}"),
            new PriceWidget(part.price, part.currency)
          ]),
    );
  }
}
