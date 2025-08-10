import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class RecommendedProducts extends StatefulWidget {
  const RecommendedProducts({super.key});

  @override
  State<RecommendedProducts> createState() => _RecommendedProductsState();
}

class _RecommendedProductsState extends State<RecommendedProducts> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    List<Map<String, dynamic>> products = [];

    QuerySnapshot catalogSnapshot = await _firestore.collection('catalog').get(); 

    for (var categoryDoc in catalogSnapshot.docs) {
      QuerySnapshot productSnapshot = await _firestore
          .collection('catalog')
          .doc(categoryDoc.id)
          .collection('product')
          .get();

      for (var productDoc in productSnapshot.docs) {
        var productData = productDoc.data() as Map<String, dynamic>;
        productData['id'] = productDoc.id;
        productData['categoryId'] = categoryDoc.id;  
        products.add(productData);
      }
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset('lottie/ccjZdvvg6J.json'),);
        }

        if (snapshot.hasError) {
          return Center(child: Text('เกิดข้อผิดพลาด'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('ไม่มีสินค้าแนะนำ'));
        }

        List<Map<String, dynamic>> products = snapshot.data!;

        return CarouselSlider.builder(
          options: CarouselOptions(
            height: 210,
            enableInfiniteScroll: true,
            autoPlayInterval: Duration(seconds: 3),
            viewportFraction: 0.45,
            scrollPhysics: BouncingScrollPhysics(),
          ),
          itemCount: products.length,
          itemBuilder: (context, index, realIndex) {
            var product = products[index];

            return InkWell(
              onTap: () {
                GoRouter.of(context).push(
                  '/product/${product['categoryId']}/${product['id']}'  
                );
              },
              child: Container(
                width: 280,
                margin: EdgeInsets.symmetric(horizontal: 5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(99, 201, 201, 201),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                      width: 160,
                      child: Image.asset(
                        product['img'] ?? '',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'] ?? 'ไม่ทราบชื่อสินค้า',
                            style: TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 3),
                          Text(
                            '฿ ${product['price'] ?? 'ไม่ทราบราคาสินค้า'}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(228, 95, 43, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
