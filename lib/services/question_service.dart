import 'package:supabase_flutter/supabase_flutter.dart';

class QuestionService {
final supabase = Supabase.instance.client;

Future<bool> hasTodayQuestions() async {
   final today = DateTime.now().toUtc();
   final startOfDay = DateTime.utc(today.year, today.month, today.day);
   final endOfDay = startOfDay.add(const Duration(days: 1));

  final response = await supabase
    .from('questions')
    .select()
    .gte('created_at', startOfDay.toIso8601String())
    .lt('created_at', endOfDay.toIso8601String());

    return response.isNotEmpty;
  }

Future<bool> saveQuestions() async {
  await supabase
  .from('questions')
  .insert(values)
}
}
