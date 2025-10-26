import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mindcheck_app/models/question.dart';
import 'package:mindcheck_app/services/category_service.dart';
import 'package:mindcheck_app/services/question_service.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:mindcheck_app/utils/prompt_template.dart';
import 'supabase_service.dart';
class AiService {
  final QuestionService _questionService = QuestionService();
  final CategoryService _categoryService = CategoryService();
 ///  오늘 질문 존재 여부 확인 → 없으면 새로 생성
  Future<void> generateDailyQuestionsIfNeeded(String categoryName) async {
    final today = DateTime.now().toIso8601String().substring(0,10);

    // 1️⃣ Supabase에서 오늘 질문 존재 여부 확인
    final isQuesions = await _questionService.hasTodayQuestions();

    if (isQuesions) {
      print('오늘 질문이 이미 존재합니다. 새로 생성하지 않습니다.');
      return;
    }

    print('⚙️ 오늘 질문이 없습니다. AI를 통해 생성을 시작합니다...');

    // 2️⃣ OpenAI 호출하여 새 질문 생성
    final aiResponse = await OpenAI.instance.chat.create(
      model: "gpt-4o-mini",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.system,
          content:
             [OpenAIChatCompletionChoiceMessageContentItemModel.text(PromptTemplate.generatePrompt(categoryName))],
        ),
      ],
      maxTokens: 2000,
    );
  
    final responseText =
        aiResponse.choices.first.message.content?.first.text ?? '';

    print('🧠 AI 생성 결과: $responseText');

    final aiResponseData = jsonDecode(responseText);
    
    final questionJsonList = aiResponseData['questions'] as List;
    final category = await _categoryService.getCategoryByName(categoryName);
    List<Map<String,dynamic>> questionMapList =[];
    for(final question in questionJsonList){
      questionMapList.add(Question(categoryId: category.id, questionText: question['question']).toMap());
    }
    _questionService.saveQuestions(questionMapList);
  }

}