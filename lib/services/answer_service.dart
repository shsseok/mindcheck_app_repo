import 'package:supabase_flutter/supabase_flutter.dart';

class AnswerService {
final supabase = Supabase.instance.client;
Future<bool> saveAnswers(List<Map<String,dynamic>> answers) async {
     try {
      final response = await supabase.from('answers').insert(answers);
      // 에러가 없으면 true 반환
      return true;
    } catch (e) {
      print('❌ 답변 저장 실패: $e');
      return false;
    }
}
}
