import 'package:flutter/material.dart';
import 'package:mindcheck_app/widgets/my_card.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

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
          child: Column(
            children: [
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "소극적 연애 타입 입니다",
                  style: TextStyle(
                    fontFamily: 'Macondo',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber),
                  ),
                  ]
                ),
                Column(
                  children: [
                    MyCard(
                    borderRadius: 16,
                    backgroundColor: Colors.black,
                    content: "소극적 연애",
                    ),
                    ElevatedButton(
                      onPressed: (){
                        print("공유하기 기능");
                      } 
                    ,child: Text("공유하기"))
                  ],
                )
            ],
          ),
        ),
        ),
        
    );
  }
}