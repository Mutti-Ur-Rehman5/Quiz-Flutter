import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeographyQuizScreen extends StatefulWidget {
  const GeographyQuizScreen({
    super.key,
    required this.categoryName,
    required this.questions,
  });

  final String categoryName;
  final Map<String, dynamic> questions;

  @override
  State<GeographyQuizScreen> createState() => _GeographyQuizScreenState();
}

class _GeographyQuizScreenState extends State<GeographyQuizScreen> {
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
        _nextQuestion(false); // auto wrong
      }
    });
  }

  void _answerQuestion(String selectedOptionKey) {
    final currentQuestion = widget.questions['$currentIndex'] as Map<String, dynamic>;
    final correctKey = currentQuestion['correctOptionKey'] as String;
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
        // Save score
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt("quiz_${widget.categoryName}", score);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            backgroundColor: Colors.deepPurple.shade50,
            title: const Text(
              "🎉 Quiz Completed!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
    final currentQuestion = widget.questions['$currentIndex'] as Map<String, dynamic>;
    final options = Map<String, String>.from(currentQuestion['options'] as Map);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff4e54c8), Color(0xff8f94fb)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
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
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 20),
                
                // Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.categoryName} Quiz",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Q ${currentIndex + 1}/${widget.questions.length}",
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Question Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                  ),
                  child: Text(
                    currentQuestion['questionText'],
                    style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 30),

                // Options
                Expanded(
                  child: ListView(
                    children: options.entries.map(
                      (entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                            onTap: () => _answerQuestion(entry.key),
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white.withOpacity(0.12),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                              ),
                              child: Text(entry.value, style: const TextStyle(fontSize: 18, color: Colors.white)),
                            ),
                          ),
                        );
                      },
                    ).toList(),
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
