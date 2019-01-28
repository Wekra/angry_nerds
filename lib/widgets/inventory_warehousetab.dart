import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/part_bundle.dart';
import 'package:service_app/widgets/animated_operations_list.dart';
import 'package:service_app/widgets/part.dart';

class InventoryWarehouseTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: AnimatedOperationsList(
          stream: FirebaseRepository.instance.getPartBundlesOfTechnician(),
          itemBuilder: _buildListItem),
    );
  }

  Widget _buildListItem(
      BuildContext context, PartBundle bundle, Animation<double> animation, int index) {
    return FadeTransition(
        opacity: animation,
        child: PartBundleWidget(
          bundle,
          modifiable: false,
        ));
  }
}
