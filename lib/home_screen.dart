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
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,        // 3 columns → all cards fit
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,      // square-ish cards
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
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected ${category["name"]}')),
                  );
                },
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
                        size: 40,         // bigger icon
                        color: category["color"],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      category["name"],
                      style: TextStyle(
                        fontSize: 14,      // readable text
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
