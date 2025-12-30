import 'dart:io';
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
import 'LeaderboardScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "User";
  File? profileImage;
  bool isAdmin = false;

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
        isAdmin = userDoc['isAdmin'] ?? false;
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

    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

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

      /// ================= DRAWER =================
      endDrawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A4FEF), Color(0xFF8A6BFF)],
                ),
              ),
              accountName: Text(userName),
              accountEmail: Text(
                FirebaseAuth.instance.currentUser?.email ?? "",
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.wb_sunny_rounded),
              title: const Text("Toggle Theme"),
              onTap: () =>
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme(),
            ),

            ListTile(
              leading: const Icon(Icons.language_rounded),
              title: const Text("Web Resources"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const QuizWebResourcesScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.emoji_events_rounded),
              title: const Text("Leaderboard"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LeaderboardScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
                _loadUserData();
              },
            ),

            const Spacer(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: _logout,
            ),
          ],
        ),
      ),

      /// ================= APP BAR =================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6A4FEF), Color(0xFF8A6BFF)],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.bolt,
                        size: 32, color: Colors.yellowAccent),
                    SizedBox(width: 8),
                    Text(
                      "QuizMaker",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu,
                            color: Colors.white, size: 30),
                        onPressed: () =>
                            Scaffold.of(context).openEndDrawer(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),

      /// ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.only(top: 130, left: 10, right: 10),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  colors: [
                    category["color"].withOpacity(0.9),
                    category["color"].withOpacity(0.65),
                  ],
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () => navigateToQuiz(category["name"]),
                child: Stack(
                  children: [
                    if (isAdmin)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: IconButton(
                          icon: const Icon(Icons.edit,
                              color: Colors.white),
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
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(category["icon"],
                              size: 60, color: Colors.white),
                          const SizedBox(height: 10),
                          Text(
                            category["name"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
}
