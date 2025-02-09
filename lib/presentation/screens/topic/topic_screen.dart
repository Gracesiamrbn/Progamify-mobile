import 'package:flutter/material.dart';
import 'package:progamify/core/theme/app_styles.dart';

import '../../widgets/topic_card.dart';

class TopicsScreen extends StatelessWidget {
  TopicsScreen({super.key});

  // Menambahkan completedSections dan totalSections ke dalam topics
  final List<Map<String, dynamic>> topics = [
    {
      'title': 'Introduction',
      'totalSection': '10 SECTION',
      'completedSections': 5,
      'totalSections': 10
    },
    {
      'title': 'Data Types',
      'totalSection': '10 SECTION',
      'completedSections': 3,
      'totalSections': 10
    },
    {
      'title': 'Control Flows',
      'totalSection': '10 SECTION',
      'completedSections': 7,
      'totalSections': 10
    },
    {
      'title': 'Function',
      'totalSection': '10 SECTION',
      'completedSections': 6,
      'totalSections': 10
    },
    {
      'title': 'Object Oriented Programming',
      'totalSection': '10 SECTION',
      'completedSections': 8,
      'totalSections': 10
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Topics', style: AppStyles.titleStyle),
                SizedBox(height: 4),
                Text('CHOOSE A TOPIC TO LEARN TODAY !', style: AppStyles.instructionStyle),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _buildTopicCards(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTopicCards() {
    return topics
        .map((topic) => TopicCard(
              topic: topic['title']!,
              description: topic['totalSection']!,
              completedSections: topic['completedSections']!,
              totalSections: topic['totalSections']!,
            ))
        .toList();
  }
}
