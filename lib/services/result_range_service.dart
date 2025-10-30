import 'package:supabase_flutter/supabase_flutter.dart';

class ResultRangeService{
    final supabase = Supabase.instance.client;

    Future<bool> saveResultRanges(List<Map<String,dynamic>> resultRangeMapList) async{
    try{
      await supabase
      .from('result_ranges')
      .insert(resultRangeMapList);
        return true;
    } catch (e) {
      print('❌ 결과 저장 실패: $e');
      return false;
    }
    }
}