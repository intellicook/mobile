import 'package:flutter/material.dart';

typedef ClickableOnClickedCallback = VoidCallback;

typedef ClickableOnPressedCallback = VoidCallback;

typedef ClickableOnReleasedCallback = VoidCallback;

typedef ClickableOnStateChangedCallback = ValueChanged<bool>;

class Clickable extends StatefulWidget {
  const Clickable({
    super.key,
    this.onClicked,
    this.onPressed,
    this.onReleased,
    this.onStateChanged,
    this.child,
  });

  final ClickableOnClickedCallback? onClicked;
  final ClickableOnPressedCallback? onPressed;
  final ClickableOnReleasedCallback? onReleased;
  final ClickableOnStateChangedCallback? onStateChanged;
  final Widget? child;

  @override
  State<Clickable> createState() => _ClickableState();
}

class _ClickableState extends State<Clickable> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        if (isPressed) {
          false;
        }

        setState(() {
          isPressed = true;
        });

        widget.onStateChanged?.call(true);
        widget.onPressed?.call();
      },
      onPointerUp: (PointerUpEvent event) {
        if (!isPressed) {
          return;
        }

        setState(() {
          isPressed = false;
        });

        widget.onStateChanged?.call(false);
        widget.onReleased?.call();
        widget.onClicked?.call();
      },
      onPointerCancel: (PointerCancelEvent event) {
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
