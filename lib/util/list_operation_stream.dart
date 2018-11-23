import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:quiver/core.dart';

typedef Future<Optional<T>> SnapshotMapper<T>(DataSnapshot snapshot);

class FirebaseQueryOperationStreamBuilder<T> with StreamSubscriberMixin<Event> {
  final Query query;
  final SnapshotMapper<T> snapshotMapper;
  final StreamController<ListOperation<T>> _controller = new StreamController();

  Stream<ListOperation<T>> get stream => _controller.stream;

  final List<DatabaseNode<T>> _items = new List();

  FirebaseQueryOperationStreamBuilder(this.query, this.snapshotMapper) {
    _controller.onCancel = cancelSubscriptions;
    _controller.onListen = _listenToFirebaseEvents;
  }

  void _listenToFirebaseEvents() {
    listen(query.onChildAdded, _onChildAdded, onError: _onError);
    listen(query.onChildRemoved, _onChildRemoved, onError: _onError);
    listen(query.onChildChanged, _onChildChanged, onError: _onError);
    listen(query.onChildMoved, _onChildMoved, onError: _onError);
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

  int _nextIndexForKeyOrNull(String key) {
    final int index = _indexForKeyOrNull(key);
    return index != null ? index + 1 : null;
  }

  void _onChildAdded(Event event) {
    snapshotMapper(event.snapshot).then((Optional<T> itemOpt) => itemOpt.ifPresent((T item) {
          int index = _nextIndexForKeyOrNull(event.previousSiblingKey) ?? _items.length;
          _items.insert(index, DatabaseNode<T>(event.snapshot, item));
          _controller.add(InsertOperation(index, item));
        }));
  }

  void _onChildRemoved(Event event) {
    final int index = _indexForKeyOrNull(event.snapshot.key) ?? -1;
    if (index >= 0) {
      DatabaseNode node = _items.removeAt(index);
      _controller.add(DeleteOperation(index, node.item));
    }
  }

  void _onChildChanged(Event event) {
    snapshotMapper(event.snapshot).then((Optional<T> itemOpt) => itemOpt.ifPresent((T item) {
          final int index = _indexForKeyOrNull(event.snapshot.key) ?? -1;
          if (index >= 0) {
            _items[index] = DatabaseNode<T>(event.snapshot, item);
            _controller.add(UpdateOperation(index, item));
          }
        }));
  }

  void _onChildMoved(Event event) {
    final int fromIndex = _indexForKeyOrNull(event.snapshot.key) ?? -1;
    if (fromIndex >= 0) {
      DatabaseNode oldNode = _items.removeAt(fromIndex);
      final int toIndex = _nextIndexForKeyOrNull(event.previousSiblingKey) ?? _items.length;
      _items.insert(toIndex, DatabaseNode<T>(event.snapshot, oldNode.item));
      _controller.add(MoveOperation(fromIndex, toIndex, oldNode.item));
    }
  }

  void _onError(Object o) {
    // TODO Handle error
  }
}

class DatabaseNode<T> {
  final DataSnapshot snapshot;
  final T item;

  const DatabaseNode(this.snapshot, this.item);
}

abstract class ListOperation<T> {
  const ListOperation();
}

class InsertOperation<T> extends ListOperation<T> {
  final int index;
  final T item;

  const InsertOperation(this.index, this.item);
}

class DeleteOperation<T> extends ListOperation<T> {
  final int index;
  final T item;

  DeleteOperation(this.index, this.item);
}

class UpdateOperation<T> extends ListOperation<T> {
  final int index;
  final T newItem;

  const UpdateOperation(this.index, this.newItem);
}

class MoveOperation<T> extends ListOperation<T> {
  final int fromIndex;
  final int toIndex;
  final T item;

  const MoveOperation(this.fromIndex, this.toIndex, this.item);
}
