import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/main_screen.dart'; // MainScreen 파일 import (경로에 맞게 수정)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // dotenv 초기화
  await dotenv.load(fileName: "assets/config/.env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  OpenAI.apiKey = dotenv.env['OPENAI_API_KEY']!;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
       home: MainScreen(), // 앱 시작 시 표시할 화면시작 시 MainScreen으로 이동
    );
  }
}
