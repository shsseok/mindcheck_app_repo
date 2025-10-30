import 'package:flutter/material.dart';
import 'package:mindcheck_app/models/categories.dart';
import 'package:mindcheck_app/services/category_service.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

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
        child: Center(
          child: SafeArea(
            child: FutureBuilder<List<Categories>>(
              future: CategoryService().getCategoryList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // 데이터 로딩 중
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // 에러 발생 시
                  return Text('오류: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // 데이터 없음
                  return const Text('카테고리가 없습니다.');
                }

                final categories = snapshot.data!;

                return GridView.count(
                  padding: const EdgeInsets.all(60),
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: categories.map((category) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(10),
                      ),
                      onPressed: () {
                        print('${category.name} 클릭됨');
                      },
                      child: Text(
                        category.name,
                        style: const TextStyle(
                          fontFamily: 'Macondo',
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
