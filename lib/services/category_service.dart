import 'package:flutter/foundation.dart';
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
}