import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/env.dart';

class CloudTranslationService {
  CloudTranslationService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  bool get isEnabled => true;

  Future<List<String>> translate(
    List<String> texts, {
    required String targetLanguage,
    String? sourceLanguage,
  }) async {
    if (texts.isEmpty) return texts;

    final uri = Uri.https('api.mymemory.translated.net', '/get', {
      'langpair':
          '${_normalizeLanguage(sourceLanguage) ?? 'auto'}|${_normalizeLanguage(targetLanguage) ?? 'en'}',
      'de': 'public@email.test',
      'q': texts.first,
    });

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception(
        'MyMemory translation failed (${response.statusCode}): ${response.body}',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final translated = (body['responseData']
        as Map<String, dynamic>)['translatedText'] as String;
    return [translated];
  }

  Future<void> close() async {
    _client.close();
  }

  static const _languageMap = {
    'en': 'en',
    'ru': 'ru',
    'de': 'de',
    'fr': 'fr',
    'es': 'es',
    'pt': 'pt',
    'it': 'it',
    'tr': 'tr',
    'uk': 'uk',
    'kk': 'kk',
    'hy': 'hy',
    'ja': 'ja',
    'zh': 'zh',
  };

  String? _normalizeLanguage(String? input) {
    if (input == null) return null;
    final code = input.toLowerCase();
    return _languageMap[code] ?? code;
  }
}
