import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FlutterQuizScreen extends StatefulWidget {
  const FlutterQuizScreen({
    super.key,
    required this.categoryName,
    required this.questions,
  });

  final String categoryName;
  final Map<String, dynamic> questions;

  @override
  State<FlutterQuizScreen> createState() => _FlutterQuizScreenState();
}

class _FlutterQuizScreenState extends State<FlutterQuizScreen> {
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
        _nextQuestion(false); // Auto wrong
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

    // Instant feedback
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
        // 🔥 Save score to Firestore instead of SharedPreferences
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('scores')
              .doc(widget.categoryName)
              .set({
            'score': score,
            'total': widget.questions.length,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }

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
    });
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
      backgroundColor: const Color(0xFFF6F4FF),
      appBar: AppBar(
        title: Text("${widget.categoryName} Quiz"),
        backgroundColor: Colors.deepPurple,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timer Bar
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

            // Question progress
            Text(
              "Question ${currentIndex + 1} of ${widget.questions.length}",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 20),

            // Question Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                currentQuestion['questionText'],
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 30),

            // Options
            ...currentQuestion['options'].entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => _answerQuestion(entry.key),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    minimumSize: const Size.fromHeight(55),
                    elevation: 3,
                    shadowColor: Colors.deepPurple.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: Colors.deepPurple, width: 1.2),
                    ),
                  ),
                  child: Text(
                    entry.value,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
