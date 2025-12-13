import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SportsQuizScreen extends StatefulWidget {
  const SportsQuizScreen({super.key, required this.categoryName, required this.questions});

  final String categoryName;
  final Map<String, dynamic> questions;

  @override
  State<SportsQuizScreen> createState() => _SportsQuizScreenState();
}

class _SportsQuizScreenState extends State<SportsQuizScreen> {
  int currentIndex = 0;
  int score = 0;
  Timer? _timer;
  int _timeLeft = 10;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 10;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _timeLeft--);
      if (_timeLeft == 0) {
        _timer?.cancel();
        _nextQuestion(false);
      }
    });
  }

  void _answerQuestion(String selectedOptionKey) {
    final correctKey = widget.questions['$currentIndex']['correctOptionKey'];
    bool isCorrect = selectedOptionKey == correctKey;

    _nextQuestion(isCorrect);
  }

  void _nextQuestion(bool isCorrect) async {
    if (isCorrect) score++;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? "Correct!" : "Wrong!"),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(milliseconds: 500),
      ),
    );

    _timer?.cancel();

    Future.delayed(const Duration(milliseconds: 500), () async {
      if (currentIndex < widget.questions.length - 1) {
        setState(() => currentIndex++);
        _startTimer();
      } else {
        await _saveScoreToFirestore();
        _showResultDialog();
      }
    });
  }

  Future<void> _saveScoreToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('quizScores')
          .doc(widget.categoryName);

      await docRef.set({'score': score, 'total': widget.questions.length});
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("🎉 Quiz Finished!"),
        content: Text("Your Score: $score / ${widget.questions.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions['$currentIndex'];

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.categoryName} Quiz"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: _timeLeft / 10,
              color: Colors.red,
              backgroundColor: Colors.red.shade200,
              minHeight: 8,
            ),
            const SizedBox(height: 6),
            Text(
              "Time Left: $_timeLeft sec",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Question ${currentIndex + 1} of ${widget.questions.length}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(currentQuestion['questionText'], style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            ...currentQuestion['options'].entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => _answerQuestion(entry.key),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    minimumSize: const Size.fromHeight(50),
                  ),
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
