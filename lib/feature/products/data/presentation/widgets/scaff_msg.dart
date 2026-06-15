import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> scaff_msg(
  String msg,
  BuildContext context,
) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ),
  );
}
