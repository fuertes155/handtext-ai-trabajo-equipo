// Pantalla de bloqueo (tarea T1005; spec 011, Historia 2; research.md de 011, R4).
//
// AppLockGate envuelve toda la app (encima del Navigator, así también tapa Ajustes, Mis
// documentos y los diálogos). Mientras está bloqueada:
// - la app queda oculta pero viva (Offstage): al desbloquear, todo sigue donde estaba
//   [BL-H2-E2] [SC-1103];
// - se ve LockScreen, que pide la verificación sola una vez y luego con «Desbloquear»
//   [BL-H2-E3].

import 'package:flutter/material.dart';

import '../../state/app_lock_controller.dart';
import '../../theme/aurora.dart';
import '../strings.dart';
import '../widgets/aurora_scaffold.dart';
import '../widgets/brand_title.dart';
import '../widgets/primary_button.dart';
import '../widgets/scanner_logo.dart';

/// Envuelve toda la app: si está bloqueada, la oculta y pone [LockScreen] encima.
///
/// Va en `MaterialApp.builder` (app.dart), por encima de todas las pantallas y
/// diálogos (research.md de 011, R4). [lock] dice si está bloqueada.
class AppLockGate extends StatelessWidget {
  const AppLockGate({super.key, required this.lock, required this.child});

  final AppLockController lock;

  /// La app completa, tal como la arma MaterialApp.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: lock,
      builder: (context, _) {
        final locked = lock.isLocked;
        return Stack(
          fit: StackFit.expand,
          children: [
            Offstage(
              offstage: locked,
              child: ExcludeFocus(
                excluding: locked,
                child: ExcludeSemantics(
                  excluding: locked,
                  child: TickerMode(enabled: !locked, child: child),
                ),
              ),
            ),
            if (locked) LockScreen(lock: lock),
          ],
        );
      },
    );
  }
}

/// Pantalla de bloqueo: logo y «Desbloquear». Al aparecer pide la verificación una
/// vez sola; si se cancela, el botón la vuelve a pedir.
class LockScreen extends StatefulWidget {
  const LockScreen({super.key, required this.lock});

  final AppLockController lock;

  @override
  State<LockScreen> createState() {
    return _LockScreenState();
  }
}

class _LockScreenState extends State<LockScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _unlock();
    });
  }

  Future<void> _unlock() async {
    await widget.lock.unlock(context.strings.unlockReason);
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return AuroraScaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: (constraints.maxHeight - 48).clamp(
                  0,
                  double.infinity,
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(child: ScannerLogo(size: 100)),
                      const SizedBox(height: 24),
                      const BrandTitle(),
                      const SizedBox(height: 24),
                      Semantics(
                        header: true,
                        child: Text(
                          strings.lockedTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        strings.lockedMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Aurora.textSecondary),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: strings.unlock,
                        onPressed: _unlock,
                        icon: Icons.lock_open,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
