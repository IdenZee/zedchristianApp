class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int answerIndex;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.answerIndex,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final correct = (json['correct_option'] as String?)?.trim().toUpperCase();

    // Map A, B, C, D → 0, 1, 2, 3
    int index;
    switch (correct) {
      case 'A':
        index = 0;
        break;
      case 'B':
        index = 1;
        break;
      case 'C':
        index = 2;
        break;
      case 'D':
        index = 3;
        break;
      default:
        index = 0; // fallback
    }

    return QuizQuestion(
      id: json['id'].toString(),
      question: json['question'] ?? '',
      options: [
        json['option_a'] ?? '',
        json['option_b'] ?? '',
        json['option_c'] ?? '',
        json['option_d'] ?? '',
      ],
      answerIndex: index,
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
