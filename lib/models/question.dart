class Question {
  final int? id;
  final int categoryId;
  final String questionText;
  final DateTime? createdAt;

  Question({
    this.id,
    required this.categoryId,
    required this.questionText,
    this.createdAt,
  });

  factory Question.fromJson(Map<String,dynamic> json){
    return Question(
      id: json['id'],
      categoryId: json['category_id'],
      questionText: json['question_text'],
      createdAt: DateTime.parse(json['created_at'])
    );
  }

   Map<String,dynamic> toMap(){
    return {
      'category_id': categoryId,
      'question_text': questionText,
      'created_at': createdAt!.toIso8601String(),
    };
  }
}