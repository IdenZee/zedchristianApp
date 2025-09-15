import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
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
  int timeLeft = 60;
  late final ticker;

  bool showResult = false;
  bool isMuted = false;
  final player = AudioPlayer();
  final bgPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    questions = LocalStore.getAllQuizzes();
    questions.shuffle();

    // background loop
    bgPlayer.setReleaseMode(ReleaseMode.loop);
    _playBg();

    // countdown
    ticker = Stream.periodic(const Duration(seconds: 1), (i) => i).listen((_) {
      if (timeLeft > 0) {
        setState(() => timeLeft--);
      } else {
        ticker.cancel();
        submit();
      }
    });
  }

  @override
  void dispose() {
    ticker.cancel();
    player.dispose();
    bgPlayer.dispose();
    super.dispose();
  }

  Future<void> _playBg() async {
    if (!isMuted) {
      await bgPlayer.play(AssetSource("audio/bg.mp3"));
    }
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
    if (isMuted) {
      bgPlayer.pause();
    } else {
      _playBg();
    }
  }

  Future<void> _playEffect(String file) async {
    if (!isMuted) {
      await player.stop(); // stop overlap
      await player.play(AssetSource(file));
    }
  }

  void _restartQuiz() {
    setState(() {
      idx = 0;
      score = 0;
      selected = null;
      showResult = false;
      timeLeft = 60;
      questions.shuffle();
    });
    ticker.resume();
  }

  void submit() async {
    if (selected == null) return;

    setState(() {
      showResult = true;
    });

    // sound effect
    if (selected == questions[idx].answerIndex) {
      await _playEffect("audio/correct.mp3");
      score++;
    } else {
      await _playEffect("audio/wrong.mp3");
    }

    await Future.delayed(const Duration(seconds: 1));

    if (idx < questions.length - 1) {
      setState(() {
        idx++;
        selected = null;
        showResult = false;
        timeLeft = 60;
      });
      await _playEffect("audio/next.mp3");
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Quiz complete!'),
          content: Text('Score: $score / ${questions.length}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _restartQuiz();
              },
              child: const Text('Restart'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  void _showPauseMenu() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.deepPurple, Colors.pinkAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Game Paused",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Resume
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                label: const Text("Resume", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 12),

              // Restart
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _restartQuiz();
                },
                label: const Text("Restart", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 12),

              // Home
              ElevatedButton.icon(
                icon: const Icon(Icons.home, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // back to home
                },
                label: const Text("Home", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quizzes')),
        body: const Center(child: Text('No questions yet.')),
      );
    }
    final q = questions[idx];

    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      body: SafeArea(
        child: Column(
          children: [
            // top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [

                  IconButton(
                    onPressed: _showPauseMenu,
                    icon: const Icon(Icons.pause, color: Colors.white),
                  ),


                  // progress bar
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: LinearProgressIndicator(
                        value: timeLeft / 60,
                        color: Colors.green,
                        backgroundColor: Colors.red[200],
                        minHeight: 10,
                      ),
                    ),
                  ),

                  // mute toggle
                  IconButton(
                    icon: Icon(
                      isMuted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                    ),
                    onPressed: _toggleMute,
                  ),
                ],
              ),
            ),

            // question card
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    q.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Text("Question ${idx + 1}/${questions.length}",
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // answers with animations
            Expanded(
              child: ListView.builder(
                itemCount: q.options.length,
                itemBuilder: (_, i) {
                  Color? color;
                  if (showResult) {
                    if (i == questions[idx].answerIndex) {
                      color = Colors.green;
                    } else if (i == selected) {
                      color = Colors.red;
                    } else {
                      color = Colors.yellow[700];
                    }
                  } else {
                    color = (selected == i)
                        ? Colors.orange
                        : Colors.yellow[700];
                  }

                  return GestureDetector(
                    onTap: () {
                      if (!showResult) {
                        setState(() => selected = i);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          if (showResult && i == questions[idx].answerIndex)
                            const BoxShadow(
                              color: Colors.greenAccent,
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          if (showResult &&
                              i == selected &&
                              i != questions[idx].answerIndex)
                            const BoxShadow(
                              color: Colors.redAccent,
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                        ],
                      ),
                      child: Text(
                        "${String.fromCharCode(65 + i)}: ${q.options[i]}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                },
              ),
            ),

            // next / finish button
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: submit,
                child: Text(idx == questions.length - 1 ? "Finish" : "Next"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
