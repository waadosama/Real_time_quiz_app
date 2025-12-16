import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  final String id;
  final String name;
  final DateTime? date;
  final String duration;
  final String? description;
  final int questionsCount;
  final bool showFinalScore;

  QuizModel({
    required this.id,
    required this.name,
    this.date,
    this.duration = '30 min',
    this.description,
    this.questionsCount = 0,
    this.showFinalScore = true,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json, {required String id}) {
    DateTime? parsedDate;
    final rawDate = json['date'];
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is String && rawDate.isNotEmpty) {
      // Try to parse ISO or fallback dd/MM/yyyy
      try {
        parsedDate = DateTime.parse(rawDate);
      } catch (_) {
        try {
          parsedDate = DateFormat('dd/MM/yyyy').parse(rawDate);
        } catch (_) {}
      }
    }

    // Handle different professor app schema keys:
    // - name/title
    // - duration stored as int minutes or string like "30 min"
    final rawName = json['name'] ?? json['title'];
    final dynamic rawDuration = json['duration'];
    String durationString;
    if (rawDuration is int) {
      durationString = '${rawDuration.toString()} min';
    } else if (rawDuration is String && rawDuration.isNotEmpty) {
      durationString = rawDuration;
    } else {
      durationString = '30 min';
    }

    final questions = (json['questions'] as List<dynamic>?) ?? const [];
    final questionsCount = questions.length;
    final showFinalScore = json['showFinalScore'] as bool? ?? true;

    return QuizModel(
      id: id,
      name: (rawName as String?) ?? '',
      date: parsedDate,
      duration: durationString,
      description: json['description'] as String?,
      questionsCount: questionsCount,
      showFinalScore: showFinalScore,
    );
  }
}
