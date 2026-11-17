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
    return _ScanOverlayState();
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
    super.didChangeDependencies();
    syncLoopingAnimation(context, _controller, reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            painter: _ScanPainter(progress: _controller.value),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class _ScanPainter extends CustomPainter {
  _ScanPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = Colors.black.withValues(alpha: 0.15),
    );
    final y = size.height * progress;
    final trail = Rect.fromLTRB(
      0,
      (y - 40).clamp(0, size.height),
      size.width,
      y,
    );
    if (trail.height > 0) {
      canvas.drawRect(
        trail,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Aurora.sky.withValues(alpha: 0),
              Aurora.sky.withValues(alpha: 0.22),
            ],
          ).createShader(trail),
      );
    }
    canvas.drawLine(
      Offset(0, y),
      Offset(size.width, y),
      Paint()
        ..color = Aurora.sky
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(_ScanPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
