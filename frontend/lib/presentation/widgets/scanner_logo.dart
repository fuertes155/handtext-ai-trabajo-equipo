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
    return _ScannerLogoState();
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
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            painter: _ScannerPainter(progress: _controller.value),
          ),
        ),
      ),
    );
  }
}

class _ScannerPainter extends CustomPainter {
  _ScannerPainter({required this.progress});

  /// Posición de la línea de escaneo: 0 arriba, 1 abajo.
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 128, size.height / 128);
    final background = RRect.fromRectAndRadius(
      const Rect.fromLTWH(2, 2, 124, 124),
      const Radius.circular(26),
    );
    canvas.drawRRect(background, Paint()..color = Aurora.blue);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(35, 24, 58, 80),
        const Radius.circular(5),
      ),
      Paint()..color = Colors.white,
    );
    final ink = Paint()
      ..color = Aurora.lightOutline
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(45, 43.0 + i * 10),
        Offset(i.isEven ? 82 : 75, 43.0 + i * 10),
        ink,
      );
    }
    final frame = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (final corner in [
      const Offset(25, 19),
      const Offset(103, 19),
      const Offset(25, 109),
      const Offset(103, 109),
    ]) {
      final dx = corner.dx < 64 ? 10.0 : -10.0;
      final dy = corner.dy < 64 ? 10.0 : -10.0;
      canvas.drawPath(
        Path()
          ..moveTo(corner.dx + dx, corner.dy)
          ..lineTo(corner.dx, corner.dy)
          ..lineTo(corner.dx, corner.dy + dy),
        frame,
      );
    }
    final y = 30 + progress * 67;
    canvas.drawLine(
      Offset(28, y),
      Offset(100, y),
      Paint()
        ..color = Aurora.sky
        ..strokeWidth = 3,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ScannerPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
