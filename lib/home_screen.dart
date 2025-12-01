import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- for ThemeProvider
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
import 'theme_provider.dart'; // <-- your ThemeProvider file

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "User";
  File? profileImage;

  final List<Map<String, dynamic>> categories = [
    {"name": "Flutter", "icon": Icons.flutter_dash, "color": Colors.blue},
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
    if (doc.exists) return doc.data()?['questions'] ?? {};
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
        screen =
            FlutterQuizScreen(categoryName: category, questions: questions);
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
      appBar: AppBar(
        title: const Text("QuizMaker Categories"),
        backgroundColor: Colors.deepPurple,
        actions: [
          Row(
            children: [
              Text(userName,
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(width: 8),

              // <-- Theme toggle button
              IconButton(
                icon: const Icon(Icons.brightness_6, color: Colors.white),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              ),

              // <-- Profile Avatar with image
              InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                  _loadUserData(); // reload profile image and name after returning
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: profileImage != null
                      ? kIsWeb
                          ? NetworkImage(profileImage!.path) as ImageProvider
                          : FileImage(profileImage!)
                      : null,
                  child: profileImage == null
                      ? const Icon(Icons.person, color: Colors.deepPurple)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];

            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              shadowColor: category["color"].withOpacity(0.5),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => navigateToQuiz(category["name"]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: category["color"].withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        category["icon"],
                        size: 40,
                        color: category["color"],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      category["name"],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
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
