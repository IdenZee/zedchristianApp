import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
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

    // Seed only once
    final meta = Hive.box(metaBox);
    if (!(meta.get('seeded') == false)) {
      await _seedFromAssets();
      await meta.put('seeded', true);
      await meta.put('lastSync', DateTime.now().toIso8601String());
    }
  }

  static Future<void> _seedFromAssets() async {
    final qb = Hive.box(quizzesBox);
    final vb = Hive.box(versesBox);
    final cb = Hive.box(crossBox);

    final quizzes = json.decode(await rootBundle.loadString('assets/seed/quizzes.json')) as List;
    for (final q in quizzes) {
      final id = q['id'];
      await qb.put(id, q);
    }

    final verses = json.decode(await rootBundle.loadString('assets/seed/verses.json')) as List;
    for (final v in verses) {
      await vb.put(v['id'], v);
    }

    final crosswords = json.decode(await rootBundle.loadString('assets/seed/crosswords.json')) as List;
    int i=0;
    for (final c in crosswords) {
      await cb.put((i++).toString(), c);
    }
    print(crosswords);
  }

  // Queries
  static List<QuizQuestion> getAllQuizzes() {
    final qb = Hive.box(quizzesBox);
    return qb.values.map((e) => QuizQuestion.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  static List<Verse> getAllVerses() {
    final vb = Hive.box(versesBox);
    return vb.values.map((e) => Verse.fromJson(Map<String, dynamic>.from(e))).toList();
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
