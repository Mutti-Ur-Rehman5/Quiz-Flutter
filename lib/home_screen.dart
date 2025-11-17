import 'package:flutter/material.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QuizMaker Categories"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Selected ${category["name"]}')));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category["icon"],
                      size: 80,
                      color: category["color"],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      category["name"],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
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
