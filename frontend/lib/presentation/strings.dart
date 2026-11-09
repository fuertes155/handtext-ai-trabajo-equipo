import '../models/app_failure.dart';
import '../models/operation_status.dart';

abstract final class AppStrings {
  static const title = 'HandText AI';
  static const welcome = 'Digitaliza tus documentos manuscritos';
  static const aboutLink = 'Privacidad y acerca de';
  static const about = 'Acerca de';
  static const privacy = 'Privacidad';
  static const tips = 'Consejos para una buena foto';
  static const next = 'Siguiente';
  static const start = 'Empezar';
  static const skip = 'Saltar';
  static const cancel = 'Cancelar';
  static const accept = 'Autorizar';
  static const tooManyPages = 'El documento contiene demasiadas páginas.';

  static String? recognitionStatus(OperationStatus status) {
    if (status.failure?.kind == FailureKind.tooManyPages) return tooManyPages;
    if (status.event == StatusEvent.recognizing) {
      final page = status.page;
      final count = status.pageCount;
      return page == null || count == null
          ? 'Reconociendo texto…'
          : 'Reconociendo la página $page de $count…';
    }
    if (status.event == StatusEvent.recognized &&
        status.emptyPages.isNotEmpty) {
      final pages = status.emptyPages.join(', ');
      return 'No se encontró texto en las páginas $pages.';
    }
    return null;
  }

  static const photoTips = [
    'Pon la hoja sobre una superficie plana y bien iluminada.',
    'Encuadra toda la hoja y evita sombras o reflejos.',
    'Comprueba que el texto esté enfocado antes de continuar.',
  ];

  static String consent(int count) => count == 1
      ? 'Se enviará una copia de una imagen a la API para reconocer el texto.'
      : 'Se enviarán copias de $count imágenes a la API para reconocer el texto.';
}
