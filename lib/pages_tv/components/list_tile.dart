import 'package:flutter/material.dart';

class TVListTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool autofocus;

  const TVListTile({
    super.key,
    required this.leading,
    required this.title,
    this.trailing,
    this.onTap,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: autofocus,
      child: Builder(
        builder: (context) {
          final focused = Focus.of(context).hasFocus;
          return ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                width: 2,
                color:
                    focused
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
              ),
            ),
            leading: leading,
            title: title,
            trailing: trailing,
            onTap: onTap,
          );
        },
      ),
    );
  }
}
