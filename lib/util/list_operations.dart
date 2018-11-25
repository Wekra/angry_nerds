abstract class ListOperation<T> {
  const ListOperation();
}

class ListConnectedEvent<T> extends ListOperation<T> {
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

class MoveOperation<T> extends ListOperation<T> {
  final int fromIndex;
  final int toIndex;
  final T item;

  const MoveOperation(this.fromIndex, this.toIndex, this.item);
}

class UpdateOperation<T> extends ListOperation<T> {
  final int index;
  final T newItem;

  const UpdateOperation(this.index, this.newItem);
}
