import 'package:flutter/material.dart';
import 'package:mindcheck_app/models/categories.dart';
import 'package:mindcheck_app/models/question.dart';
import 'package:mindcheck_app/services/question_service.dart';

class QuestionScreen extends StatefulWidget {
  final Categories category;
  const QuestionScreen(
    {
      super.key,
      required this.category
    }
  );

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int currentIndex = 0;
  late PageController _pageController;
  late Future<List<Question>> _qAList;
  @override
  void initState(){
    super.initState();
     _pageController = PageController(initialPage: 0);
      _loadQuestionsAndAnswers(widget.category.id);
  }

  void _loadQuestionsAndAnswers(categoryId) async{
    _qAList = QuestionService().selectQuestionsAndAnswersByCategoryId(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'MindCheck',
          style: TextStyle(
            fontFamily: 'Macondo',
            fontSize: 36,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image : AssetImage('assets/images/background_image.png'),
            fit: BoxFit.cover,
            ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: 1/10,
                  backgroundColor: Colors.amber,
                  color: Colors.black,
                  minHeight: 20,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 16,),
                FutureBuilder<List<Question>>(
                  future: _qAList,
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                    }
                    final qAList = snapshot.data!;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
}
}