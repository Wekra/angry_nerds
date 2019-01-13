import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiver/core.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/part.dart';
import 'package:service_app/data/model/part_bundle.dart';
import 'package:service_app/widgets/price.dart';

class PartBundleWidget extends StatefulWidget {
  final PartBundle bundle;
  final bool modifiable;
  final Function(PartBundle newBundle) onBundleChanged;

  PartBundleWidget(this.bundle, {this.modifiable = false, this.onBundleChanged});

  @override
  State<StatefulWidget> createState() => _PartBundleWidgetState();
}

class _PartBundleWidgetState extends State<PartBundleWidget> {
  Part part;
  StreamSubscription<Optional<Part>> partSubscription;

  @override
  void initState() {
    super.initState();
    _listenForPartUpdates(widget.bundle.partId);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(part?.name ?? "Loading..."),
      subtitle: Text(part?.description ?? "Loading..."),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: _buildTrailingWidgets(),
      ),
    );
  }

  List<Widget> _buildTrailingWidgets() {
    if (part == null) return [];

    if (widget.modifiable) {
      return [
        PriceWidget(part.price, part.currency),
        Container(width: 32),
        IconButton(
          icon: Icon(Icons.remove_circle_outline),
          onPressed: () {
            PartBundle bundle = widget.bundle;
            if (widget.onBundleChanged != null && bundle.quantity > 1) {
              widget.onBundleChanged(bundle.withQuantity(bundle.quantity - 1));
            }
          },
        ),
        Text(widget.bundle.quantity.toString()),
        IconButton(
          icon: Icon(Icons.add_circle_outline),
          onPressed: () {
            PartBundle bundle = widget.bundle;
            if (widget.onBundleChanged != null && bundle.quantity < 100) {
              widget.onBundleChanged(bundle.withQuantity(bundle.quantity + 1));
            }
          },
        ),
      ];
    } else {
      return [
        PriceWidget(part.price, part.currency),
        Container(width: 32),
        Text("Quantity: ${widget.bundle.quantity}"),
      ];
    }
  }

  @override
  void didUpdateWidget(PartBundleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    String newPartId = widget.bundle.partId;
    if (oldWidget.bundle.partId != newPartId) {
      _listenForPartUpdates(newPartId);
    }
  }

  void _listenForPartUpdates(String partId) {
    partSubscription?.cancel();
    partSubscription = FirebaseRepository.instance.getPartById(partId).listen(_handlePartUpdate);
  }

  void _handlePartUpdate(Optional<Part> newPartOpt) {
    setState(() => part = newPartOpt.orNull);
  }

  @override
  void dispose() {
    partSubscription?.cancel();
    partSubscription = null;
    super.dispose();
  }
}
