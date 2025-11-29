import 'package:flutter/material.dart';


class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.categoryName, required this.questions});

  final String categoryName;
  final Map<String, dynamic> questions;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  int score = 0;

  void _answerQuestion(String selectedOptionKey) {
    String correctKey = widget.questions['${currentIndex}']['correctOptionKey'];
    if (selectedOptionKey == correctKey) {
      score++;
    }

    if (currentIndex < widget.questions.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      // Quiz Finished
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Quiz Finished!"),
          content: Text("Your Score: $score / ${widget.questions.length}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Back to HomeScreen
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions['${currentIndex}'];

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.categoryName} Quiz"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question number
            Text(
              "Question ${currentIndex + 1} of ${widget.questions.length}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Question text
            Text(
              currentQuestion['questionText'],
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),

            // Options buttons
            ...currentQuestion['options'].entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () => _answerQuestion(entry.key),
                  child: Text(entry.value, style: const TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
