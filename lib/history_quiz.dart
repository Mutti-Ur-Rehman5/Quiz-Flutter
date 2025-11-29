import 'package:flutter/material.dart';

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

  void _answerQuestion(String selectedOptionKey) {
    String correctKey = widget.questions['$currentIndex']['correctOptionKey'];
    if (selectedOptionKey == correctKey) score++;

    if (currentIndex < widget.questions.length - 1) {
      setState(() => currentIndex++);
    } else {
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
      appBar: AppBar(title: Text("${widget.categoryName} Quiz"), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Question ${currentIndex + 1} of ${widget.questions.length}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(currentQuestion['questionText'], style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            ...currentQuestion['options'].entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => _answerQuestion(entry.key),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, minimumSize: const Size.fromHeight(50)),
                  child: Text(entry.value, style: const TextStyle(fontSize: 18)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
