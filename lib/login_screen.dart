import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup_screen.dart';
import 'my_button.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load saved email and password
  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailController.text = prefs.getString('email') ?? '';
    passwordController.text = prefs.getString('password') ?? '';
  }

  // Login function
  void _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedEmail = prefs.getString('email') ?? '';
    String savedPassword = prefs.getString('password') ?? '';

    if (email == savedEmail && password == savedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Email or Password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                // 🔹 Large Login Icon
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple.withOpacity(0.1),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: Colors.deepPurple,
                  ),
                ),

                const SizedBox(height: 30),
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Login to continue",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 30),

                // 🔹 Email TextField
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 🔹 Password TextField
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // 🔹 Login Button
                MyButton(buttontext: "Login", onTap: _login),
                const SizedBox(height: 25),

                // 🔹 Signup Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()),
                        );
                      },
                      child: const Text(
                        "Signup",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
