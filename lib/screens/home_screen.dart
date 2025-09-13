import 'package:flutter/material.dart';
import '../widgets/verse_slider.dart';
import '../core/app_theme.dart';
import 'quiz/quiz_screen.dart';
import 'crossword/crossword_screen.dart';
import 'picture/picture_puzzle_screen.dart';
import 'games/memory_game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('ZedChristian',style: TextStyle(color: Colors.black54),),
        centerTitle: true,
        elevation: 0,

        actions: [

          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // TODO: notifications action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Notifications tapped")),
              );
            },
          ),
          PopupMenuButton<String>(
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$value selected")),
              );
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: "Profile", child: Text("👤 Profile")),
              const PopupMenuItem(value: "Settings", child: Text("⚙️ Settings")),
              const PopupMenuItem(value: "Logout", child: Text("🚪 Logout")),
            ],
            child: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/avator.png"),
            ),
          ),
          const SizedBox(width: 8),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.pastelBlue, AppTheme.pastelPink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Hero / Verse Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black26.withOpacity(.9), AppTheme.pastelGreen.withOpacity(.9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Faith + Fun',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 8),
                  // Text(
                  //   'God kind of faith!',
                  //   style: TextStyle(fontSize: 16, color: Colors.black87),
                  // ),
                  SizedBox(height: 16),
                  VerseSlider(),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Grid Portal
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _PortalCard(
                  title: 'Quizzes',
                  emoji: '❓',
                  color: AppTheme.pastelYellow,
                  onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> const QuizScreen())),
                ),
                _PortalCard(
                  title: 'Crosswords',
                  emoji: '🔠',
                  color: AppTheme.pastelGreen,
                  onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> const CrosswordScreen())),
                ),
                _PortalCard(
                  title: 'Puzzles',
                  emoji: '🖼️',
                  color: AppTheme.pastelPink,
                  onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> const PicturePuzzleScreen())),
                ),
                _PortalCard(
                  title: 'Memory ',
                  emoji: '🧠',
                  color: AppTheme.pastelBlue,
                  onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> const MemoryGameScreen())),
                ),
              ],
            ),
          ],
        ),

      ),
    );
  }
}

class _PortalCard extends StatelessWidget {
  final String title;
  final String emoji;
  final Color color;
  final VoidCallback onTap;
  const _PortalCard({
    required this.title,
    required this.emoji,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [color.withOpacity(.95), color.withOpacity(.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 42)),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}


