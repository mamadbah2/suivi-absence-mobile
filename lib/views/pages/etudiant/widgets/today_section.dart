import 'package:flutter/material.dart';
import 'course_card.dart';

class TodaySection extends StatelessWidget {
  final List<Map<String, String>> courses;

  const TodaySection({Key? key, required this.courses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Aujourd'hui",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        ...courses.map(
          (course) => CourseCard(
            title: course['title']!,
            type: course['type']!,
            date: course['date']!,
            time: course['time']!,
            isJustified: course['isJustified'] == 'true',
          ),
        ),
      ],
    );
  }
}
