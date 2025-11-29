import 'package:flutter/material.dart';
import 'package:mindcheck_app/models/categories.dart';
import 'package:mindcheck_app/models/question.dart';
import 'package:mindcheck_app/screens/result_screen.dart';
import 'package:mindcheck_app/services/question_manege.dart';
import 'package:mindcheck_app/services/question_service.dart';
import 'package:mindcheck_app/services/user_answer_service.dart';

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
  late Future<Map<String, dynamic>> loadData;
  late Future<List<Question>> _qAList;
  Map<int,int?> selectedAnswerIds = {};
  @override
  void initState() {
    super.initState();
    _qAList = QuestionService().selectQuestionsAndAnswersByCategoryId(widget.category.id);
    _checkAndLoadProgress(widget.category.id);
  }

  Future<bool> _checkAndLoadProgress(int categoryId) async {


  final isOK = await QuestionManege.isTodayQuestionProgressing(widget.category.id);
  if (!isOK) {
    await QuestionManege.clearLocalStorageProgress(widget.category.id);
    setState(() {
      _pageController = PageController(initialPage: 0);
    });

    return false; // 오늘 설문은 새로 시작
  } else {
    // 오늘 진행 중이면 기존 데이터 불러오기
    final data = await QuestionManege.loadLocalStorageQuestionProgress(
      categoryId: widget.category.id,
    );

    setState(() {
      selectedAnswerIds = data['selectedAnswerIds'];
      currentIndex = data['currentIndex'];
      _pageController = PageController(initialPage: currentIndex);
    });

    return true; // 오늘 설문 진행 중
  }
  }
  void showSubmitDialog(Map<int,int?> selectedAnswerIds,String userId){
    showDialog(
          context: context, 
          builder: (context){
            return AlertDialog(
              title: const Text("답변 제출"),
              content: const Text("답변을 제출 하시겠습니까?"),
              actions: [
                TextButton(
                  onPressed: (){
                    print("답변 제출 아니오 선택");
                    Navigator.pop(context);
                  }, 
                  child: const Text("아니오"),
                  ),
                  ElevatedButton(
                  onPressed: () async{
                    print("답변 제출 예 선택");
                    Navigator.pop(context);
                    bool isSavedOk = await UserAnswerService().saveUserAnswers(selectedAnswerIds, userId);
                    if(isSavedOk){
                      if(context.mounted){
                        Navigator.pushReplacement(context, 
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(),
                         ));
                      }
                    }
                  }, 
                  child: const Text("네"), 
                  ),
              ],
            );
          }
        );
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
                              key: ValueKey(question.id),
                              children: answers!.map((a) {
                                final bool isSelectedAnswer = selectedAnswerIds[question.id] == a.id; 
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
                                    onPressed: ()  async {
                                      setState(() {
                                         if(selectedAnswerIds.containsKey(question.id)){                                         //이미 질문을 포함하고 같은 질문에 답했다면
                                          if(selectedAnswerIds[question.id] == a.id){                            
                                              selectedAnswerIds.remove(question.id);

                                          }else{                                                                               
                                              selectedAnswerIds[question.id!] = a.id;                                       
                                          }
                                      }else{                                      
                                          selectedAnswerIds[question.id!] = a.id;                                       
                                      }
                                      });                                   
                                      await QuestionManege.saveLocalStorageQuestionProgress(
                                        categoryId: widget.category.id,
                                        currentIndex: currentIndex,
                                        selectedAnswerIds: selectedAnswerIds,
                                      );
                                      bool isShowDialog = qAList.every((q) => selectedAnswerIds.containsKey(q.id));
                                      if(isShowDialog){
                                        showSubmitDialog(selectedAnswerIds,"f9912098-c73a-45fc-847b-e8871b3d33a0");
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
