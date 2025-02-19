import 'package:flutter/material.dart';

class QuestExcerciseScreen extends StatefulWidget {
  const QuestExcerciseScreen({super.key, required String title});

  @override
  _QuestExcerciseScreenState createState() => _QuestExcerciseScreenState();
}

class _QuestExcerciseScreenState extends State<QuestExcerciseScreen> {
  int? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Easy',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.yellow.shade700,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '30:00',
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
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
            const SizedBox(height: 10),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua...',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildOptionCard(0, 'Option 1', 'A'),
            _buildOptionCard(1, 'Option 2', 'B'),
            _buildOptionCard(2, 'Option 3', 'C'),
            _buildOptionCard(3, 'Option 4', 'D'),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed:
                  selectedOption != null ? _showConfirmationDialog : null,
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(int index, String text, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selectedOption == index
              ? Colors.blue.shade100
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selectedOption == index ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  selectedOption == index ? Colors.blue : Colors.grey.shade400,
              child: Text(
                label,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
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

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submit'),
          content: const Text('Are you sure you want to submit?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
