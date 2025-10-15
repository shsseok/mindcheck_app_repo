import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: const Text('MindCheck',
            style: TextStyle(
              fontFamily: 'Macondo',
              fontSize: 50,
            ),
            ),
            centerTitle: true,
            backgroundColor: Colors.black,
          ),
          body : Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/background_image.png'),
              fit: BoxFit.cover,
              ),
            ),
          ),
    );
  }
}