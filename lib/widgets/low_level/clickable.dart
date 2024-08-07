import 'package:flutter/material.dart';

typedef ClickableOnClickedCallback = VoidCallback;

typedef ClickableOnPressedCallback = VoidCallback;

typedef ClickableOnReleasedCallback = VoidCallback;

typedef ClickableOnStateChangedCallback = ValueChanged<bool>;

class Clickable extends StatefulWidget {
  Clickable({
    super.key,
    this.onClicked,
    this.onPressed,
    this.onReleased,
    this.onStateChanged,
    this.child,
  });

  /// Called when the clickable is clicked.
  ///
  /// If the pointer moved outside the clickable while pressed, this callback
  /// will not be called.
  final ClickableOnClickedCallback? onClicked;

  /// Called when the clickable is pressed.
  final ClickableOnPressedCallback? onPressed;

  /// Called when the clickable is released.
  ///
  /// If the pointer moved outside the clickable while pressed, this callback
  /// will not be called.
  final ClickableOnReleasedCallback? onReleased;

  /// Called when the clickable's state changes.
  ///
  /// The callback will be called even if the pointer is outside the clickable
  /// while released.
  final ClickableOnStateChangedCallback? onStateChanged;

  final Widget? child;

  final GlobalKey _listenerKey = GlobalKey();

  @override
  State<Clickable> createState() => _ClickableState();
}

class _ClickableState extends State<Clickable> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      key: widget._listenerKey,
      onPointerDown: (event) {
        if (isPressed) {
          false;
        }

        setState(() {
          isPressed = true;
        });

        widget.onStateChanged?.call(true);
        widget.onPressed?.call();
      },
      onPointerUp: (event) {
        if (!isPressed) {
          return;
        }

        setState(() {
          isPressed = false;
        });

        widget.onStateChanged?.call(false);

        if (!(widget._listenerKey.currentContext
                ?.findRenderObject()
                ?.semanticBounds
                .contains(event.localPosition) ??
            false)) {
          return;
        }

        widget.onReleased?.call();
        widget.onClicked?.call();
      },
      onPointerCancel: (event) {
        if (!isPressed) {
          return;
        }

        setState(() {
          isPressed = false;
        });

        widget.onStateChanged?.call(false);
      },
      child: widget.child,
    );
  }
}
