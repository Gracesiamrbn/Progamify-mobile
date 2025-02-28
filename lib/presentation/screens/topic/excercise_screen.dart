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
  List<int> selectedAnswers = []; // Simpan jawaban user untuk multiple_answer
  final TextEditingController _essayController = TextEditingController();
  final TextEditingController _shortAnswerController = TextEditingController();

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
      'explanation': 'Iron is the answer',
      'exp': 15,
      'pts': 10,
      'type': 'multiple_choice'
    },
    {
      'question':
          'Jelaskan sejarah dan manfaat Flutter dalam pengembangan aplikasi mobile!',
      'type': 'essay',
      'explanation':
          'Flutter adalah framework open-source yang dikembangkan oleh Google...',
      'exp': 15,
      'pts': 10,
    },
    {
      'question': 'HTML is a programme language',
      'options': ['True', 'False'],
      'correctAnswer': 2,
      'explanation': 'Iron is the answer',
      'exp': 15,
      'pts': 10,
      'type': 'true_false'
    },
    {
      'question': 'Which of the following are programming languages?',
      'options': ['Python', 'HTML', 'Java', 'CSS'],
      'correctAnswers': [0, 2], // Index dari jawaban benar
      'explanation': 'Python dan Java adalah bahasa pemrograman',
      'exp': 15,
      'pts': 10,
      'type': 'multiple_answer'
    },
    {
      'question':
          'Jelaskan sejarah dan manfaat Flutter dalam pengembangan aplikasi mobile!',
      'type': 'shortAnswer',
      'explanation':
          'Flutter adalah framework open-source yang dikembangkan oleh Google...',
      'exp': 15,
      'pts': 10,
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
      'explanation': 'Iron is the answer',
      'exp': 15,
      'pts': 10,
      'type': 'multiple_choice'
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
      'explanation': 'Iron is the answer',
      'exp': 15,
      'pts': 10,
      'type': 'multiple_choice'
    },
    {
      'question': 'What is the hardest natural substance on Earth?',
      'options': ['Gold', 'Iron', 'Diamond', 'Platinum'],
      'correctAnswer': 2,
      'explanation': 'Iron is the answer',
      'exp': 15,
      'pts': 10,
      'type': 'multiple_choice'
    },
    {
      'question': 'What is the chemical symbol for gold?',
      'options': ['Go', 'Au', 'Ag', 'Gd'],
      'correctAnswer': 1,
      'explanation': 'Iron is the answer',
      'exp': 15,
      'pts': 10,
      'type': 'multiple_choice'
    },
    {
      'question': 'Which gas do plants use for photosynthesis?',
      'options': ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Hydrogen'],
      'correctAnswer': 2,
      'explanation': 'Iron is the answer',
      'exp': 15,
      'pts': 10,
      'type': 'multiple_choice'
    },
  ];

  Widget _buildEssayInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        TextField(
          controller: _essayController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Write the answer...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildShortAnswerInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        TextField(
          controller: _shortAnswerController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Write the answer...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

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
            GestureDetector(
              onTap: _showExitConfirmationDialog,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
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
                            ? Color(0xFF6FBAFF)
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
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            _buildOptions(),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed:
                      currentQuestionIndex > 0 ? _previousQuestion : null,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFFFFFFFF),
                  ),
                  label: const Text(
                    'Previous',
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentQuestionIndex > 0
                        ? Color(0xFF6FBAFF)
                        : Colors.grey[400],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: currentQuestionIndex < questions.length - 1
                      ? _nextQuestion
                      : _showSubmitDialog, // Panggil dialog jika soal terakhir
                  icon: Icon(
                      currentQuestionIndex < questions.length - 1
                          ? Icons.arrow_forward
                          : Icons.check,
                      color: const Color(
                          0xFFFFFFFF)), // Ubah ikon menjadi centang saat di soal terakhir
                  label: Text(
                    currentQuestionIndex < questions.length - 1
                        ? 'Next'
                        : 'Submit',
                    style: const TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentQuestionIndex < questions.length - 1
                        ? Color(0xFF6FBAFF)
                        : Colors.green, // Ubah warna tombol saat submit
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

  void _showSubmitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submit Quiz'),
          content: const Text('Are you sure you want to submit your answers?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _submitQuiz(); // Panggil fungsi submit
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _submitQuiz() {
    if (questions[currentQuestionIndex]['type'] == 'essay') {
      print("Jawaban Essay: ${_essayController.text}");
    } else if (questions[currentQuestionIndex]['type'] == 'shortAnswer') {
      print("Jawaban Short Answer: ${_shortAnswerController.text}");
    } else
      print("Quiz Submitted!");
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Want to Exit?  '),
          content: const Text(
              'Your progress will not be saved and you will not get the XP'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOptions() {
    final question = questions[currentQuestionIndex];
    final String type = question['type'];
    final options = question['options'] ?? []; // Pastikan options tidak null

    if (type == 'essay') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextField(
          maxLines: 5, // Biar textarea lebih besar
          decoration: InputDecoration(
            hintText: "Masukkan jawaban Anda...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    if (type == 'shortAnswer') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextField(
          maxLines: 1, // Biar textarea lebih besar
          decoration: InputDecoration(
            hintText: "Masukkan jawaban Anda...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }   

    if (options.isEmpty) {
      return const Text("No options available",
          style: TextStyle(color: Colors.red));
    }

    if (type == 'true_false') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(options.length, (index) {
          return _buildTrueFalseCard(index, options[index]);
        }),
      );
    } else if (type == 'multiple_answer') {
      return Column(
        children: List.generate(options.length, (index) {
          return _buildCheckboxOption(index, options[index]);
        }),
      );
    } else {
      return Column(
        children: List.generate(options.length, (index) {
          return _buildOptionCard(index, options[index]);
        }),
      );
    }
  }

  Widget _buildCheckboxOption(int index, String text) {
    bool isSelected = selectedAnswers.contains(index);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedAnswers.remove(index); // Hapus jika sudah dipilih
          } else {
            selectedAnswers.add(index); // Tambah jika belum dipilih
          }
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
            Checkbox(
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedAnswers.add(index);
                  } else {
                    selectedAnswers.remove(index);
                  }
                });
              },
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

  Widget _buildTrueFalseCard(int index, String text) {
    bool isSelected = selectedAnswer == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswer = index;
        });
      },
      child: Container(
        width: 165, // Ukuran kartu biar pas berdampingan
        height: 165,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.7) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
