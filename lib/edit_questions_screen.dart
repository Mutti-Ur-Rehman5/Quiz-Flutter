import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditQuestionsScreen extends StatefulWidget {
  final String categoryName;

  const EditQuestionsScreen({super.key, required this.categoryName});

  @override
  State<EditQuestionsScreen> createState() => _EditQuestionsScreenState();
}

class _EditQuestionsScreenState extends State<EditQuestionsScreen> {
  Map<String, dynamic> questions = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final doc = await FirebaseFirestore.instance
        .collection('ListOfQuestions')
        .doc(widget.categoryName)
        .get();

    setState(() {
      questions = doc.data()?['questions'] ?? {};
      loading = false;
    });
  }

  void saveQuestion(String key, Map<String, dynamic> updatedData) async {
    questions[key] = updatedData;

    await FirebaseFirestore.instance
        .collection('ListOfQuestions')
        .doc(widget.categoryName)
        .update({"questions": questions});

    setState(() {});
  }

  void deleteQuestion(String key) async {
    questions.remove(key);

    await FirebaseFirestore.instance
        .collection('ListOfQuestions')
        .doc(widget.categoryName)
        .update({"questions": questions});

    setState(() {});
  }

  void addQuestion() {
    String newKey = questions.length.toString();

    questions[newKey] = {
      "correctOptionKey": "1",
      "options": {"1": "", "2": "", "3": "", "4": ""},
      "questionText": "New Question"
    };

    saveQuestion(newKey, questions[newKey]!);
  }

  void editDialog(String key, Map<String, dynamic> qData) {
    TextEditingController questionText =
        TextEditingController(text: qData["questionText"]);
    TextEditingController opt1 =
        TextEditingController(text: qData["options"]["1"]);
    TextEditingController opt2 =
        TextEditingController(text: qData["options"]["2"]);
    TextEditingController opt3 =
        TextEditingController(text: qData["options"]["3"]);
    TextEditingController opt4 =
        TextEditingController(text: qData["options"]["4"]);
    TextEditingController correct =
        TextEditingController(text: qData["correctOptionKey"]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Question"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: questionText, decoration: InputDecoration(labelText: "Question")),
              TextField(controller: opt1, decoration: InputDecoration(labelText: "Option 1")),
              TextField(controller: opt2, decoration: InputDecoration(labelText: "Option 2")),
              TextField(controller: opt3, decoration: InputDecoration(labelText: "Option 3")),
              TextField(controller: opt4, decoration: InputDecoration(labelText: "Option 4")),
              TextField(controller: correct, decoration: InputDecoration(labelText: "Correct Option Key")),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () {
              deleteQuestion(key);
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            child: Text("Save"),
            onPressed: () {
              saveQuestion(key, {
                "questionText": questionText.text,
                "correctOptionKey": correct.text,
                "options": {
                  "1": opt1.text,
                  "2": opt2.text,
                  "3": opt3.text,
                  "4": opt4.text,
                }
              });
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: Text("Edit ${widget.categoryName}")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.categoryName}"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: addQuestion,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          String key = index.toString();
          var q = questions[key];

          return ListTile(
            title: Text(q["questionText"]),
            subtitle: Text("Correct Option: ${q["correctOptionKey"]}"),
            trailing: Icon(Icons.edit),
            onTap: () => editDialog(key, q),
          );
        },
      ),
    );
  }
}
