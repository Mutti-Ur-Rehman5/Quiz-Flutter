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
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Edit Question",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple),
                ),
                const SizedBox(height: 18),

                _inputBox("Question", questionText),
                _inputBox("Option 1", opt1),
                _inputBox("Option 2", opt2),
                _inputBox("Option 3", opt3),
                _inputBox("Option 4", opt4),
                _inputBox("Correct Option Key (1-4)", correct),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        deleteQuestion(key);
                        Navigator.pop(context);
                      },
                      child: const Text("Delete"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
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
                      child: const Text("Save"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputBox(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.deepPurple.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text("Edit ${widget.categoryName}"),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.deepPurple),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 10,
        shadowColor: Colors.deepPurple.withOpacity(0.4),
        title: Text(
          "Edit ${widget.categoryName}",
          style: const TextStyle(fontSize: 20),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: addQuestion,
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          String key = index.toString();
          var q = questions[key];

          return Card(
            elevation: 5,
            shadowColor: Colors.deepPurple.withOpacity(0.4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              title: Text(
                q["questionText"],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                "Correct Option: ${q["correctOptionKey"]}",
                style: const TextStyle(color: Colors.deepPurple),
              ),
              trailing: const Icon(Icons.edit, color: Colors.deepPurple),
              onTap: () => editDialog(key, q),
            ),
          );
        },
      ),
    );
  }
}
