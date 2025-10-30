import 'package:mindcheck_app/services/ai_service.dart';
import 'package:mindcheck_app/services/category_service.dart';

class AppInit {
final _aiService = AiService();
final _categoryService = CategoryService();


Future<void> aiDataInit() async{
  final categories = await _categoryService.getCategoryList();
  for(final category in categories){
      await _aiService.generateDailyQuestionsIfNeeded(category.name);
  }
}


}