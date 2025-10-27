import 'package:supabase_flutter/supabase_flutter.dart';

class ResultRangeService{
    final supabase = Supabase.instance.client;

    Future<bool> saveResultRanges(List<Map<String,dynamic>> resultRangeMapList) async{
      return await supabase
      .from('result_range')
      .insert(resultRangeMapList);
    }
}