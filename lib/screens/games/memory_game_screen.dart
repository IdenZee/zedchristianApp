import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  final emojis = ['🕊️','✝️','📖','⛪','🕯️','🎵'];
  late List<_CardModel> cards;
  _CardModel? first;
  bool lock = false;
  int matches = 0;

  @override
  void initState() {
    super.initState();
    final list = [...emojis, ...emojis]..shuffle(Random());
    cards = List.generate(list.length, (i)=> _CardModel(id:i, emoji:list[i]));
  }

  void tap(_CardModel c) async {
    if (lock || c.revealed) return;
    setState(()=> c.revealed = true);
    if (first == null) { first = c; return; }
    lock = true;
    if (first!.emoji == c.emoji) {
      matches += 1;
      first = null; lock = false;
      setState((){});
    } else {
      await Future.delayed(const Duration(milliseconds: 700));
      setState((){ c.revealed = false; first!.revealed = false; first = null; lock = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final done = matches == emojis.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Memory Game')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemCount: cards.length,
                itemBuilder: (_, i){
                  final c = cards[i];
                  return GestureDetector(
                    onTap: ()=> tap(c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: c.revealed ? Colors.white10 : Colors.black26,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Center(child: Text(c.revealed ? c.emoji : '❓', style: const TextStyle(fontSize: 36))),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(done ? 'All matched! 🎉' : 'Find all pairs'),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: (){
              setState((){
                final list = [...emojis, ...emojis]..shuffle(Random());
                cards = List.generate(list.length, (i)=> _CardModel(id:i, emoji:list[i]));
                first = null; lock = false; matches = 0;
              });
            }, child: const Text('Restart'))
          ],
        ),
      ),
    );
  }
}

class _CardModel {
  final int id;
  final String emoji;
  bool revealed = false;
  _CardModel({required this.id, required this.emoji});
}
