import 'package:flutter/material.dart';

import '../../core/theme/app_styles.dart';

class TopicCard extends StatelessWidget {
  final String topic;
  final String description;
  final int completedSections; // Jumlah bagian yang sudah selesai
  final int totalSections; // Jumlah total bagian
  
  const TopicCard({
    super.key,
    required this.topic,
    required this.description,
    required this.completedSections,
    required this.totalSections,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(topic, style: AppStyles.topicTitleStyle),
          const SizedBox(height: 4),
          Text(description, style: AppStyles.topicSectionStyle),
          const SizedBox(height: 4),
          _buildProgress(), // Memanggil _buildProgress
        ],
      ),
    );
  }

  // Membuat progress indicator
  Widget _buildProgress() {
    final double progress = completedSections / totalSections;

    return Row(
      children: [
        Text(
          '$completedSections of $totalSections Sections',
          style: AppStyles.sectionProgressStyle,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blue.shade700,
              minHeight: 6,
            ),
          ),
        ),
      ],
    );
  }
}
