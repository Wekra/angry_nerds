import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:quiver/core.dart';
import 'package:service_app/util/list_operations.dart';

typedef Future<Optional<T>> SnapshotMapper<T>(DataSnapshot snapshot);

class DatabaseNode<T> {
  final DataSnapshot snapshot;
  final T item;

  const DatabaseNode(this.snapshot, this.item);
}

class FirebaseQueryOperationStreamBuilder<T> with StreamSubscriberMixin<Event> {
  final List<DatabaseNode<T>> _items = new List();
  final StreamController<ListOperation<T>> _controller = new StreamController();
  bool _connectedEventDispatched = false;

  final Query query;
  final SnapshotMapper<T> snapshotMapper;

  Stream<ListOperation<T>> get stream => _controller.stream;

  FirebaseQueryOperationStreamBuilder(this.query, this.snapshotMapper) {
    _controller.onCancel = cancelSubscriptions;
    _controller.onListen = _listenToFirebaseEvents;
  }

  void _listenToFirebaseEvents() {
    listen(query.onValue, _onValue, onError: _onError);
    listen(query.onChildAdded, _onChildAdded, onError: _onError);
    listen(query.onChildRemoved, _onChildRemoved, onError: _onError);
    listen(query.onChildChanged, _onChildChanged, onError: _onError);
    listen(query.onChildMoved, _onChildMoved, onError: _onError);
  }

  void _onValue(Event event) {
    // "event.snapshot.value" is null here if given query does not return any items
    _notifyConnectedIfNecessary();
  }

  void _onChildAdded(Event event) {
    _notifyConnectedIfNecessary();
    snapshotMapper(event.snapshot).then((Optional<T> itemOpt) => itemOpt.ifPresent((T item) {
      int index = _nextIndexForKeyOrNull(event.previousSiblingKey) ?? _items.length;
      _items.insert(index, DatabaseNode<T>(event.snapshot, item));
      _controller.add(InsertOperation(index, item));
    }));
  }

  void _onChildRemoved(Event event) {
    _notifyConnectedIfNecessary();
    final int index = _indexForKeyOrNull(event.snapshot.key) ?? -1;
    if (index >= 0) {
      DatabaseNode node = _items.removeAt(index);
      _controller.add(DeleteOperation(index, node.item));
    }
  }

  void _onChildChanged(Event event) {
    _notifyConnectedIfNecessary();
    snapshotMapper(event.snapshot).then((Optional<T> itemOpt) => itemOpt.ifPresent((T item) {
      final int index = _indexForKeyOrNull(event.snapshot.key) ?? -1;
      if (index >= 0) {
        _items[index] = DatabaseNode<T>(event.snapshot, item);
        _controller.add(UpdateOperation(index, item));
      }
    }));
  }

  void _onChildMoved(Event event) {
    _notifyConnectedIfNecessary();
    final int fromIndex = _indexForKeyOrNull(event.snapshot.key) ?? -1;
    if (fromIndex >= 0) {
      DatabaseNode oldNode = _items.removeAt(fromIndex);
      final int toIndex = _nextIndexForKeyOrNull(event.previousSiblingKey) ?? _items.length;
      _items.insert(toIndex, DatabaseNode<T>(event.snapshot, oldNode.item));
      _controller.add(MoveOperation(fromIndex, toIndex, oldNode.item));
    }
  }

  void _notifyConnectedIfNecessary() {
    if (!_connectedEventDispatched) {
      _connectedEventDispatched = true;
      _controller.add(new ListConnectedEvent());
    }
  }

  int _nextIndexForKeyOrNull(String key) {
    final int index = _indexForKeyOrNull(key);
    return index != null ? index + 1 : null;
  }

  int _indexForKeyOrNull(String key) {
    if (key != null) {
      for (int index = 0; index < _items.length; index++) {
        if (key == _items[index].snapshot.key) {
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
