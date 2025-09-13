class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int answerIndex;
  final String category;

  QuizQuestion({required this.id, required this.question, required this.options, required this.answerIndex, required this.category});

  factory QuizQuestion.fromJson(Map<String, dynamic> j) => QuizQuestion(
    id: j['id'],
    question: j['question'],
    options: List<String>.from(j['options']),
    answerIndex: j['answerIndex'],
    category: j['category'] ?? 'General',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'options': options,
    'answerIndex': answerIndex,
    'category': category,
  };
}
