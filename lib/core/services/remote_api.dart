import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoteApi {
  // For Android emulator use 10.0.2.2 instead of localhost
  // For iOS simulator you can keep localhost
  // For a real phone on Wi-Fi use your PC’s LAN IP (e.g. 192.168.0.xxx)

  static const base = 'http://10.0.2.2:8087/zedchristian/api';

  static Future<List<Map<String, dynamic>>> fetchQuizzes() async {
    final r = await http.get(Uri.parse('$base/quizzes.php'));
    if (r.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(r.body));
    }
    throw Exception('Failed to fetch quizzes');
  }

  static Future<List<Map<String, dynamic>>> fetchVerses() async {
    final r = await http.get(Uri.parse('$base/verses.php'));
    if (r.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(r.body));
    }
    throw Exception('Failed to fetch verses');
  }

  static Future<List<Map<String, dynamic>>> fetchCrosswords() async {
    final r = await http.get(Uri.parse('$base/crosswords.php'));
    if (r.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(r.body));
    }
    throw Exception('Failed to fetch crosswords');
  }
}
