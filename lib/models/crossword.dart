class CrosswordEntry {
  final String clue;
  final String answer;
  final String orientation; // 'across' or 'down'
  final int rowStart;
  final int colStart;
  final String set;

  CrosswordEntry({
    required this.clue,
    required this.answer,
    required this.orientation,
    required this.rowStart,
    required this.colStart,
    required this.set,
  });

  factory CrosswordEntry.fromJson(Map<String, dynamic> j) => CrosswordEntry(
    clue: j['clue'] ?? '',
    answer: (j['answer'] ?? '').toString().trim().toUpperCase(),
    orientation: (j['orientation'] ?? 'across').toLowerCase(),
    rowStart: j['row_start'] ?? j['rowStart'] ?? 0,
    colStart: j['col_start'] ?? j['colStart'] ?? 0,
    set: j['puzzle_set'] ?? j['set'] ?? 'Default',
  );

  Map<String, dynamic> toJson() => {
    'clue': clue,
    'answer': answer,
    'orientation': orientation,
    'row_start': rowStart,
    'col_start': colStart,
    'puzzle_set': set,
  };
}
