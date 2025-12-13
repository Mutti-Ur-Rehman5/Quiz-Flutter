import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🏆 Leaderboard"),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')  // ← changed from 'leaderboard'
            .orderBy('totalScore', descending: true) // ← totalScore
            .limit(10)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No scores yet!"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final username = data['name'] ?? 'Unknown';
              final score = data['totalScore'] ?? 0;
              final total = data['quizzesPlayed'] ?? 0;

              Color bgColor = Colors.white;
              Color textColor = Colors.black;

              if (index == 0) {
                bgColor = Colors.amber.shade400;
                textColor = Colors.white;
              } else if (index == 1) {
                bgColor = Colors.grey.shade400;
                textColor = Colors.white;
              } else if (index == 2) {
                bgColor = Colors.brown.shade400;
                textColor = Colors.white;
              }

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      "#${index + 1}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        username,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: textColor),
                      ),
                    ),
                    Text(
                      "$score/$total",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
