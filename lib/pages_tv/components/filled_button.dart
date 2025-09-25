import 'package:flutter/material.dart';

class TVFilledButton extends StatefulWidget {
  const TVFilledButton({
    super.key,
    this.onPressed,
    this.onFocusChange,
    this.child,
    this.icon,
    this.autofocus = false,
    this.focusNode,
  });

  factory TVFilledButton.icon({
    Key? key,
    VoidCallback? onPressed,
    ValueChanged<bool>? onFocusChange,
    Widget? icon,
    required Widget label,
  }) {
    return TVFilledButton(
      key: key,
      onPressed: onPressed,
      onFocusChange: onFocusChange,
      icon: icon,
      child: label,
    );
  }

  final VoidCallback? onPressed;
  final ValueChanged<bool>? onFocusChange;
  final Widget? child;
  final Widget? icon;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  State<TVFilledButton> createState() => _TVFilledButtonState();
}

class _TVFilledButtonState extends State<TVFilledButton> {
  bool _focused = false;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focused != _focusNode.hasFocus) {
        setState(() {
          _focused = _focusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.icon != null
        ? FilledButton.icon(
            autofocus: widget.autofocus,
            style: FilledButton.styleFrom(
              backgroundColor: _focused
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainer,
              visualDensity: VisualDensity.compact,
            ),
            onPressed: widget.onPressed ?? () {},
            onFocusChange: widget.onFocusChange,
            focusNode: _focusNode,
            label: widget.child ?? const SizedBox.shrink(),
            icon: widget.icon!,
          )
        : FilledButton(
            autofocus: widget.autofocus,
            style: FilledButton.styleFrom(
              backgroundColor: _focused
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainer,
              visualDensity: VisualDensity.compact,
            ),
            onPressed: widget.onPressed ?? () {},
            onFocusChange: widget.onFocusChange,
            focusNode: _focusNode,
            child: widget.child,
          );
  }
}
