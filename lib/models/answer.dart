class Answer {
  final int? id;
  final int questionId;
  final String answerText;
  final int score;
  final DateTime? createdAt;

  Answer({
    this.id,
    required this.questionId,
    required this.answerText,
    required this.score,
    this.createdAt,
  });


  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      questionId: json['question_id'],
      answerText: json['answer_text'],
      score: json['score'],
      createdAt: DateTime.parse(json['created_at'])
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question_id': questionId,
      'answer_text': answerText,
      'score': score,
    };
  }
}
