import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';
import 'Math.dart';
import 'flutter_quiz.dart';
import 'geography_quiz.dart';
import 'science_quiz.dart';
import 'sports_quiz.dart';
import 'technology_quiz.dart';
import 'history_quiz.dart';
import 'profile.dart';
import 'theme_provider.dart';
import 'edit_questions_screen.dart';
import 'quiz_web_resources_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "User";
  File? profileImage;

  final List<Map<String, dynamic>> categories = [
    {"name": "Flutter", "icon": Icons.flutter_dash, "color": Colors.purple},
    {"name": "Geography", "icon": Icons.public, "color": Colors.green},
    {"name": "Science", "icon": Icons.science, "color": Colors.deepPurple},
    {"name": "Math", "icon": Icons.calculate, "color": Colors.orange},
    {"name": "Sports", "icon": Icons.sports_soccer, "color": Colors.red},
    {"name": "Technology", "icon": Icons.computer, "color": Colors.teal},
    {"name": "History", "icon": Icons.history_edu, "color": Colors.brown},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// 🔥 Load user name from Firestore using Firebase Auth UID
  void _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      setState(() {
        userName = userDoc['name'] ?? 'User';
      });
    }
  }

  Future<Map<String, dynamic>> getQuestions(String category) async {
    final doc = await FirebaseFirestore.instance
        .collection('ListOfQuestions')
        .doc(category)
        .get();

    if (doc.exists) {
      return doc.data()?['questions'] ?? {};
    }
    return {};
  }

  void navigateToQuiz(String category) async {
    final questions = await getQuestions(category);

    Widget screen;
    switch (category) {
      case "Math":
        screen = QuizScreen(categoryName: category, questions: questions);
        break;
      case "Flutter":
        screen = FlutterQuizScreen(categoryName: category, questions: questions);
        break;
      case "Geography":
        screen =
            GeographyQuizScreen(categoryName: category, questions: questions);
        break;
      case "Science":
        screen = ScienceQuizScreen(categoryName: category, questions: questions);
        break;
      case "Sports":
        screen = SportsQuizScreen(categoryName: category, questions: questions);
        break;
      case "Technology":
        screen =
            TechnologyQuizScreen(categoryName: category, questions: questions);
        break;
      case "History":
        screen = HistoryQuizScreen(categoryName: category, questions: questions);
        break;
      default:
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  /// 🔐 Firebase Logout
  void _logout() async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,

      // ⭐ BEAUTIFUL NEW NAVBAR ⭐
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF6A4FEF),
                Color(0xFF8A6BFF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(35),
              bottomRight: Radius.circular(35),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.35),
                blurRadius: 25,
                spreadRadius: 1,
                offset: Offset(0, 10),
              )
            ],
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.bolt,
                        size: 34,
                        color: Colors.yellowAccent.withOpacity(0.9)),
                    const SizedBox(width: 10),
                    const Text(
                      "QuizMaker",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),

                    _glassNavbarButton(
                      icon: Icons.wb_sunny_rounded,
                      glowColor: Colors.yellowAccent,
                      onTap: () => themeProvider.toggleTheme(),
                    ),
                    const SizedBox(width: 12),

                    _glassNavbarButton(
                      icon: Icons.language_rounded,
                      glowColor: Colors.cyanAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const QuizWebResourcesScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),

                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                        _loadUserData();
                      },
                      child: CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white.withOpacity(0.25),
                        child: const Icon(Icons.person,
                            color: Colors.white, size: 26),
                      ),
                    ),
                    const SizedBox(width: 12),

                    _glassNavbarButton(
                      icon: Icons.logout_rounded,
                      glowColor: Colors.redAccent,
                      onTap: _logout,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 130, left: 10, right: 10),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  colors: [
                    category["color"].withOpacity(0.9),
                    category["color"].withOpacity(0.65)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: category["color"].withOpacity(0.45),
                    blurRadius: 14,
                    offset: const Offset(3, 6),
                  )
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () => navigateToQuiz(category["name"]),
                child: Stack(
                  children: [
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit,
                              size: 20, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditQuestionsScreen(
                                  categoryName: category["name"],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(category["icon"],
                              size: 65, color: Colors.white),
                          const SizedBox(height: 14),
                          Text(
                            category["name"],
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 5,
                                  color: Colors.black54,
                                  offset: Offset(1, 2),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _glassNavbarButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color glowColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white30),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.45),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(icon, size: 26, color: Colors.white),
      ),
    );
  }
}
