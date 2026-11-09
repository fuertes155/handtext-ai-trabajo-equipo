import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/models/export_format.dart';
import 'package:handtext_ai/presentation/widgets/export_format_sheet.dart';
import 'package:handtext_ai/presentation/strings.dart';

void main() {
  for (final format in ExportFormat.values) {
    testWidgets('devuelve ${format.name} al seleccionar su formato', (
      tester,
    ) async {
      ExportFormat? selected;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('es'),
          supportedLocales: AppStrings.supportedLocales,
          localizationsDelegates: [
            AppStrings.delegate(usesLocalAccounts: true),
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  selected = await showExportFormatSheet(context);
                },
                child: const Text('Exportar'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Exportar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('${format.label} (.${format.extension})'));
      await tester.pumpAndSettle();
      expect(selected, format);
    });
  }
}
