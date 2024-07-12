import 'package:flutter/material.dart';

typedef ClickableOnClickCallback = void Function();

typedef ClickableOnPressCallback = void Function();

typedef ClickableOnReleaseCallback = void Function();

typedef ClickableOnStateChangeCallback = void Function(bool);

class Clickable extends StatefulWidget {
  const Clickable({
    super.key,
    this.onClick,
    this.onPress,
    this.onRelease,
    this.onStateChange,
    this.child,
  });

  final ClickableOnClickCallback? onClick;
  final ClickableOnPressCallback? onPress;
  final ClickableOnReleaseCallback? onRelease;
  final ClickableOnStateChangeCallback? onStateChange;
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
          widget.onStateChange?.call(isPressed);
          widget.onPress?.call();
        });
      },
      onPointerUp: (PointerUpEvent event) {
        if (!isPressed) {
          return;
        }

        setState(() {
          isPressed = false;
          widget.onStateChange?.call(isPressed);
          widget.onRelease?.call();
          widget.onClick?.call();
        });
      },
      onPointerCancel: (PointerCancelEvent event) {
        if (!isPressed) {
          return;
        }

        setState(() {
          isPressed = false;
          widget.onStateChange?.call(isPressed);
        });
      },
      child: widget.child,
    );
  }
}
