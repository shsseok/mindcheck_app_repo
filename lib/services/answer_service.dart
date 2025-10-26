import 'package:supabase_flutter/supabase_flutter.dart';

class AnswerService {
final supabase = Supabase.instance.client;
Future<bool> saveAnswers(List<Map<String,dynamic>> answers) async {
  return await supabase
  .from('answers')
  .insert(answers);
}
}
