import 'package:flutter/material.dart';

import '../../models/export_format.dart';

Future<ExportFormat?> showExportFormatSheet(BuildContext context) {
  return showModalBottomSheet<ExportFormat>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final format in ExportFormat.values)
            ListTile(
              title: Text('${format.label} (.${format.extension})'),
              onTap: () => Navigator.of(context).pop(format),
            ),
        ],
      ),
    ),
  );
}
