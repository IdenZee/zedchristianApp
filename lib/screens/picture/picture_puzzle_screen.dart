import 'dart:math';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class PicturePuzzleScreen extends StatefulWidget {
  const PicturePuzzleScreen({super.key});

  @override
  State<PicturePuzzleScreen> createState() => _PicturePuzzleScreenState();
}

class _PicturePuzzleScreenState extends State<PicturePuzzleScreen> {
  // simple emoji tiles slide puzzle 3x3
  List<String> tiles = ['🕊️','⛪','📖','✝️','🫶','🕯️','🎵','🌟',' '];

  @override
  void initState() {
    super.initState();
    tiles.shuffle(Random());
  }

  void swap(int i){
    final empty = tiles.indexOf(' ');
    final rowI = i ~/ 3, colI = i % 3;
    final rowE = empty ~/ 3, colE = empty % 3;
    if ((rowI == rowE && (colI-colE).abs()==1) || (colI==colE && (rowI-rowE).abs()==1)){
      setState((){
        final tmp = tiles[i];
        tiles[i] = ' ';
        tiles[empty] = tmp;
      });
    }
  }

  // bool solved() => List.from(tiles)..remove(' ') == ['🕊️','⛪','📖','✝️','🫶','🕯️','🎵','🌟'];
  final listEquals = const ListEquality().equals;
  bool solved() {
    final withoutSpace = List<String>.from(tiles)..remove(' ');
    return listEquals(withoutSpace, ['🕊️','⛪','📖','✝️','🫶','🕯️','🎵','🌟']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picture Puzzle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemCount: 9,
                itemBuilder: (_, i){
                  final isEmpty = tiles[i] == ' ';
                  return GestureDetector(
                    onTap: ()=> swap(i),
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isEmpty ? Colors.transparent : Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Center(child: Text(tiles[i], style: const TextStyle(fontSize: 40))),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(solved() ? 'Solved! 🎉' : 'Tap tiles to slide'),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: ()=> setState(()=> tiles.shuffle()), child: const Text('Shuffle')),
          ],
        ),
      ),
    );
  }
}
