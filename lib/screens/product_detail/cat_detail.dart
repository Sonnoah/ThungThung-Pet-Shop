import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CatDetail extends StatelessWidget {
  final String productId;

  const CatDetail({super.key, required this.productId});

  Future<Map<String, dynamic>> fetchProductDetails() async {
    DocumentSnapshot productDoc = await FirebaseFirestore.instance
        .collection('catalog')
        .doc('gNIXUJOvAYYPoOMD3oZw') 
        .collection('product')
        .doc(productId)  
        .get();

    return productDoc.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchProductDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('เกิดข้อผิดพลาด'));
        }

        if (!snapshot.hasData) {
          return Center(child: Text('ไม่พบข้อมูลสินค้า'));
        }

        var product = snapshot.data!;

        return Scaffold(
          appBar: AppBar(

          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  product['img'] ?? '', 
                  fit: BoxFit.cover,
                  height: 200,
                ),
                SizedBox(height: 10),
                Text(
                  product['name'] ?? 'ไม่ทราบชื่อสินค้า',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '฿ ${product['price'] ?? 'ไม่ทราบราคาสินค้า'}',
                  style: TextStyle(fontSize: 20, color: Colors.orange),
                ),
                SizedBox(height: 10),
                Text(
                  product['description'] ?? 'ไม่มีรายละเอียดสินค้า',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}