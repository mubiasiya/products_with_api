import 'package:flutter/material.dart';

Widget cart_row(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text('$label :', style: TextStyle(color: Colors.black, fontSize: 14)),

      const SizedBox(width: 5),
      Text(value, style: TextStyle(fontSize: 18, color: Colors.black)),
    ],
  );
}
