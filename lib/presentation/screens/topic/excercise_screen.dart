import 'package:flutter/material.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  int currentQuestionIndex = 0;
  int? selectedAnswer;
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Who invented Turing Machine?',
      'options': [
        'Enrico Hezkiel Sirait',
        'Boy Martahan Sitorus',
        'Emely Angelica Lestari',
        'Alan Turing'
      ],
      'correctAnswer': 3,
      'exp': 15,
      'pts': 10
    },
    {
      'question': 'HTML is a programme language',
      'options': ['True', 'False'],
      'correctAnswer': 2,
      'exp': 15,
      'pts': 10
    },
    {
      'question': 'Flutter is developed by which company?',
      'options': ['Apple', 'Google', 'Microsoft', 'Amazon'],
      'correctAnswer': 1,
      'exp': 15,
      'pts': 10
    },
    {
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Earth', 'Mars', 'Jupiter', 'Venus'],
      'correctAnswer': 1,
      'exp': 15,
      'pts': 10
    },
    {
      'question': 'What is the largest ocean on Earth?',
      'options': [
        'Atlantic Ocean',
        'Indian Ocean',
        'Pacific Ocean',
        'Arctic Ocean'
      ],
      'correctAnswer': 2,
      'exp': 15,
      'pts': 10
    },
    {
      'question': 'Which is the longest river in the world?',
      'options': [
        'Amazon River',
        'Nile River',
        'Yangtze River',
        'Mississippi River'
      ],
      'correctAnswer': 1,
      'exp': 15,
      'pts': 10
    },
    {
      'question': 'Who discovered gravity?',
      'options': [
        'Isaac Newton',
        'Albert Einstein',
        'Galileo Galilei',
        'Nikola Tesla'
      ],
      'correctAnswer': 0,
      'exp': 15,
      'pts': 10
    },
    {
      'question': 'What is the hardest natural substance on Earth?',
      'options': ['Gold', 'Iron', 'Diamond', 'Platinum'],
      'correctAnswer': 2,
      'exp': 15,
      'pts': 10
    },
    {
      'question': 'What is the chemical symbol for gold?',
      'options': ['Go', 'Au', 'Ag', 'Gd'],
      'correctAnswer': 1,
      'exp': 15,
      'pts': 10
    },
    {
      'question': 'Which gas do plants use for photosynthesis?',
      'options': ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Hydrogen'],
      'correctAnswer': 2,
      'exp': 15,
      'pts': 10
    },
  ];

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        _scrollToCurrentQuestion();
      });
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        selectedAnswer = null;
        _scrollToCurrentQuestion();
      });
    }
  }

  void _scrollToCurrentQuestion() {
    _scrollController.animateTo(
      currentQuestionIndex * 50.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];
    int exp = question['exp'];
    int pts = question['pts'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+$exp exp',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 13),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+$pts pts',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 13),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Text(
                    'Exit',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.exit_to_app, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _goToQuestion(index), // Tambahkan aksi klik
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == currentQuestionIndex
                            ? Colors.blue
                            : Colors.grey[300],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 18,
                          color: index == currentQuestionIndex
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              question['question'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...List.generate(
              question['options'].length,
              (index) => _buildOptionCard(index, question['options'][index]),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed:
                      currentQuestionIndex > 0 ? _previousQuestion : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentQuestionIndex > 0
                        ? Colors.grey[400]
                        : Colors.grey[400],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: currentQuestionIndex < questions.length - 1
                      ? _nextQuestion
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentQuestionIndex < questions.length - 1
                        ? Colors.blue[300]
                        : Colors.grey[400],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(int index, String text) {
    bool isSelected = selectedAnswer == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswer = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.7) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isSelected ? Colors.blue : Colors.grey.shade400,
              child: Text(
                String.fromCharCode(65 + index),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _goToQuestion(int index) {
    setState(() {
      currentQuestionIndex = index;
      selectedAnswer = null;
    });
    _scrollToCurrentQuestion();
  }
}
