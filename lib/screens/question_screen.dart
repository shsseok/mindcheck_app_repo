import 'package:flutter/material.dart';
import 'package:mindcheck_app/models/categories.dart';
import 'package:mindcheck_app/models/question.dart';
import 'package:mindcheck_app/services/question_service.dart';

class QuestionScreen extends StatefulWidget {
  final Categories category;
  const QuestionScreen({
    super.key,
    required this.category,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int currentIndex = 0;
  late PageController _pageController;
  late Future<List<Question>> _qAList;
  Map<int,int?> selectedAnswerIds = {};
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _qAList =
        QuestionService().selectQuestionsAndAnswersByCategoryId(widget.category.id);
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
            image: AssetImage('assets/images/background_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Stack(
                  children: [
                  LinearProgressIndicator(
                    value: (selectedAnswerIds.length / 10),
                    backgroundColor: Colors.brown.withOpacity(0.5),
                    color: Colors.blueAccent.withOpacity(0.5),
                    minHeight: 40,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  AnimatedAlign(
                    alignment: Alignment((selectedAnswerIds.length / 10)*2-1, 0), 
                    duration: const Duration(microseconds: 10),
                    child: Image.asset('assets/images/bike.png',width: 33,),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                // 🔹 질문 + 답변 표시하는 FutureBuilder 하나만 사용
                Expanded(
                  child: FutureBuilder<List<Question>>(
                    future: _qAList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text("에러 발생: ${snapshot.error}"));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("질문이 없습니다."));
                      }

                      final qAList = snapshot.data!;
                      final question = qAList[currentIndex];
                      final answers = question.answers;
                      return Column(
                        children: [
                          // 🟡 질문 카드
                          SizedBox(
                            height: 200,
                            child: PageView.builder( 
                              controller: _pageController,
                              itemCount: qAList.length,
                              onPageChanged: (index) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                final q = qAList[index];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 0.3,
                                  color: Colors.amber.withOpacity(0.2),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        q.questionText,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          // 🟢 답변 버튼 (애니메이션으로 전환)
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (child, animation) => FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                            child: Column(
                              key: ValueKey(currentIndex),
                              children: answers!.map((a) {
                                final bool isSelectedAnswer = selectedAnswerIds[currentIndex] == a.id; 
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          isSelectedAnswer ? Colors.amber.shade50 : Colors.black.withOpacity(0.5),
                                      minimumSize:
                                          const Size(double.infinity, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    onPressed: () {
                                      if(selectedAnswerIds.containsKey(currentIndex)){
                                          //이미지 질문을 포함하고 같은 질문에 답했다면
                                          if(selectedAnswerIds[currentIndex] == a.id){                            
                                             setState(() {
                                              selectedAnswerIds.remove(currentIndex);
                                            });
                                          }else{                                            
                                            setState(() {
                                              selectedAnswerIds.remove(currentIndex);
                                              selectedAnswerIds[currentIndex] = a.id;
                                            });
                                          }
                                      }else{
                                        setState(() {
                                          selectedAnswerIds[currentIndex] = a.id;
                                        });
                                      }
                                    },
                                    child: Text(
                                      a.answerText,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
