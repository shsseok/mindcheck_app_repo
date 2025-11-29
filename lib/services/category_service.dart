import 'package:mindcheck_app/models/categories.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class CategoryService {
  final supabase = Supabase.instance.client;
  Future<Categories> getCategoryByName(String name) async{
    final response = await supabase
    .from('categories')
    .select()
    .eq('name', name)
    .maybeSingle();
    
    return Categories.fromMap(response!);
    
  }

  Future<List<Categories>> getCategoryList() async{
    final categories = await supabase
    .from('categories')
    .select();
    
    List<Categories> categoryList = [];
    for(final category in categories){
        categoryList.add(Categories(id: category['id'], name: category['name']));
    }
    return categoryList;
  }
   
    
  }
