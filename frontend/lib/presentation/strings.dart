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
  static const photoTips = [
    'Pon la hoja sobre una superficie plana y bien iluminada.',
    'Encuadra toda la hoja y evita sombras o reflejos.',
    'Comprueba que el texto esté enfocado antes de continuar.',
  ];

  static String consent(int count) => count == 1
      ? 'Se enviará una copia de una imagen a la API para reconocer el texto.'
      : 'Se enviarán copias de $count imágenes a la API para reconocer el texto.';
}
