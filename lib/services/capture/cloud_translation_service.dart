import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/env.dart';

class CloudTranslationService {
  CloudTranslationService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  bool get isEnabled => Env.hasTranslateApiKey;

  Future<List<String>> translate(
    List<String> texts, {
    required String targetLanguage,
    String? sourceLanguage,
  }) async {
    if (!isEnabled || texts.isEmpty) return texts;

    final uri = Uri.https(
      'translation.googleapis.com',
      '/language/translate/v2',
      {'key': Env.translateApiKey},
    );

    final payload = {
      'q': texts,
      if (sourceLanguage != null) 'source': sourceLanguage,
      'target': targetLanguage,
      'format': 'text',
    };

    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Cloud translation failed (${response.statusCode}): ${response.body}',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    final translations = data['translations'] as List<dynamic>;
    return translations
        .map((e) => (e as Map<String, dynamic>)['translatedText'] as String)
        .toList();
  }

  Future<void> close() async {
    _client.close();
  }
}
