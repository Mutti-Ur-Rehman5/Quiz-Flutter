import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;
  const SplashScreen({super.key, required this.isLoggedIn});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 2.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) =>
                widget.isLoggedIn ? HomeScreen() : const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),

      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App Icon Circle
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF03A9F4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blue.shade700.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2)
                  ],
                ),
                child: const Icon(
                  Icons.quiz,
                  color: Colors.white,
                  size: 70,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Quiz Maker",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Sharpen your mind!",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              const CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
