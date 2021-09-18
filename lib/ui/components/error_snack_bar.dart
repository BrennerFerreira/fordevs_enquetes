import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, {required String text}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(context).errorColor,
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
