import 'package:flutter/material.dart';

import '../strings.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(AppStrings.privacy)),
    body: SafeArea(
      child: ListView(
        padding: EdgeInsets.all(24),
        children: const [
          Text(
            'Las cuentas y sesiones de la app se guardan en el dispositivo.',
          ),
          SizedBox(height: 16),
          Text(
            'Con tu autorización, el reconocimiento envía copias de las imágenes a la API configurada. Si se habilita Cloud Vision, la API envía la copia al proveedor de reconocimiento.',
          ),
          SizedBox(height: 16),
          Text(
            'Revisa el texto antes de exportar. Elige dónde guardar o con qué aplicación compartir el resultado.',
          ),
        ],
      ),
    ),
  );
}
