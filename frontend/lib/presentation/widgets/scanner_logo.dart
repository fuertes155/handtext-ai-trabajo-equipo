// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
// Logo animado «hoja que se escanea» (tareas T111 y T142; spec 002, módulo 5).
//
// Se dibuja con CustomPainter (sin imágenes), con la forma de un ícono de app:
// 1. Un cuadrado redondeado azul corporativo con sombra.
// 2. Una hoja blanca con renglones «manuscritos» grises (el primero, más oscuro, es el
//    título).
// 3. Las cuatro esquinas del marco del escáner, en blanco.
// 4. Una línea de escaneo celeste que sube y baja despacio, con una estela suave.
// Es decorativo: se excluye de los lectores de pantalla. Si se pidieron menos
// animaciones, la línea queda quieta [SC-207].

import 'package:flutter/material.dart';

import '../../theme/aurora.dart';
import 'motion.dart';

/// Logo animado de la app: una hoja que se escanea.
class ScannerLogo extends StatefulWidget {
  const ScannerLogo({super.key, this.size = 128});

  /// Lado del logo, en píxeles lógicos (dp).
  final double size;

  @override
  State<ScannerLogo> createState() {
    throw UnimplementedError("T142 pendiente de LUISDACA");
  }
}

class _ScannerLogoState extends State<ScannerLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  );

  @override
  void didChangeDependencies() {
    throw UnimplementedError("T142 pendiente de LUISDACA");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T142 pendiente de LUISDACA");
  }
}

class _ScannerPainter extends CustomPainter {
  _ScannerPainter({required this.progress});

  /// Posición de la línea de escaneo: 0 arriba, 1 abajo.
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    throw UnimplementedError("T142 pendiente de LUISDACA");
  }

  @override
  bool shouldRepaint(_ScannerPainter oldDelegate) {
    throw UnimplementedError("T142 pendiente de LUISDACA");
  }
}
