import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class QuestionManege {
 
  static String _indexKey(int categoryId) => 'currentQuestionIndex_$categoryId';
  static String _answersKey(int categoryId) => 'selectedAnswerIds_$categoryId';
  
  static Future<void> saveLocalStorageQuestionProgress({
    required int categoryId,
    required int currentIndex,
    required Map<int, int?> selectedAnswerIds,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    final json = jsonEncode(selectedAnswerIds.map((key,value) => MapEntry(key.toString(), value)));
    await prefs.setInt(_indexKey(categoryId), currentIndex);
    await prefs.setString(_answersKey(categoryId), json);
  }

  static Future<Map<String, dynamic>> loadLocalStorageQuestionProgress({
    required int categoryId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final currentIndex = prefs.getInt(_indexKey(categoryId)) ?? 0;  

    final answerString = prefs.getString(_answersKey(categoryId));
    Map<int,int?> selectedAnswerIds = {};
    if(answerString != null){
       final Map<String,dynamic> jsonMap = jsonDecode(answerString);
       selectedAnswerIds = jsonMap.map((key,value) => MapEntry(int.parse(key), value as int?));    
    }    

    return {
      'currentIndex' : currentIndex,
      'selectedAnswerIds' : selectedAnswerIds,
    };                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  
  }

   static Future<bool> hasProgress({
    required int categoryId
   }) async{
    final prefs = await SharedPreferences.getInstance();
    
    final hasIndex = prefs.containsKey(_indexKey(categoryId));
    final hasAnswers = prefs.containsKey(_answersKey(categoryId));
    if(hasIndex || hasAnswers){
      return true;
    }
    return false;
   }

}
