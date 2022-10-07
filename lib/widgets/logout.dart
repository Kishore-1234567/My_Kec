import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../tabs.dart';

class Logout extends StatelessWidget {
  const Logout({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final TabScreen widget;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          final pref = await SharedPreferences.getInstance();
          pref.clear();
          widget.func();
        },
        icon: const Icon(Icons.logout));
  }
}