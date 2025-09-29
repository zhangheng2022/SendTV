import 'package:flutter/material.dart';
import 'package:send_tv/pages_tv/components/list_tile.dart';

class DrawerRight extends StatefulWidget {
  const DrawerRight({super.key});

  @override
  State<DrawerRight> createState() => _DrawerRightState();
}

class _DrawerRightState extends State<DrawerRight> {
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
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        children: <Widget>[
          SizedBox(
            height: 50,
            child: Text(
              '设置',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TVListTile(
            autofocus: true,
            leading: const Icon(Icons.wifi),
            title: const Text('启用广播'),
            trailing: Switch(value: true, onChanged: (v) {}),
          ),
          TVListTile(
            leading: const Icon(Icons.info),
            title: const Text('关于 SendTV'),
          ),
        ],
      ),
    );
  }
}
