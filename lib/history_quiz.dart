import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryQuizScreen extends StatefulWidget {
  const HistoryQuizScreen({super.key, required this.categoryName, required this.questions});

  final String categoryName;
  final Map<String, dynamic> questions;

  @override
  State<HistoryQuizScreen> createState() => _HistoryQuizScreenState();
}

class _HistoryQuizScreenState extends State<HistoryQuizScreen> {
  int currentIndex = 0;
  int score = 0;

  void _answerQuestion(String selectedOptionKey) async {
    String correctKey = widget.questions['$currentIndex']['correctOptionKey'];
    if (selectedOptionKey == correctKey) score++;

    if (currentIndex < widget.questions.length - 1) {
      setState(() => currentIndex++);
    } else {
      // Save score to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("quiz_${widget.categoryName}", score);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Quiz Finished!"),
          content: Text("Your Score: $score / ${widget.questions.length}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions['$currentIndex'];

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.categoryName} Quiz"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Question number & progress bar
            Text(
              "Question ${currentIndex + 1} of ${widget.questions.length}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (currentIndex + 1) / widget.questions.length,
              color: Colors.deepPurple,
              backgroundColor: Colors.deepPurple.shade100,
              minHeight: 6,
            ),
            const SizedBox(height: 24),

            // Question Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  currentQuestion['questionText'],
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Option buttons
            ...currentQuestion['options'].entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => _answerQuestion(entry.key),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    minimumSize: const Size.fromHeight(55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
