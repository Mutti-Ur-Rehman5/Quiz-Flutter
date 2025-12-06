import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'User';
      String? path = prefs.getString("profile_image");
      if (path != null) profileImage = File(path);
    });
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,

      // ⭐ BIG PURPLE NAVBAR ⭐
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF7B3EF3),
                Color(0xFFB089F9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.4),
                blurRadius: 25,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "QuizMaker",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),

                Row(
                  children: [
                    Text(
                      userName,
                      style:
                          const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(width: 14),

                    _glassIconButton(
                      icon: Icons.brightness_6_rounded,
                      onTap: () => themeProvider.toggleTheme(),
                    ),
                    const SizedBox(width: 14),

                    // ⭐ PROFILE AVATAR ⭐
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()),
                        );
                        _loadUserData();
                      },
                      child: CircleAvatar(
                        radius: 27,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        backgroundImage: profileImage != null
                            ? (kIsWeb
                                ? NetworkImage(profileImage!.path)
                                : FileImage(profileImage!)) as ImageProvider
                            : null,
                        child: profileImage == null
                            ? const Icon(Icons.person,
                                color: Colors.white, size: 28)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 14),

                    _glassIconButton(
                      icon: Icons.logout,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                    ),
                  ],
                )
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
                          Icon(
                            category["icon"],
                            size: 65,
                            color: Colors.white,
                          ),
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

  Widget _glassIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white30),
        ),
        child: Icon(icon, size: 26, color: Colors.white),
      ),
    );
  }
}
