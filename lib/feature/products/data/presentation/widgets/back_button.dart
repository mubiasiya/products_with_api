import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget back_button(BuildContext context) {
  return IconButton(
    onPressed: () => Navigator.pop(context),
    icon: const Icon(
      Icons.arrow_back_ios_new_rounded,
      color: Colors.white,
      size: 18,
    ),
  );
}
