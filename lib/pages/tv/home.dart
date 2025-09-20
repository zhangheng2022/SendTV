import 'package:flutter/material.dart';

class TVHomePage extends StatelessWidget {
  const TVHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        // 让一组按钮支持方向键遍历
        child: FocusTraversalGroup(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              TVFocusableButton(title: "播放"),
              SizedBox(width: 20),
              TVFocusableButton(title: "暂停"),
              SizedBox(width: 20),
              TVFocusableButton(title: "停止"),
            ],
          ),
        ),
      ),
    );
  }
}

class TVFocusableButton extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;

  const TVFocusableButton({super.key, required this.title, this.onTap});

  @override
  State<TVFocusableButton> createState() => _TVFocusableButtonState();
}

class _TVFocusableButtonState extends State<TVFocusableButton> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: false,
      onFocusChange: (_) => setState(() {}),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: _focusNode.hasFocus ? Colors.blue : Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _focusNode.hasFocus ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            widget.title,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
