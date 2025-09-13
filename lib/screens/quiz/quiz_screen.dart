import 'package:flutter/material.dart';
import '../../core/services/local_store.dart';
import '../../models/quiz.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<QuizQuestion> questions;
  int idx = 0;
  int? selected;
  int score = 0;

  @override
  void initState() {
    super.initState();
    questions = LocalStore.getAllQuizzes();
    questions.shuffle();
  }

  void submit() {
    if (selected == null) return;
    if (selected == questions[idx].answerIndex) score++;
    if (idx < questions.length - 1) {
      setState(() { idx++; selected = null; });
    } else {
      showDialog(context: context, builder: (_)=> AlertDialog(
        title: const Text('Quiz complete!'),
        content: Text('Score: $score / ${questions.length}'),
        actions: [ TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('OK')) ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(appBar: AppBar(title: const Text('Quizzes')), body: const Center(child: Text('No questions yet.')));
    }
    final q = questions[idx];
    return Scaffold(
      appBar: AppBar(title: const Text('Quizzes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: (idx+1)/questions.length),
            const SizedBox(height: 16),
            Text(q.question, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...List.generate(q.options.length, (i){
              final isSel = selected == i;
              return ListTile(
                title: Text(q.options[i]),
                leading: Radio<int>(value: i, groupValue: selected, onChanged: (v)=> setState(()=> selected=v)),
                tileColor: isSel ? Colors.white10 : null,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              );
            }),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Question ${idx+1} / ${questions.length}'),
                ElevatedButton(onPressed: submit, child: Text(idx == questions.length-1 ? 'Finish' : 'Next')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
