import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = true;
  Map<String, int> quizHistory = {}; // {QuizName: Score}

  File? _mobileImage;          // Mobile File
  Uint8List? _webImage;        // Web bytes

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadQuizHistory();
    loadProfileImage();
  }

  // Load saved user info
  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    nameController.text = prefs.getString("name") ?? "";
    emailController.text = prefs.getString("email") ?? "";
    passwordController.text = prefs.getString("password") ?? "";

    setState(() => isLoading = false);
  }

  // Save changes
  Future<void> saveChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("name", nameController.text.trim());
    await prefs.setString("email", emailController.text.trim());
    await prefs.setString("password", passwordController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Updated Successfully!")),
    );
  }

  // Load quiz history
  Future<void> loadQuizHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      quizHistory = {
        "Math": prefs.getInt("quiz_Math") ?? 0,
        "Science": prefs.getInt("quiz_Science") ?? 0,
        "Geography": prefs.getInt("quiz_Geography") ?? 0,
        "Sports": prefs.getInt("quiz_Sports") ?? 0,
        "Technology": prefs.getInt("quiz_Technology") ?? 0,
        "History": prefs.getInt("quiz_History") ?? 0,
        "Flutter": prefs.getInt("quiz_Flutter") ?? 0,
      };
    });
  }

  // Pick profile image
  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (kIsWeb) {
        // Web: read bytes
        final bytes = await pickedFile.readAsBytes();
        setState(() => _webImage = bytes);

        // Save to SharedPreferences as base64
        await prefs.setString("profile_image_web", base64Encode(bytes));
      } else {
        // Mobile: use File
        setState(() => _mobileImage = File(pickedFile.path));

        // Save path to SharedPreferences
        await prefs.setString("profile_image_mobile", pickedFile.path);
      }
    }
  }

  // Load saved profile image
  Future<void> loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (kIsWeb) {
      String? base64Str = prefs.getString("profile_image_web");
      if (base64Str != null) {
        setState(() => _webImage = base64Decode(base64Str));
      }
    } else {
      String? path = prefs.getString("profile_image_mobile");
      if (path != null && File(path).existsSync()) {
        setState(() => _mobileImage = File(path));
      }
    }
  }

  // Get profile avatar widget
  Widget getProfileAvatar() {
    if (kIsWeb && _webImage != null) {
      return CircleAvatar(radius: 50, backgroundImage: MemoryImage(_webImage!));
    }
    if (!kIsWeb && _mobileImage != null) {
      return CircleAvatar(radius: 50, backgroundImage: FileImage(_mobileImage!));
    }
    return const CircleAvatar(
      radius: 50,
      backgroundColor: Colors.deepPurple,
      child: Icon(Icons.person, color: Colors.white, size: 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            // Profile Image
            GestureDetector(
              onTap: pickProfileImage,
              child: getProfileAvatar(),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tap image to change",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Name
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Password
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Quiz History Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "📊 Quiz History",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ...quizHistory.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "${entry.value} pts",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
