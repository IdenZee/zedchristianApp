import 'dart:async';
import 'package:flutter/material.dart';
import '../core/services/local_store.dart';
import '../models/verse.dart';

class VerseSlider extends StatefulWidget {
  final Duration interval;
  const VerseSlider({super.key, this.interval = const Duration(seconds: 30)});

  @override
  State<VerseSlider> createState() => _VerseSliderState();
}

class _VerseSliderState extends State<VerseSlider> {
  late List<Verse> verses;
  int idx = 0;
  Timer? t;

  @override
  void initState() {
    super.initState();
    verses = LocalStore.getAllVerses();
    if (verses.isEmpty) return;
    t = Timer.periodic(widget.interval, (_) {
      if (!mounted) return;
      setState(() => idx = (idx + 1) % verses.length);
    });
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (verses.isEmpty) return const SizedBox.shrink();
    final v = verses[idx];
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Container(
        key: ValueKey(v.id),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xFF60A5FA), Color(0xFF34D399)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '"${v.text}"',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(v.reference, style: const TextStyle(color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
