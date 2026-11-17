// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
// Animación de escaneo sobre la imagen mientras la IA lee (tareas T134 y T142; CU-H3-E2).
//
// Oscurece levemente la imagen y la recorre con una línea celeste y su estela suave.
// Si se pidieron menos animaciones, la línea queda quieta [SC-207].

import 'package:flutter/material.dart';

import '../../theme/aurora.dart';
import 'motion.dart';

/// Línea de escaneo que recorre la imagen mientras se reconoce el texto.
class ScanOverlay extends StatefulWidget {
  const ScanOverlay({super.key});

  @override
  State<ScanOverlay> createState() {
    throw UnimplementedError("T134,T142 pendiente de LUISDACA");
  }
}

class _ScanOverlayState extends State<ScanOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void didChangeDependencies() {
    throw UnimplementedError("T134,T142 pendiente de LUISDACA");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T134,T142 pendiente de LUISDACA");
  }
}

class _ScanPainter extends CustomPainter {
  _ScanPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    throw UnimplementedError("T134,T142 pendiente de LUISDACA");
  }

  @override
  bool shouldRepaint(_ScanPainter oldDelegate) {
    throw UnimplementedError("T134,T142 pendiente de LUISDACA");
  }
}
