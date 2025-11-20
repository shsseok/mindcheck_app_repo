
import 'package:supabase_flutter/supabase_flutter.dart';

class UserAnswerService {
   final supabase = Supabase.instance.client;

 Future<bool> saveUserAnswers(Map<int, int?> userAnswers, String userId) async {
    
  final List<Map<String, dynamic>> userListMap = userAnswers.entries.map((e) {
    return {
      'user_id': userId,
      'question_id': e.key,
      'answer_id': e.value,
    };
  }).toList();
    
    await supabase.from('user_answers')
          .insert(userListMap);
    return true;
 
 }
}