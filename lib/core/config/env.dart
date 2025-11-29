class Env {
  const Env._();

  static const translateApiKey =
      String.fromEnvironment('TRANSLATE_API_KEY', defaultValue: '');

  static bool get hasTranslateApiKey => translateApiKey.isNotEmpty;
}
