import 'package:flutter/material.dart';

class CircleBg extends StatelessWidget {
  const CircleBg({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1
          Positioned(
            top: -300, 
            left: -50,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(300), 
                color: const Color.fromRGBO(242, 205, 120, 150),
              ),
            ),
          ),
          // 2
          Positioned(
            top: -200,
            right: -200, 
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(250), 
                color: const Color.fromRGBO(242, 205, 120, 150),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
