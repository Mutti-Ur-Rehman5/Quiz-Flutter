import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadQuestionsToFirebase() async {
  for (final sector in data.entries) {
    uloadQuestionForAField(
      sector.key,
      sector.value,
    );
  }
}

Future<void> uloadQuestionForAField(String field, dynamic data) async {
  FirebaseFirestore.instance.collection('ListOfQuestions').doc(field).set(data);
}

final data = {
  "Flutter": {
    "title": "Flutter",
    "image_url": "https://cdn-icons-png.flaticon.com/512/888/888859.png",
    "questions": {
      "0": {"correctOptionKey": "1", "options": {"1": "Dart","2": "Java","3": "Kotlin","4": "Swift"}, "questionText": "Which language is used to write Flutter apps?"},
      "1": {"correctOptionKey": "3", "options": {"1": "StatefulWidget","2": "Container","3": "Hot Reload","4": "FutureBuilder"}, "questionText": "Which feature allows quick UI updates in Flutter?"},
      "2": {"correctOptionKey": "2", "options": {"1": "Row","2": "Column","3": "Stack","4": "InkWell"}, "questionText": "Which widget arranges children vertically?"},
      "3": {"correctOptionKey": "4", "options": {"1": "pub.yaml","2": "options.dart","3": "firebase.dart","4": "pubspec.yaml"}, "questionText": "Which file manages app dependencies?"},
      "4": {"correctOptionKey": "1", "options": {"1": "StatelessWidget","2": "StateWidget","3": "BuildWidget","4": "UIWidget"}, "questionText": "Which widget does NOT store state?"},
      "5": {"correctOptionKey": "2", "options": {"1": "runApp()","2": "main()","3": "flutter()","4": "init()"}, "questionText": "Which is the entry point of a Flutter app?"},
      "6": {"correctOptionKey": "3", "options": {"1": "BuildContext","2": "Widget","3": "setState()","4": "async"}, "questionText": "Which function is used to update the UI?"},
      "7": {"correctOptionKey": "4", "options": {"1": "Stack","2": "Padding","3": "Card","4": "Scaffold"}, "questionText": "Which widget provides basic material design layout?"},
      "8": {"correctOptionKey": "2", "options": {"1": "async","2": "await","3": "future","4": "defer"}, "questionText": "Which keyword pauses the function until future completes?"},
      "9": {"correctOptionKey": "3", "options": {"1": "CircleImage","2": "RoundedImage","3": "Image.network()","4": "Image.asset.network()"}, "questionText": "Which widget loads an image from the internet?"}
    }
  },
  "Geography": {
    "title": "Geography",
    "image_url": "https://cdn-icons-png.flaticon.com/512/854/854878.png",
    "questions": {
      "0": {"correctOptionKey": "4", "options": {"1": "USA","2": "China","3": "Brazil","4": "Russia"}, "questionText": "Which is the largest country by area?"},
      "1": {"correctOptionKey": "2", "options": {"1": "Amazon","2": "Nile","3": "Yangtze","4": "Indus"}, "questionText": "Which is the longest river in the world?"},
      "2": {"correctOptionKey": "1", "options": {"1": "Mount Everest","2": "K2","3": "Kangchenjunga","4": "Denali"}, "questionText": "What is the highest mountain on Earth?"},
      "3": {"correctOptionKey": "3", "options": {"1": "Africa","2": "Antarctica","3": "Asia","4": "Europe"}, "questionText": "Which is the largest continent?"},
      "4": {"correctOptionKey": "2", "options": {"1": "Japan","2": "Australia","3": "Sri Lanka","4": "Iceland"}, "questionText": "Which is the smallest continent?"},
      "5": {"correctOptionKey": "1", "options": {"1": "Pacific Ocean","2": "Indian Ocean","3": "Atlantic Ocean","4": "Arctic Ocean"}, "questionText": "Which is the largest ocean?"},
      "6": {"correctOptionKey": "4", "options": {"1": "Pakistan","2": "India","3": "Nepal","4": "China"}, "questionText": "Which country has the largest population?"},
      "7": {"correctOptionKey": "3", "options": {"1": "Africa","2": "Europe","3": "Asia","4": "North America"}, "questionText": "Where is the Gobi Desert located?"},
      "8": {"correctOptionKey": "1", "options": {"1": "Saudi Arabia","2": "Egypt","3": "Iraq","4": "Iran"}, "questionText": "Which country is known for the Arabian Desert?"},
      "9": {"correctOptionKey": "2", "options": {"1": "Spain","2": "France","3": "Germany","4": "Italy"}, "questionText": "Which country has Paris as its capital?"}
    }
  },
  "Math": {
    "title": "Math",
    "image_url": "https://cdn-icons-png.flaticon.com/512/2729/2729005.png",
    "questions": {
      "0": {"correctOptionKey": "3", "options": {"1": "1","2": "2","3": "3.14","4": "4.13"}, "questionText": "What is the approximate value of π?"},
      "1": {"correctOptionKey": "1", "options": {"1": "2","2": "3","3": "4","4": "5"}, "questionText": "What is the square root of 4?"},
      "2": {"correctOptionKey": "4", "options": {"1": "10","2": "20","3": "30","4": "40"}, "questionText": "What is 8 × 5?"},
      "3": {"correctOptionKey": "2", "options": {"1": "6","2": "9","3": "12","4": "15"}, "questionText": "What is 3²?"},
      "4": {"correctOptionKey": "3", "options": {"1": "8","2": "12","3": "15","4": "17"}, "questionText": "What is 3 + 12?"},
      "5": {"correctOptionKey": "1", "options": {"1": "0","2": "1","3": "2","4": "3"}, "questionText": "What is the value of 5 – 5?"},
      "6": {"correctOptionKey": "4", "options": {"1": "2","2": "3","3": "4","4": "5"}, "questionText": "What is the next prime number after 3?"},
      "7": {"correctOptionKey": "1", "options": {"1": "12","2": "18","3": "24","4": "36"}, "questionText": "What is the LCM of 3 and 4?"},
      "8": {"correctOptionKey": "2", "options": {"1": "0","2": "1","3": "2","4": "3"}, "questionText": "What is the value of sin(0)?"},
      "9": {"correctOptionKey": "3", "options": {"1": "¼","2": "⅓","3": "½","4": "¾"}, "questionText": "What is 50% as a fraction?"}
    }
  },
  "Science": {
    "title": "Science",
    "image_url": "https://cdn-icons-png.flaticon.com/512/2965/2965879.png",
    "questions": {
      "0": {"correctOptionKey": "3", "options": {"1": "Nitrogen","2": "Carbon","3": "Oxygen","4": "Hydrogen"}, "questionText": "Which gas do humans need to breathe?"},
      "1": {"correctOptionKey": "1", "options": {"1": "H2O","2": "CO2","3": "O2","4": "NaCl"}, "questionText": "What is the chemical formula for water?"},
      "2": {"correctOptionKey": "4", "options": {"1": "Heart","2": "Brain","3": "Lungs","4": "Skin"}, "questionText": "Which is the largest organ of the human body?"},
      "3": {"correctOptionKey": "1", "options": {"1": "Gravity","2": "Magnetism","3": "Electricity","4": "Friction"}, "questionText": "Which force pulls objects toward Earth?"},
      "4": {"correctOptionKey": "2", "options": {"1": "Sun","2": "Moon","3": "Mars","4": "Venus"}, "questionText": "Which object causes ocean tides?"},
      "5": {"correctOptionKey": "3", "options": {"1": "Iron","2": "Gold","3": "Helium","4": "Copper"}, "questionText": "Which gas is used in balloons because it is lighter than air?"},
      "6": {"correctOptionKey": "4", "options": {"1": "Solid","2": "Liquid","3": "Gas","4": "Plasma"}, "questionText": "Which is the fourth state of matter?"},
      "7": {"correctOptionKey": "2", "options": {"1": "Telescope","2": "Microscope","3": "Calculator","4": "Stethoscope"}, "questionText": "Which device is used to see very tiny objects?"},
      "8": {"correctOptionKey": "3", "options": {"1": "Food","2": "Water","3": "Sunlight","4": "Heat"}, "questionText": "Plants make their food using?"},
      "9": {"correctOptionKey": "1", "options": {"1": "Jupiter","2": "Mars","3": "Venus","4": "Mercury"}, "questionText": "Which is the largest planet in our solar system?"}
    }
  },
  "Sport": {
    "title": "Sport",
    "image_url": "https://cdn-icons-png.flaticon.com/512/2303/2303981.png",
    "questions": {
      "0": {"correctOptionKey": "3", "options": {"1": "Baseball","2": "Tennis","3": "Football","4": "Cricket"}, "questionText": "Which is the most popular sport in the world?"},
      "1": {"correctOptionKey": "4", "options": {"1": "9","2": "10","3": "11","4": "11"}, "questionText": "How many players are on a football team?"},
      "2": {"correctOptionKey": "2", "options": {"1": "Pakistan","2": "Brazil","3": "Germany","4": "Argentina"}, "questionText": "Which country has won the most FIFA World Cups?"},
      "3": {"correctOptionKey": "1", "options": {"1": "Cricket","2": "Tennis","3": "Hockey","4": "Rugby"}, "questionText": "Which sport uses a bat and ball?"},
      "4": {"correctOptionKey": "3", "options": {"1": "3","2": "4","3": "5","4": "6"}, "questionText": "How many rings are on the Olympic flag?"},
      "5": {"correctOptionKey": "2", "options": {"1": "Lionel Messi","2": "Cristiano Ronaldo","3": "Neymar","4": "Hazard"}, "questionText": "Who is often called CR7?"},
      "6": {"correctOptionKey": "4", "options": {"1": "Squash","2": "Tennis","3": "Hockey","4": "Badminton"}, "questionText": "Which sport uses a shuttlecock?"},
      "7": {"correctOptionKey": "1", "options": {"1": "India","2": "Australia","3": "South Africa","4": "England"}, "questionText": "Which country won the Cricket World Cup 2011?"},
      "8": {"correctOptionKey": "2", "options": {"1": "Golf","2": "Basketball","3": "Tennis","4": "Swimming"}, "questionText": "Which sport uses a hoop and a ball?"},
      "9": {"correctOptionKey": "3", "options": {"1": "Baseball","2": "Cricket","3": "Table Tennis","4": "Rugby"}, "questionText": "Which sport uses a small paddle and a light ball?"}
    }
  },
  "Technology": {
    "title": "Technology",
    "image_url": "https://cdn-icons-png.flaticon.com/512/3144/3144456.png",
    "questions": {
      "0": {"correctOptionKey": "1", "options": {"1": "CPU","2": "GPU","3": "RAM","4": "SSD"}, "questionText": "Which component is known as the brain of the computer?"},
      "1": {"correctOptionKey": "4", "options": {"1": "Hard Disk","2": "CPU","3": "ROM","4": "RAM"}, "questionText": "Which memory is temporary and volatile?"},
      "2": {"correctOptionKey": "3", "options": {"1": "HTML","2": "Python","3": "Dart","4": "C++"}, "questionText": "Which language is used in Flutter development?"},
      "3": {"correctOptionKey": "2", "options": {"1": "YouTube","2": "Google","3": "Yahoo","4": "Bing"}, "questionText": "Which is the most used search engine?"},
      "4": {"correctOptionKey": "3", "options": {"1": "CPU","2": "Router","3": "Firewall","4": "Modem"}, "questionText": "Which device protects computers from unauthorized access?"},
      "5": {"correctOptionKey": "1", "options": {"1": "Wi-Fi","2": "Ethernet","3": "Bluetooth","4": "NFC"}, "questionText": "Which technology allows wireless internet?"},
      "6": {"correctOptionKey": "4", "options": {"1": "Excel","2": "PowerPoint","3": "Word","4": "Windows"}, "questionText": "Which is an operating system?"},
      "7": {"correctOptionKey": "2", "options": {"1": "SSD","2": "Keyboard","3": "RAM","4": "Mouse"}, "questionText": "Which is an input device?"},
      "8": {"correctOptionKey": "1", "options": {"1": "AI","2": "Car","3": "Food","4": "Clothes"}, "questionText": "Which technology lets computers think like humans?"},
      "9": {"correctOptionKey": "3", "options": {"1": "5G","2": "Fiber","3": "4G","4": "3G"}, "questionText": "Which network technology came before 5G?"}
    }
  },
  "History": {
    "title": "History",
    "image_url": "https://cdn-icons-png.flaticon.com/512/3190/3190833.png",
    "questions": {
      "0": {"correctOptionKey": "4", "options": {"1": "1940","2": "1945","3": "1950","4": "1947"}, "questionText": "In which year did Pakistan gain independence?"},
      "1": {"correctOptionKey": "2", "options": {"1": "Isaac Newton","2": "Albert Einstein","3": "Nikola Tesla","4": "Edison"}, "questionText": "Who developed the Theory of Relativity?"},
      "2": {"correctOptionKey": "1", "options": {"1": "Alexander the Great","2": "Genghis Khan","3": "Napoleon","4": "Hitler"}, "questionText": "Who was the famous Macedonian conqueror?"},
      "3": {"correctOptionKey": "3", "options": {"1": "UK","2": "France","3": "Egypt","4": "China"}, "questionText": "Where were the pyramids built?"},
      "4": {"correctOptionKey": "2", "options": {"1": "France","2": "USA","3": "Germany","4": "Italy"}, "questionText": "Which country dropped atomic bombs in World War 2?"},
      "5": {"correctOptionKey": "1", "options": {"1": "Mughal Empire","2": "Roman Empire","3": "Ottoman Empire","4": "China Empire"}, "questionText": "Which empire ruled the Indian subcontinent for centuries?"},
      "6": {"correctOptionKey": "3", "options": {"1": "1490","2": "1500","3": "1492","4": "1550"}, "questionText": "When did Columbus discover America?"},
      "7": {"correctOptionKey": "4", "options": {"1": "Einstein","2": "Newton","3": "Tesla","4": "Galileo"}, "questionText": "Who is known as the father of modern astronomy?"},
      "8": {"correctOptionKey": "2", "options": {"1": "India","2": "China","3": "Egypt","4": "Greece"}, "questionText": "Which country built the Great Wall?"},
      "9": {"correctOptionKey": "1", "options": {"1": "World War I","2": "World War II","3": "Cold War","4": "Vietnam War"}, "questionText": "Which war started in 1914?"}
    }
  }
};
