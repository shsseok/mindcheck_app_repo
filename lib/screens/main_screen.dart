import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'title': '연애', 'color': Colors.pinkAccent},
      {'title': '성격', 'color': Colors.blueAccent},
      {'title': '우정', 'color': Colors.greenAccent},
      {'title': '회사생활', 'color': Colors.orangeAccent},
    ];

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
        child: Center(
          child: SafeArea(
            child: GridView.count(
              padding: const EdgeInsets.all(60),
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: categories.map((category) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: category['color'].withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(10),
                  ),
                  onPressed: () {
                    // TODO: 카테고리 클릭 시 이동할 페이지 연결
                    print('${category['title']} 클릭됨');
                  },
                  child: Text(
                    category['title'],
                    style: const TextStyle(
                      fontFamily: 'Macondo',
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
