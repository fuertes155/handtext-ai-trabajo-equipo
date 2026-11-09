import 'package:flutter/material.dart';

import '../strings.dart';

Future<bool> showConsentDialog(
  BuildContext context, {
  required int count,
}) async {
  if (count < 1) return false;
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Reconocimiento de texto'),
          content: Text(AppStrings.consent(count)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(AppStrings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(AppStrings.accept),
            ),
          ],
        ),
      ) ??
      false;
}
