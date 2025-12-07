import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Quiz list moved outside the class
const List<Map<String, String>> quizWebsites = [
  {
    "name": "Flutter",
    "description": "Official Flutter documentation for learning.",
    "url": "https://flutter.dev/docs/get-started"
  },
  {
    "name": "Geography",
    "description": "National Geographic resources and maps.",
    "url": "https://www.nationalgeographic.com"
  },
  {
    "name": "Science",
    "description": "Latest news and articles on science topics.",
    "url": "https://www.sciencenews.org"
  },
  {
    "name": "Math",
    "description": "Khan Academy math lessons and exercises.",
    "url": "https://www.khanacademy.org/math"
  },
  {
    "name": "Sports",
    "description": "Sports updates and stats from ESPN.",
    "url": "https://www.espn.com"
  },
  {
    "name": "Technology",
    "description": "Tech news and gadget reviews.",
    "url": "https://www.techradar.com"
  },
  {
    "name": "History",
    "description": "Historical articles and documentaries.",
    "url": "https://www.history.com"
  },
];

class QuizWebResourcesScreen extends StatelessWidget {
  const QuizWebResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Preparation"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: quizWebsites.length,
          itemBuilder: (context, index) {
            final quiz = quizWebsites[index];
            return Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          WebViewScreen(title: quiz["name"]!, url: quiz["url"]!),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.school,
                          color: Colors.deepPurple, size: 36),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quiz["name"]!,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              quiz["description"]!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          color: Colors.black38, size: 20)
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Fullscreen WebView with WebViewController (compatible with webview_flutter 4.x)
class WebViewScreen extends StatefulWidget {
  final String title;
  final String url;

  const WebViewScreen({super.key, required this.title, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: Colors.deepPurple),
      body: WebViewWidget(controller: _controller),
    );
  }
}
