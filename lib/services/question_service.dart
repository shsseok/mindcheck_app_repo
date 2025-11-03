import 'package:mindcheck_app/models/question.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuestionService {
final supabase = Supabase.instance.client;

Future<bool> hasTodayQuestionsByCategoryId(int categoryId) async {
   final today = DateTime.now().toUtc();
   final startOfDay = DateTime.utc(today.year, today.month, today.day);
   final endOfDay = startOfDay.add(const Duration(days: 1));

  final response = await supabase
    .from('questions')
    .select()
    .eq('category_id', categoryId)
    .gte('created_at', startOfDay.toIso8601String())
    .lt('created_at', endOfDay.toIso8601String());

    return response.isNotEmpty;
  }

Future<int> saveQuestion(Map<String,dynamic> question) async {
  final insertedQuestion = await supabase
  .from('questions')
  .insert(question)
  .select()
  .single();

  return insertedQuestion['id'];
}

Future<List<Question>> selectQuestions(categoryId) async {
  final today = DateTime.now().toUtc();
  final startOfDay = DateTime.utc(today.year, today.month, today.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));
  final selectQuestions =  await supabase
  .from('questions')
  .select()
  .eq('category_id', categoryId)
  .gte('created_at', startOfDay.toIso8601String())
  .lt('created_at', endOfDay.toIso8601String());

  List<Question> questionList = [];
  for(final question in selectQuestions){
    questionList.add(Question.fromJson(question));
  }

  return questionList;
}

Future<List<Question>> selectQuestionsAndAnswersByCategoryId(categoryId) async {
  final today = DateTime.now().toUtc();
  final startOfDay = DateTime.utc(today.year, today.month, today.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));
  final selectQuestionsAndAnswers =  await supabase
  .from('questions')
  .select('*,answers(*)') //answers 테이블과 조인하여 관련 질문당 답변들 모두 조인
  .eq('category_id', categoryId)
  .gte('created_at', startOfDay.toIso8601String())
  .lt('created_at', endOfDay.toIso8601String());

  List<Question> questionAndAnswersList = [];
  for(final question in selectQuestionsAndAnswers){
    questionAndAnswersList.add(Question.fromJson(question));
  }

  return questionAndAnswersList;
}

}
