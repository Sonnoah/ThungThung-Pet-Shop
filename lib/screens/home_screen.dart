import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:thungthung/components/product/recommended_products.dart';
import 'package:thungthung/components/slider_img.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Image.asset(
                'app_logo/logo4.png',
                width: 120, 
              ),
            ),
            IconButton(
              onPressed: () {
                GoRouter.of(context).push('/search');
              }, 
              icon: Icon(
                Iconsax.search_normal_1, 
                color: const Color.fromRGBO(148, 98, 88, 1),
              )
            ),
          ],
        ),
      ),
      
      body: SingleChildScrollView(  
        child: Column(
          children: [
            SizedBox(
              height: 160, 
              child: SliderImg(),
            ),
            SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Iconsax.star4, size: 17,),
                          SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text('สินค้าแนะนำ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context).push('/product');
                        },
                        child: Row(
                          children: [
                            Text('ดูทั้งหมด', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color:const Color.fromRGBO(148, 98, 88, 1))),
                            SizedBox(width: 3),
                            Icon(Iconsax.arrow_right_3 , color: const Color.fromRGBO(148, 98, 88, 1)),
                          ],   
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 5),

                  RecommendedProducts(), 

                  SizedBox(height: 20),
                
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Iconsax.bag_2, size: 17),
                          SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text('หมวดหมู่สินค้า', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: (){
                          GoRouter.of(context).push('/product');
                        }, 
                        child: Row(
                          children: [
                            Text('ดูทั้งหมด', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color:const Color.fromRGBO(148, 98, 88, 1))),
                            SizedBox(width: 3),
                            Icon(Iconsax.arrow_right_3 , color: const Color.fromRGBO(148, 98, 88, 1)),
                          ],   
                        )
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 10),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: buildCategoryButton(
                            text: "อาหารสำหรับน้องหมา", 
                            onTap: () => GoRouter.of(context).push('/dog_food'), 
                            lottiePath: 'lottie/FjnPpAsyaW.json',
                          ),
                        ),

                        buildCategoryButton(
                          text: "อาหารสำหรับน้องแมว", 
                          onTap: () => GoRouter.of(context).push('/cat_food'), 
                          lottiePath: 'lottie/ccjZdvvg6J.json',
                        ),
                      ],
                    ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildCategoryButton({
    required String text, required VoidCallback onTap, required String lottiePath,
  }) {
  return Expanded(
    child: Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(250, 224, 164, 1),
        
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                lottiePath.isNotEmpty
                ? SizedBox(
                   height: 150,
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              child: Center(
                                child: Lottie.asset(lottiePath, fit: BoxFit.cover)),
                            ),
                          ],
                        ),
                )
                : Icon(Icons.pets, size: 30, color: Colors.brown),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          text,
            textAlign: TextAlign.center,
            style: TextStyle(
            color: const Color.fromARGB(255, 95, 64, 58),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            ),
        ),
      ],
    ),
  );
}
}