import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'local_store.dart';
import 'remote_api.dart';

class SyncService {
  static Future<bool> canSync() async {
    final c = await Connectivity().checkConnectivity();
    return c.contains(ConnectivityResult.mobile) || c.contains(ConnectivityResult.wifi);
  }

  static Future<void> syncAll() async {
    if (!await canSync()) return;
    final meta = Hive.box(LocalStore.metaBox);

    try {
      final quizzes = await RemoteApi.fetchQuizzes();
      final qb = Hive.box(LocalStore.quizzesBox);
      for (final q in quizzes) { await qb.put(q['id'], q); }

      final verses = await RemoteApi.fetchVerses();
      final vb = Hive.box(LocalStore.versesBox);
      for (final v in verses) { await vb.put(v['id'], v); }

      final cross = await RemoteApi.fetchCrosswords();
      final cb = Hive.box(LocalStore.crossBox);
      await cb.clear();
      int i=0; for (final c in cross) { await cb.put((i++).toString(), c); }

      await meta.put('lastSync', DateTime.now().toIso8601String());
    } catch (e) {
      // log error or ignore
    }
  }
}
