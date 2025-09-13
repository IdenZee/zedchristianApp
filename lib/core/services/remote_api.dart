import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoteApi {
  // Replace with your backend base URL
  static const base = 'https://example.com/api';

  static Future<List<Map<String, dynamic>>> fetchQuizzes() async {
    final r = await http.get(Uri.parse('$base/quizzes'));
    if (r.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(r.body));
    }
    throw Exception('Failed to fetch quizzes');
  }

  static Future<List<Map<String, dynamic>>> fetchVerses() async {
    final r = await http.get(Uri.parse('$base/verses'));
    if (r.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(r.body));
    }
    throw Exception('Failed to fetch verses');
  }

  static Future<List<Map<String, dynamic>>> fetchCrosswords() async {
    final r = await http.get(Uri.parse('$base/crosswords'));
    if (r.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(r.body));
    }
    throw Exception('Failed to fetch crosswords');
  }
}
