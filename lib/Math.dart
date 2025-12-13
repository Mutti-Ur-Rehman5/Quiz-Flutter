import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.categoryName,
    required this.questions,
  });

  final String categoryName;
  final Map<String, dynamic> questions;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  int score = 0;
  Timer? _timer;
  int _timeLeft = 10; // 10 seconds per question

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 10;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
      });

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
        setState(() {
          currentIndex++;
        });
        _startTimer();
      } else {
        await _saveScoreToFirestore();
        _showResultDialog();
      }
    });
  }

  Future<void> _saveScoreToFirestore() async {
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
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          "🎉 Quiz Completed!",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "You scored $score out of ${widget.questions.length}",
          style: const TextStyle(fontSize: 18),
        ),
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
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: Text("${widget.categoryName} Quiz"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timer bar
            LinearProgressIndicator(
              value: _timeLeft / 10,
              color: Colors.red,
              backgroundColor: Colors.red.shade100,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 10),
            Text("Time left: $_timeLeft sec",
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Question number
            Text(
              "Question ${currentIndex + 1}/${widget.questions.length}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Question card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                currentQuestion['questionText'],
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Options
            ...currentQuestion['options'].entries.map(
              (entry) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    elevation: 3,
                    minimumSize: const Size.fromHeight(55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => _answerQuestion(entry.key),
                  child: Text(
                    entry.value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
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
