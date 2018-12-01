import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:meta/meta.dart';
import 'package:quiver/core.dart';
import 'package:service_app/data/model/base_entity.dart';
import 'package:service_app/util/list_operations.dart';

Optional<T> buildItemFromSnapshot<T extends BaseEntity>(DataSnapshot snapshot, JsonMapper<T> itemMapper) {
  final String id = snapshot?.key;
  final Map<dynamic, dynamic> map = snapshot?.value;
  if (id != null && map != null) {
    final T item = itemMapper(id, map);
    return Optional.of(item);
  }
  return Optional.absent();
}

typedef T JsonMapper<T extends BaseEntity>(String id, Map<dynamic, dynamic> map);

/// Base class for helpers to create [Stream]s of [ListOperation]s that are applied to the given Firebase collections.
/// This is useful to create list widgets that reflect the current items of a Firebase collection in real time.
///
/// When a subscriber is added to the returned [Stream] then instances of [InsertOperation] are immediately emitted
/// until the subscriber can correctly represent the given Firebase collection. At that point a [ListLoadedEvent] is
/// emitted once to signal that further [ListOperation]s are actual updates in the Firebase collection.
abstract class BaseOperationStreamBuilder<T extends BaseEntity> with StreamSubscriberMixin<Event> {
  final List<T> _items = new List();
  final StreamController<ListOperation<T>> _controller = new StreamController();
  bool _loadedEventDispatched = false;

  final JsonMapper<T> itemMapper;

  Stream<ListOperation<T>> get stream => _controller.stream;

  BaseOperationStreamBuilder(this.itemMapper) {
    _controller.onCancel = cancelSubscriptions;
    _controller.onListen = _listenToFirebaseEvents;
  }

  void _listenToFirebaseEvents();

  /// This method should be set as "onValue" listener after all other listeners have been set.
  @protected
  void _onValue(Event event) {
    // This method is triggered after all initial insert operations have been emitted.
    // "event.snapshot.value" is null here if given query does not return any items.
    if (!_loadedEventDispatched) {
      _loadedEventDispatched = true;
      _controller.add(new ListLoadedEvent());
    }
  }

  @protected
  int _nextIndexForIdOrNull(String id) {
    final int index = _indexForIdOrNull(id);
    return index != null ? index + 1 : null;
  }

  @protected
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

  @protected
  void _handleError(Object object) {
    if (object is DatabaseError) {
      print("DatabaseError ${object.code} [${object.message}]: ${object.details}");
    } else {
      print("Unknown error: ${object.toString()}");
    }
  }
}

class ForeignKeyCollectionOperationStreamBuilder<T extends BaseEntity> extends BaseOperationStreamBuilder<T> {
  final Query itemIdsQuery;
  final Query itemDetailQuery;

  ForeignKeyCollectionOperationStreamBuilder(JsonMapper<T> itemMapper, this.itemIdsQuery, this.itemDetailQuery)
      : super(itemMapper);

  @override
  void _listenToFirebaseEvents() {
    listen(itemIdsQuery.onChildAdded, _onItemIdAdded, onError: _handleError);
    listen(itemIdsQuery.onChildRemoved, _onItemIdRemoved, onError: _handleError);
    listen(itemIdsQuery.onChildMoved, _onItemIdMoved, onError: _handleError);
    listen(itemIdsQuery.onValue, _onValue, onError: _handleError);

    listen(itemDetailQuery.onChildChanged, _onItemChanged, onError: _handleError);
  }

  void _onItemIdAdded(Event event) {
    final String id = event.snapshot.key;
    final DatabaseReference child = itemDetailQuery.reference().child(id);
    child.once().then((DataSnapshot snapshot) =>
        buildItemFromSnapshot(snapshot, itemMapper).ifPresent((T item) {
          final int index = _nextIndexForIdOrNull(event.previousSiblingKey) ?? 0;
          _items.insert(index, item);
          _controller.add(InsertOperation(index, item));
        }));
  }

