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

    static Future<void> loadLocalStorageQuestionProgress({
    required int categoryId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
      
  
  }

}
