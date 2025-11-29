class UserAnswer {
  final String userId;
  final int questionId;
  final int answerId;

  UserAnswer({
    required this.userId,
    required this.questionId,
    required this.answerId,
  });

  factory UserAnswer.fromMap(Map<String, dynamic> map) {
    return UserAnswer(
      userId: map['user_id'],
      questionId: map['question_id'],
      answerId: map['answer_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'question_id': questionId,
      'answer_id': answerId,
    };
  }
}
