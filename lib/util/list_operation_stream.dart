import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:quiver/core.dart';
import 'package:service_app/util/list_operations.dart';

typedef T JsonMapper<T>(String id, Map<dynamic, dynamic> map);

class DatabaseNode<T> {
  final String id;
  final T item;

  const DatabaseNode(this.id, this.item);
}

class FirebaseQueryOperationStreamBuilder<T> with StreamSubscriberMixin<Event> {
  final List<DatabaseNode<T>> _items = new List();
  final StreamController<ListOperation<T>> _controller = new StreamController();
  bool _connectedEventDispatched = false;

  final Query itemIdsQuery;
  final Query itemDetailQuery;
  final JsonMapper<T> itemDetailMapper;

  Stream<ListOperation<T>> get stream => _controller.stream;

  FirebaseQueryOperationStreamBuilder(this.itemIdsQuery, this.itemDetailQuery, this.itemDetailMapper) {
    _controller.onCancel = cancelSubscriptions;
    _controller.onListen = _listenToFirebaseEvents;
  }

  void _listenToFirebaseEvents() {
    listen(itemIdsQuery.onValue, _onValue, onError: _onError);
    listen(itemIdsQuery.onChildAdded, _onItemIdAdded, onError: _onError);
    listen(itemIdsQuery.onChildRemoved, _onItemIdRemoved, onError: _onError);
    listen(itemIdsQuery.onChildMoved, _onItemIdMoved, onError: _onError);

    listen(itemDetailQuery.onValue, _onValue, onError: _onError);
    listen(itemDetailQuery.onChildChanged, _onItemChanged, onError: _onError);
  }

  void _onValue(Event event) {
    // "event.snapshot.value" is null here if given query does not return any items
    _notifyConnectedIfNecessary();
  }

  void _onItemIdAdded(Event event) {
    _notifyConnectedIfNecessary();
    final String id = event.snapshot.key;
    final DatabaseReference child = itemDetailQuery.reference().child(id);
    child.once().then((DataSnapshot snapshot) =>
        _buildNode(snapshot).ifPresent((DatabaseNode<T> node) {
          final int index = _nextIndexForIdOrNull(event.previousSiblingKey) ?? 0;
          _items.insert(index, node);
          _controller.add(InsertOperation(index, node.item));
        }));
  }

  void _onItemIdRemoved(Event event) {
    _notifyConnectedIfNecessary();
    final String id = event.snapshot.key;
    final int index = _indexForIdOrNull(id) ?? -1;
    if (index < 0) {
      print("Received ItemIdRemoved event for ID '$id' which does not exist in list");
    } else {
      final DatabaseNode<T> node = _items.removeAt(index);
      _controller.add(DeleteOperation(index, node.item));
    }
  }

  void _onItemChanged(Event event) {
    _notifyConnectedIfNecessary();
    _buildNode(event.snapshot).ifPresent((DatabaseNode<T> node) {
      final int index = _indexForIdOrNull(node.id) ?? -1;
      if (index < 0) {
        print("Received ItemChanged event for ID '${node.id}' which does not exist in list");
      } else {
        _items[index] = node;
        _controller.add(UpdateOperation(index, node.item));
      }
    });
  }

  void _onItemIdMoved(Event event) {
    _notifyConnectedIfNecessary();
    final String id = event.snapshot.key;
    final int fromIndex = _indexForIdOrNull(id) ?? -1;
    if (fromIndex < 0) {
      print("Received ItemIdMoved event for ID '$id' which does not exist in list");
    } else {
      final int toIndex = _nextIndexForIdOrNull(event.previousSiblingKey) ?? _items.length;
      if (fromIndex != toIndex) {
        final DatabaseNode<T> node = _items.removeAt(fromIndex);
        _items.insert(toIndex, node);
        _controller.add(MoveOperation(fromIndex, toIndex, node.item));
      }
    }
  }

  void _notifyConnectedIfNecessary() {
    if (!_connectedEventDispatched) {
      _connectedEventDispatched = true;
      _controller.add(new ListConnectedEvent());
    }
  }

  Optional<DatabaseNode<T>> _buildNode(DataSnapshot snapshot) {
    final String id = snapshot?.key;
    final Map<dynamic, dynamic> map = snapshot?.value;
    if (id != null && map != null) {
      final T item = itemDetailMapper(id, map);
      return Optional.of(DatabaseNode<T>(id, item));
    }
    return Optional.absent();
  }

  int _nextIndexForIdOrNull(String id) {
    final int index = _indexForIdOrNull(id);
    return index != null ? index + 1 : null;
  }

  int _indexForIdOrNull(String id) {
    if (id != null) {
      for (int index = 0; index < _items.length; index++) {
        if (id == _items[index].id) {
          return index;
        }
      }
    }
    return null;
  }

  void _onError(Object object) {
    if (object is DatabaseError) {
      print("DatabaseError ${object.code} [${object.message}]: ${object.details}");
    } else {
      print("Unknown error: ${object.toString()}");
    }
  }
}
