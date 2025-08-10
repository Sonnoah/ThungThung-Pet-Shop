import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderImg extends StatefulWidget {
  const SliderImg({super.key});

  @override
  State<SliderImg> createState() => _SliderImgState();
}

class _SliderImgState extends State<SliderImg> {
  final List<String> imagePaths = [
    'assets/bill_board/1.png',
    'assets/bill_board/2.png',
    'assets/bill_board/3.png',
    'assets/bill_board/4.png',
  ];

  int myCurrentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.only(right:10,left: 10),
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              height: 150,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayInterval: const Duration(seconds: 10),
              autoPlayAnimationDuration: const Duration(seconds: 2),
                enlargeCenterPage: false, 
                viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  myCurrentIndex = index;
                });
              },
            ),
            items: imagePaths.map((path) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: double.infinity, 
                  height: double.infinity,
                  child: Image.asset(
                    path,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
