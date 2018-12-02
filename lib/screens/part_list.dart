import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/part.dart';
import 'package:service_app/widgets/animated_operations_list.dart';

class PartListPage extends StatefulWidget {
  @override
  _PartListPageState createState() {
    return _PartListPageState();
  }
}

class _PartListPageState extends State<PartListPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Part list"),
      ),
      body: AnimatedOperationsList(stream: FirebaseRepository.instance.getAllParts(), itemBuilder: _buildListItem),
    );
  }

  Widget _buildListItem(BuildContext context, Part part, Animation<double> animation, int index) {
    return FadeTransition(
      opacity: animation,
      child: ListTile(
        title: Text(part.name),
        subtitle: Text(part.description),
        onTap: () => Navigator.pop(context, part),
      ),
    );
  }
}
