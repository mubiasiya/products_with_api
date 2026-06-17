import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

Widget back_button(BuildContext context) {
  return IconButton(
    onPressed: () =>context.pop(),
    icon: const Icon(
      Icons.arrow_back_ios_new_rounded,
      color: Colors.white,
      size: 18,
    ),
  );
}
