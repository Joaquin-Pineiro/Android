import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html_unescape/html_unescape.dart';

class TranslationService {
  final String apiKey = 'AIzaSyAyjXSkb1BuSS-9WlOZWQDdBoNNCmfa4lA';
  final String baseUrl =
      'https://translation.googleapis.com/language/translate/v2';
  final unescape = HtmlUnescape();

  Future<List<String>> translateBatch(
      List<String> texts, String targetLanguage) async {
    log(targetLanguage);

    final response = await http.post(
      Uri.parse('$baseUrl?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'q': texts,
        'target': targetLanguage,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return List<String>.from(jsonResponse['data']['translations'].map(
          (translation) => unescape.convert(translation['translatedText'])));
    } else {
      throw Exception('Failed to translate text: ${response.body}');
    }
  }
}
