import 'package:flutter/material.dart';
import '../../core/services/local_store.dart';
import '../../models/crossword.dart';

class CrosswordScreen extends StatefulWidget {
  const CrosswordScreen({super.key});

  @override
  State<CrosswordScreen> createState() => _CrosswordScreenState();
}

bool _revealed = false;
class _CrosswordScreenState extends State<CrosswordScreen> {
  late Map<String, List<CrosswordEntry>> sets;
  String? selectedSet;

  late List<List<String?>> solutionGrid;
  late List<List<TextEditingController?>> inputGrid;
  late List<List<FocusNode?>> focusGrid;

  final Map<String, int> _startNumbers = {};
  List<_Clue> _acrossClues = [];
  List<_Clue> _downClues = [];

  int rows = 12, cols = 12;
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    sets = LocalStore.getCrosswordsBySet();
    if (sets.isNotEmpty) selectedSet = sets.keys.first;
    _buildGrid();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    try {
      for (final row in inputGrid) {
        for (final ctrl in row) {
          ctrl?.dispose();
        }
      }
      for (final row in focusGrid) {
        for (final f in row) {
          f?.dispose();
        }
      }
    } catch (_) {}
  }

  void _buildGrid() {
    _checked = false;
    _disposeControllers();

    solutionGrid = List.generate(rows, (_) => List.generate(cols, (_) => null));
    inputGrid = List.generate(rows, (_) => List.generate(cols, (_) => null));
    focusGrid = List.generate(rows, (_) => List.generate(cols, (_) => null));

    _startNumbers.clear();
    _acrossClues = [];
    _downClues = [];

    final entries = sets[selectedSet] ?? [];

    for (final e in entries) {
      final word = e.answer.replaceAll(' ', '');
      for (int i = 0; i < word.length; i++) {
        final r = e.rowStart + (e.orientation == 'down' ? i : 0);
        final c = e.colStart + (e.orientation == 'across' ? i : 0);
        if (r < 0 || c < 0 || r >= rows || c >= cols) continue;

        final ch = word[i];
        final existing = solutionGrid[r][c];
        if (existing == null || existing == ch) {
          solutionGrid[r][c] = ch;
          inputGrid[r][c] ??= TextEditingController();
          focusGrid[r][c] ??= FocusNode();
        }
      }
    }

    int counter = 1;
    for (final e in entries) {
      final key = "${e.rowStart},${e.colStart}";
      if (!_startNumbers.containsKey(key)) {
        _startNumbers[key] = counter++;
      }
    }

    for (final e in entries) {
      final num = _startNumbers["${e.rowStart},${e.colStart}"]!;
      final clue = _Clue(
        number: num,
        clue: e.clue,
        row: e.rowStart,
        col: e.colStart,
        orientation: e.orientation,
      );
      if (e.orientation == 'across') {
        _acrossClues.add(clue);
      } else {
        _downClues.add(clue);
      }
    }
    _acrossClues.sort((a, b) => a.number.compareTo(b.number));
    _downClues.sort((a, b) => a.number.compareTo(b.number));
    setState(() {});
  }

  void _checkPuzzle() {
    setState(() => _checked = true);
  }

  void _toggleRevealPuzzle() {

    setState(() {
      if (_revealed) {
        // Hide answers → clear user inputs
        for (int r = 0; r < rows; r++) {
          for (int c = 0; c < cols; c++) {
            final sol = solutionGrid[r][c];
            final ctrl = inputGrid[r][c];
            if (sol != null && ctrl != null) {
              ctrl.clear(); // clear input when hiding
            }
          }
        }
        _revealed = false;
      } else {
        // Reveal answers
        for (int r = 0; r < rows; r++) {
          for (int c = 0; c < cols; c++) {
            final sol = solutionGrid[r][c];
            final ctrl = inputGrid[r][c];
            if (sol != null && ctrl != null) {
              ctrl.text = sol;
            }
          }
        }
        _revealed = true;
      }
      _checked = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final hasSets = sets.isNotEmpty;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Crosswords')),
      body: SafeArea(
        child: Column(
          children: [
            // top controls
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Set:'),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedSet,
                  items: sets.keys
                      .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      selectedSet = v;
                      _buildGrid();
                    });
                  },
                ),
                const Spacer(),

                ElevatedButton(onPressed: _checkPuzzle, child: const Text('Check')),
                const SizedBox(width: 8),

                ElevatedButton(
                  onPressed: _toggleRevealPuzzle,
                  child: Text(_revealed ? 'Hide' : 'Reveal'),
                ),

              ],
            ),
            const SizedBox(height: 12),

            // the grid → stays square, does not shrink
            Expanded(
              flex: 2,
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                  ),
                  itemCount: rows * cols,
                  itemBuilder: (_, i) {
                    final r = i ~/ cols;
                    final c = i % cols;
                    final sol = solutionGrid[r][c];
                    final ctrl = inputGrid[r][c];
                    final focus = focusGrid[r][c];

                    if (sol == null) {
                      // Blocked cell
                      return Container(
                        margin: const EdgeInsets.all(1.5),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white12),
                        ),
                      );
                    }

                    final num = _startNumbers['$r,$c'];
                    final isWrong = _checked &&
                        (ctrl?.text.isNotEmpty ?? false) &&
                        ctrl!.text.toUpperCase() != sol;

                    return Container(
                      margin: const EdgeInsets.all(1.5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isWrong ? Colors.red : Colors.black12,
                          width: isWrong ? 2 : 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          if (num != null)
                            Positioned(
                              top: 2,
                              left: 2,
                              child: Text(
                                '$num',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          Center(
                            child: TextField(
                              controller: ctrl,
                              focusNode: focus,
                              maxLength: 1, // restrict to single character
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: isWrong ? Colors.red : Colors.black,
                              ),
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                isCollapsed: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (v) {
                                final up = v.isEmpty ? '' : v[0].toUpperCase();
                                ctrl!.text = up;
                                ctrl.selection = TextSelection.fromPosition(
                                  TextPosition(offset: ctrl.text.length),
                                );

                                if (up.isNotEmpty) {
                                  // Default move right
                                  int nr = r, nc = c + 1;
                                  // If this cell starts a down word, prefer moving down
                                  if (_downClues.any((cl) => cl.row == r && cl.col == c)) {
                                    nr = r + 1;
                                    nc = c;
                                  }
                                  if (nr < rows && nc < cols && focusGrid[nr][nc] != null) {
                                    FocusScope.of(context).requestFocus(focusGrid[nr][nc]);
                                  } else {
                                    FocusScope.of(context).unfocus();
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            // clues list → scrolls independently
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        const Text('Across', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        ..._acrossClues.map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('${c.number}. ${c.clue}'),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ListView(
                      children: [
                        const Text('Down', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        ..._downClues.map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('${c.number}. ${c.clue}'),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Clue {
  final int number;
  final String clue;
  final int row;
  final int col;
  final String orientation;
  _Clue({
    required this.number,
    required this.clue,
    required this.row,
    required this.col,
    required this.orientation,
  });
}
