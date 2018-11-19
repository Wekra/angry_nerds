import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/widgets.dart';

/// List that renders items of the passed firebase collection.
/// It renders the items by calling the passed item builder callback.
class ConnectedList extends StatelessWidget {

  final DatabaseReference collectionRef;
  final ItemCallback itemBuilder;

  /// Constructor
  ConnectedList(this.collectionRef, this.itemBuilder);

  @override
  Widget build(context) {
    return FirebaseAnimatedList(
        query: collectionRef,
        reverse: false,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          return SizeTransition(
              sizeFactor: animation,
              child: itemBuilder(snapshot.value)
          );
        });
  }
}

typedef ItemCallback = Widget Function(Object item);
