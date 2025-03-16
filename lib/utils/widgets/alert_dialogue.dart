import 'package:flutter/material.dart';

void showAlertDialogue(
    {required BuildContext context,
    required String title,
    required String message}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Center(
        child: Text(
          title,
        ),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        FilledButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: const Text(
            'Close',
          ),
        ),
      ],
    ),
  );
}