class Env {
  const Env._();

  static const libreTranslateUrl =
      String.fromEnvironment('LIBRETRANSLATE_URL', defaultValue: '');

  static bool get hasLibreTranslateUrl => libreTranslateUrl.isNotEmpty;
}
