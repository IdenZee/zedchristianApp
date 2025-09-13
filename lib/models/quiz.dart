class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int answerIndex; // derived from correct_option

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.answerIndex,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    // Map correct_option (A/B/C/D) to index
    final correct = (json['correct_option'] ?? '').toString().toUpperCase();
    final indexMap = {'A': 0, 'B': 1, 'C': 2, 'D': 3};
    final ansIndex = indexMap[correct] ?? 0;

    return QuizQuestion(
      id: json['id'].toString(),
      question: json['question'] ?? '',
      options: [
        json['option_a'] ?? '',
        json['option_b'] ?? '',
        json['option_c'] ?? '',
        json['option_d'] ?? '',
      ],
      answerIndex: ansIndex,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'option_a': options[0],
    'option_b': options[1],
    'option_c': options[2],
    'option_d': options[3],
    'correct_option': ['A', 'B', 'C', 'D'][answerIndex],
  };
}