  void _onItemIdRemoved(Event event) {
    final String id = event.snapshot.key;
    final int index = _indexForIdOrNull(id) ?? -1;
    if (index < 0) {
      print("Received ItemIdRemoved event for ID '$id' which does not exist in list");
    } else {
      final T item = _items.removeAt(index);
      _controller.add(DeleteOperation(index, item));
    }
  }

  void _onItemIdMoved(Event event) {
    final String id = event.snapshot.key;
    final int fromIndex = _indexForIdOrNull(id) ?? -1;
    if (fromIndex < 0) {
      print("Received ItemIdMoved event for ID '$id' which does not exist in list");
    } else {
      final int toIndex = _nextIndexForIdOrNull(event.previousSiblingKey) ?? _items.length;
      if (fromIndex != toIndex) {
        final T item = _items.removeAt(fromIndex);
        _items.insert(toIndex, item);
        _controller.add(MoveOperation(fromIndex, toIndex, item));
      }
    }
  }

  void _onItemChanged(Event event) {
    buildItemFromSnapshot(event.snapshot, itemMapper).ifPresent((T item) {
      final int index = _indexForIdOrNull(item.id) ?? -1;
      if (index < 0) {
        print("Received ItemChanged event for ID '${item.id}' which does not exist in list");
      } else {
        _items[index] = item;
        _controller.add(UpdateOperation(index, item));
      }
    });
  }
}

class SingleCollectionOperationStreamBuilder<T extends BaseEntity> extends BaseOperationStreamBuilder<T> {
  final Query itemQuery;

  SingleCollectionOperationStreamBuilder(JsonMapper<T> itemMapper, this.itemQuery) : super(itemMapper);

  @override
  void _listenToFirebaseEvents() {
    listen(itemQuery.onChildAdded, _onItemAdded, onError: _handleError);
    listen(itemQuery.onChildRemoved, _onItemRemoved, onError: _handleError);
    listen(itemQuery.onChildMoved, _onItemMoved, onError: _handleError);
    listen(itemQuery.onChildChanged, _onItemChanged, onError: _handleError);
    listen(itemQuery.onValue, _onValue, onError: _handleError);
  }

  void _onItemAdded(Event event) {
    buildItemFromSnapshot(event.snapshot, itemMapper).ifPresent((T item) {
      final int index = _nextIndexForIdOrNull(event.previousSiblingKey) ?? 0;
      _items.insert(index, item);
      _controller.add(InsertOperation(index, item));
    });
  }

  void _onItemRemoved(Event event) {
    final String id = event.snapshot.key;
    final int index = _indexForIdOrNull(id) ?? -1;
    if (index < 0) {
      print("Received ItemIdRemoved event for ID '$id' which does not exist in list");
    } else {
      final T item = _items.removeAt(index);
      _controller.add(DeleteOperation(index, item));
    }
  }

  void _onItemMoved(Event event) {
    final String id = event.snapshot.key;
    final int fromIndex = _indexForIdOrNull(id) ?? -1;
    if (fromIndex < 0) {
      print("Received ItemIdMoved event for ID '$id' which does not exist in list");
    } else {
      final int toIndex = _nextIndexForIdOrNull(event.previousSiblingKey) ?? _items.length;
      if (fromIndex != toIndex) {
        final T item = _items.removeAt(fromIndex);
        _items.insert(toIndex, item);
        _controller.add(MoveOperation(fromIndex, toIndex, item));
      }
    }
  }

  void _onItemChanged(Event event) {
    buildItemFromSnapshot(event.snapshot, itemMapper).ifPresent((T item) {
      final int index = _indexForIdOrNull(item.id) ?? -1;
      if (index < 0) {
        print("Received ItemChanged event for ID '${item.id}' which does not exist in list");
      } else {
        _items[index] = item;
        _controller.add(UpdateOperation(index, item));
      }
    });
  }
}
