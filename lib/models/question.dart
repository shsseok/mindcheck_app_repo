import 'package:mindcheck_app/models/answer.dart';

class Question {
  final int? id;
  final int categoryId;
  final String questionText;
  final DateTime? createdAt;
  final List<Answer>? answers; 
  Question({
    this.id,
    required this.categoryId,
    required this.questionText,
    this.createdAt,
    this.answers
  });

  factory Question.fromJson(Map<String,dynamic> json){
    final answerJson = json['answers'] as List<dynamic>?;
    return Question(
      id: json['id'],
      categoryId: json['category_id'],
      questionText: json['question_text'],
      createdAt: DateTime.parse(json['created_at']),
      answers: answerJson == null ? [] : answerJson.map((a) => Answer.fromJson(a)).toList()
    );
  }

   Map<String,dynamic> toMap(){
    return {
      'category_id': categoryId,
      'question_text': questionText,
    };
  }
}