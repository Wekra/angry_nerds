import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:service_app/util/list_operation_stream.dart';

typedef Widget AnimatedOperationsListItemBuilder<T>(
    BuildContext context, T item, Animation<double> animation, int index);

/// An AnimatedList widget that updates itself automatically based on a [Stream] of [ListOperation].
class AnimatedOperationsList<T> extends StatefulWidget {
  /// Creates a scrolling container that animates items when they are inserted or removed.
  AnimatedOperationsList({
    Key key,
    @required this.stream,
    @required this.itemBuilder,
    this.loadingWidget,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key) {
    assert(stream != null);
    assert(itemBuilder != null);
  }

  /// A stream to use to populate and update the animated list
  final Stream<ListOperation<T>> stream;

  /// Called, as needed, to build list item widgets.
  ///
  /// List items are only built when they're scrolled into view.
  ///
  /// Implementations of this callback should assume that [AnimatedList.removeItem]
  /// removes an item immediately.
  final AnimatedOperationsListItemBuilder<T> itemBuilder;

  /// A widget to display while the query is loading. Defaults to an empty
  /// Container().
  final Widget loadingWidget;

  /// The axis along which the scroll view scrolls.
  ///
  /// Defaults to [Axis.vertical].
  final Axis scrollDirection;

  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// For example, if the reading direction is left-to-right and
  /// [scrollDirection] is [Axis.horizontal], then the scroll view scrolls from
  /// left to right when [reverse] is false and from right to left when
  /// [reverse] is true.
  ///
  /// Similarly, if [scrollDirection] is [Axis.vertical], then the scroll view
  /// scrolls from top to bottom when [reverse] is false and from bottom to top
  /// when [reverse] is true.
  ///
  /// Defaults to false.
  final bool reverse;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// Must be null if [primary] is true.
  final ScrollController controller;

  /// Whether this is the primary scroll view associated with the parent
  /// [PrimaryScrollController].
  ///
  /// On iOS, this identifies the scroll view that will scroll to top in
  /// response to a tap in the status bar.
  ///
  /// Defaults to true when [scrollDirection] is [Axis.vertical] and
  /// [controller] is null.
  final bool primary;

  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics physics;

  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  ///
  /// If the scroll view does not shrink wrap, then the scroll view will expand
  /// to the maximum allowed size in the [scrollDirection]. If the scroll view
  /// has unbounded constraints in the [scrollDirection], then [shrinkWrap] must
  /// be true.
  ///
  /// Shrink wrapping the content of the scroll view is significantly more
  /// expensive than expanding to the maximum allowed size because the content
  /// can expand and contract during scrolling, which means the size of the
  /// scroll view needs to be recomputed whenever the scroll position changes.
  ///
  /// Defaults to false.
  final bool shrinkWrap;

  /// The amount of space by which to inset the children.
  final EdgeInsets padding;

  /// The duration of the insert and remove animation.
  ///
  /// Defaults to const Duration(milliseconds: 300).
  final Duration duration;

  @override
  State createState() => AnimatedOperationsListState<T>();
}

class AnimatedOperationsListState<T> extends State<AnimatedOperationsList<T>> {
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();
  final List<T> _items = new List();
  bool _loaded = false;
  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = widget.stream.listen(_handleOperation);
  }

  @override
  void dispose() {
    super.dispose();
    disposeSubscription();
  }

  void disposeSubscription() {
    subscription?.cancel();
    subscription = null;
  }

  void _handleOperation(ListOperation<T> operation) {
    _loaded = true;
    if (operation is InsertOperation<T>) {
      _items.insert(operation.index, operation.item);
      _animatedListKey.currentState?.insertItem(operation.index, duration: widget.duration);
    } else if (operation is DeleteOperation<T>) {
      _items.removeAt(operation.index);
      _animatedListKey.currentState?.removeItem(
        operation.index,
        (BuildContext context, Animation<double> animation) =>
            widget.itemBuilder(context, operation.item, animation, operation.index),
        duration: widget.duration,
      );
    } else if (operation is UpdateOperation<T>) {
      // No animation, just update contents
      setState(() {});
    } else if (operation is MoveOperation<T>) {
      // No animation, just update contents
      setState(() {});
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return widget.loadingWidget ?? Container();
    }
    return AnimatedList(
      key: _animatedListKey,
      itemBuilder: _buildItem,
      initialItemCount: _items.length,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
    );
  }

  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
    return widget.itemBuilder(context, _items[index], animation, index);
  }
}
