import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/quiz.dart';
import '../../models/verse.dart';
import '../../models/crossword.dart';

class LocalStore {
  static const quizzesBox = 'quizzes';
  static const versesBox = 'verses';
  static const crossBox = 'crosswords';
  static const metaBox = 'meta';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(metaBox);
    await Hive.openBox(quizzesBox);
    await Hive.openBox(versesBox);
    await Hive.openBox(crossBox);
  }

  // --- SYNC FUNCTIONS ---

  static Future<void> syncCrosswords() async {
    final url = Uri.parse("http://10.0.2.2/zedchristian/api/crosswords.php");
    await _syncBox(url, crossBox);
  }

  static Future<void> syncQuizzes() async {
    final url = Uri.parse("http://10.0.2.2/zedchristian/api/quizzes.php");
    await _syncBox(url, quizzesBox);
  }

  static Future<void> syncVerses() async {
    final url = Uri.parse("http://10.0.2.2/zedchristian/api/verses.php");
    await _syncBox(url, versesBox);
  }

  static Future<void> _syncBox(Uri url, String boxName) async {
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        final box = Hive.box(boxName);
        await box.clear();
        for (int i = 0; i < data.length; i++) {
          await box.put(i.toString(), data[i]);
        }
        print("Synced $boxName: ${data.length}");
      } else {
        print("Failed to sync $boxName: ${res.statusCode}");
      }
    } catch (e) {
      print("Error syncing $boxName: $e");
    }
  }

  // --- QUERIES ---

  static List<QuizQuestion> getAllQuizzes() {
    final qb = Hive.box(quizzesBox);

    return qb.values
        .map((e) => QuizQuestion.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }


  static List<Verse> getAllVerses() {
    final vb = Hive.box(versesBox);
    return vb.values
        .map((e) => Verse.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Map<String, List<CrosswordEntry>> getCrosswordsBySet() {
    final cb = Hive.box(crossBox);
    final out = <String, List<CrosswordEntry>>{};
    for (final raw in cb.values) {
      final e = CrosswordEntry.fromJson(Map<String, dynamic>.from(raw));
      out.putIfAbsent(e.set, () => []).add(e);
    }
    return out;
  }
}
