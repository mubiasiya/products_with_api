import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget iconButton(IconData icon, void Function() onPressed) {
  return IconButton(
    onPressed: () {
      onPressed();
    },
    icon: Icon(icon, color: Colors.white),
  );
}
