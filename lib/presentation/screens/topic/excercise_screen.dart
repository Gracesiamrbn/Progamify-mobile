import 'package:flutter/material.dart';
import 'package:progamify/presentation/screens/topic/exercise_result_page.dart';

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
  List<Map<String, dynamic>> userAnswers = [];

  final List<Map<String, dynamic>> questions = [
    {
      'question':
          'Paradigma pemrograman manakah yang paling sesuai dengan konsep "menyusun fungsi-fungsi kecil yang dapat digunakan kembali tanpa memodifikasi data langsung"?',
      'options': [
        'Prosedural',
        'Fungsional',
        'Berorientasi Objek',
        'Deklaratif',
      ],
      'correctAnswer': 1,
      'explanation':
          'Paradigma fungsional berfokus pada fungsi matematika dan menghindari perubahan langsung pada data, sehingga kode lebih bersih dan minim bug.',
      'exp': 15,
      'pts': 10,
      'type': 'multiple_choice'
    },
    {
      'question':
          'Jelaskan perbedaan utama antara paradigma pemrograman prosedural dan berorientasi objek!',
      'type': 'essay',
      'explanation':
          'Paradigma prosedural berfokus pada instruksi yang dieksekusi secara berurutan, seperti langkah-langkah dalam resep masakan. Kode tersusun dalam bentuk fungsi yang dipanggil sesuai kebutuhan. Paradigma berorientasi objek mengorganisir kode ke dalam objek yang memiliki atribut (data) dan perilaku (metode). Ini memungkinkan kode lebih modular dan mudah dikelola..',
      'exp': 15,
      'pts': 10,
    },
    {
      'question':
          'Sebutkan satu bahasa pemrograman yang mendukung paradigma deklaratif!',
      'type': 'shortAnswer',
      'correctAnswer': 'Prolog',
      'explanation':
          'Prolog adalah contoh bahasa pemrograman deklaratif, di mana programmer hanya menyatakan "apa" yang diinginkan tanpa harus mendefinisikan "bagaimana" cara mencapainya.',
      'exp': 15,
      'pts': 10,
    },
    {
      'question':
          'SQL adalah contoh bahasa pemrograman yang menggunakan paradigma deklaratif.',
      'options': ['True', 'False'],
      'correctAnswer': 0,
      'explanation':
          'SQL bekerja dengan cara mendeklarasikan hasil yang diinginkan (misalnya, menampilkan data dari tabel) tanpa perlu menjelaskan bagaimana cara sistem mengambil data tersebut.',
      'exp': 15,
      'pts': 10,
      'type': 'true_false'
    },
    {
      'question':
          'Manakah bahasa pemrograman berikut yang mendukung paradigma berorientasi objek? (Pilih lebih dari satu)',
      'options': ['Python', 'Fortran', 'Java', 'C++'],
      'correctAnswers': [0, 2, 3], // Index dari jawaban benar
      'explanation':
          'Java, Python, dan C++ adalah bahasa yang mendukung paradigma berorientasi objek (OOP). Fortran lebih dikenal sebagai bahasa dengan paradigma prosedural.',
      'exp': 15,
      'pts': 10,
      'type': 'multiple_answer'
    },
    {
      'question':
          'Paradigma pemrograman yang cocok untuk pengolahan data besar dan berbasis AI adalah...',
      'options': ['Prosedural', 'Fungsional', 'Deklaratif', 'Konkuren'],
      'correctAnswer': 2,
      'explanation':
          'Paradigma deklaratif seperti Prolog sering digunakan dalam AI dan database, karena programmer hanya perlu mendeklarasikan aturan dan sistem akan menyelesaikan masalah secara otomatis.',
      'exp': 15,
      'pts': 10,
      'type': 'multiple_choice'
    },
    {
      'question':
          'Mengapa paradigma konkuren penting dalam pengembangan sistem modern seperti server web dan game multiplayer?',
      'type': 'essay',
      'correctAnswer':
          'Paradigma konkuren memungkinkan eksekusi banyak tugas secara bersamaan, meningkatkan efisiensi dan kecepatan sistem. Dalam server web dan game multiplayer, banyak permintaan harus diproses serentak agar pengguna tidak mengalami keterlambatan.',
      'explanation':
          'Paradigma konkuren memungkinkan eksekusi banyak tugas secara bersamaan, meningkatkan efisiensi dan kecepatan sistem. Dalam server web dan game multiplayer, banyak permintaan harus diproses serentak agar pengguna tidak mengalami keterlambatan.',
      'exp': 15,
      'pts': 10,
    },
    {
      'question': 'Apa yang dimaksud dengan paradigma pemrograman prosedural?',
      'type': 'essay',
      'correctAnswer':
          'Paradigma pemrograman prosedural adalah metode penulisan kode yang berfokus pada instruksi langkah demi langkah secara berurutan untuk menyelesaikan suatu masalah.',
      'explanation':
          'Paradigma pemrograman prosedural adalah metode penulisan kode yang berfokus pada instruksi langkah demi langkah secara berurutan untuk menyelesaikan suatu masalah.',
      'exp': 15,
      'pts': 10,
    },
    {
      'question':
          'Bahasa pemrograman Pascal hanya mendukung paradigma berorientasi objek.',
      'options': ['True', 'False'],
      'correctAnswer': 1,
      'explanation':
          'Pascal awalnya merupakan bahasa prosedural, tetapi versi yang lebih baru (seperti Object Pascal) juga mendukung paradigma berorientasi objek.',
      'exp': 15,
      'pts': 10,
      'type': 'true_false'
    },
    {
      'question':
          'Mana saja kelebihan paradigma fungsional dalam pemrograman? (Pilih lebih dari satu)',
      'options': [
        ' Kode lebih bersih dan mudah dipahami',
        'Minim bug karena tidak mengubah data langsung',
        'Lebih efisien daripada prosedural dalam semua kasus',
        'Dapat digunakan kembali tanpa efek samping'
      ],
      'correctAnswers': [0, 1, 3], // Index dari jawaban benar
      'explanation':
          'Java, Python, dan C++ adalah bahasa yang mendukung paradigma berorientasi objek (OOP). Fortran lebih dikenal sebagai bahasa dengan paradigma prosedural.',
      'exp': 15,
      'pts': 10,
      'type': 'multiple_answer'
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
      body: SingleChildScrollView(
        child: Padding(
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
                              ? const Color(0xFF6FBAFF)
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
              // const Spacer(),
              const SizedBox(height: 20),
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
                          ? const Color(0xFF6FBAFF)
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
                      backgroundColor:
                          currentQuestionIndex < questions.length - 1
                              ? const Color(0xFF6FBAFF)
                              : Colors.green, // Ubah warna tombol saat submit
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
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
          _saveUserAnswer(currentQuestionIndex, text); // Simpan jawaban user
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

  void _saveUserAnswer(int index, String answer) {
    if (userAnswers.length <= index) {
      userAnswers.add({'questionIndex': index, 'answer': answer});
    } else {
      userAnswers[index] = {'questionIndex': index, 'answer': answer};
    }
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(
            child: Text(
              'Submit',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Image.asset(
                'assets/icons/exit_icon.png',
                height: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                'Are you sure to submit the answer?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[300],
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (selectedAnswer != null) {
                  _saveUserAnswer(
                    currentQuestionIndex,
                    questions[currentQuestionIndex]['options'][selectedAnswer],
                  );
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExerciseResultScreen(
                            userAnswers: [],
                          )),
                );
              },
              child: const Text(
                'Yes, Quit',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(
            child: Text(
              'Want to Quit ?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Image.asset(
                'assets/icons/exit_icon.png',
                height: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                'Your progress will not be saved and you will not get the XP',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[300],
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
              child: const Text(
                'Yes, Quit',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
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
      return SizedBox(
        height: MediaQuery.of(context).size.height *
            0.5, // Maksimal 50% tinggi layar
        child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            return _buildCheckboxOption(index, options[index]);
          },
        ),
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
            Expanded(
              child: Center(
                // Membuat teks berada di tengah
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 16),
                  softWrap: true, // Agar teks tetap turun ke bawah jika panjang
                  overflow:
                      TextOverflow.visible, // Teks tetap terlihat jika panjang
                ),
              ),
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
        width: 142, // Ukuran kartu biar pas berdampingan
        height: 142,
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
