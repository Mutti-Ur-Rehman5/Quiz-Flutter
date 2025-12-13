import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TechnologyQuizScreen extends StatefulWidget {
  final String categoryName;
  final Map<String, dynamic> questions;

  const TechnologyQuizScreen({
    super.key,
    required this.categoryName,
    required this.questions,
  });

  @override
  State<TechnologyQuizScreen> createState() => _TechnologyQuizScreenState();
}

class _TechnologyQuizScreenState extends State<TechnologyQuizScreen> {
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
    String correctKey = widget.questions['$currentIndex']['correctOptionKey'];
    bool isCorrect = selectedOptionKey == correctKey;
    _nextQuestion(isCorrect);
  }

  void _nextQuestion(bool isCorrect) async {
    if (isCorrect) score++;

    // Feedback
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
        title: const Text("🎉 Quiz Completed!"),
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions['$currentIndex'];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff1e3c72), Color(0xff2a5298)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: _timeLeft / 10,
                  color: Colors.red,
                  backgroundColor: Colors.red.shade100,
                  minHeight: 8,
                ),
                const SizedBox(height: 6),
                Text("Time left: $_timeLeft sec",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 10),
                Text(
                  "${widget.categoryName} Quiz",
                  style: const TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "Question ${currentIndex + 1} of ${widget.questions.length}",
                  style: const TextStyle(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    currentQuestion['questionText'],
                    style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 35),
                ...currentQuestion['options'].entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: () => _answerQuestion(entry.key),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.18),
                        shadowColor: Colors.black26,
                        elevation: 4,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        entry.value,
                        style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
