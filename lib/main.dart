import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Data/existing_data.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const UploadQuestionsScreen());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UploadQuestionsScreen(),
    );
  }
}


class UploadQuestionsScreen extends StatelessWidget {
  const UploadQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              uploadQuestionsToFirebase();
            },
            child: const Text("Upload data"),
          ),
        ),
      ),
    );
  }
}
