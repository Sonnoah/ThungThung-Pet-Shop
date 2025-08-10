import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:thungthung/components/show_bottom_sheet.dart';

class ProductDetailScreen extends StatefulWidget {
  final String categoryDocId;
  final String productId;

  const ProductDetailScreen({super.key, required this.categoryDocId, required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late PageController _pageController; 
  late Future<Map<String, dynamic>?> _productDetails;
  late ValueNotifier<int> _pageNotifier;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _productDetails = fetchProductDetails();
    _pageNotifier = ValueNotifier<int>(0); 
  }

  @override
  void dispose() {
    _pageController.dispose(); 
    _pageNotifier.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>?> fetchProductDetails() async {
    try {
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('catalog')
          .doc(widget.categoryDocId)
          .collection('product')
          .doc(widget.productId)
          .get();

      if (productDoc.exists) {
        return productDoc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
    future: _productDetails,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        String loadingAnimation;

        if (widget.categoryDocId == 'gNIXUJOvAYYPoOMD3oZw') {
          loadingAnimation = 'lottie/ccjZdvvg6J.json';
        } else if (widget.categoryDocId == 'BSwas1ZmvJBQTLa4hV4P') {
          loadingAnimation = 'lottie/FjnPpAsyaW.json';
        } else {
          loadingAnimation = 'lottie/v8eHpsafPx.json'; 
        }

        return Scaffold(
          appBar: AppBar(title: Text('รายละเอียดสินค้า')),
          body: Center(child: Lottie.asset(loadingAnimation)),
        );
      }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: Text('รายละเอียดสินค้า')),
            body: Center(child: Text('ไม่พบข้อมูลสินค้า')),
          );
        }

        var product = snapshot.data!;

        List<String> images = [];
        if (product['img'] != null) images.add(product['img']);
        if (product['info_img'] != null) images.add(product['info_img']);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Iconsax.arrow_left_2, color: Color.fromRGBO(148, 98, 88, 1)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('รายละเอียด', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            actions: const [
              SizedBox(width: 50,)
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (images.isNotEmpty)
                    Column(
                      children: [
                        CarouselSlider(
                          items: images.map((image) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Image.asset(
                                  image,
                                  fit: BoxFit.cover,
                                  height: 300,
                                );
                              },
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 300,
                            enlargeCenterPage: true,
                            viewportFraction: 0.8,
                            onPageChanged: (index, reason) {
                              _pageNotifier.value = index; 
                            },
                          ),
                        ),
                        ValueListenableBuilder<int>(
                      valueListenable: _pageNotifier,
                      builder: (context, pageIndex, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${pageIndex + 1} / ${images.length}',
                              style: TextStyle(fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                  SizedBox(height: 15),
                  Text(
                    product['name'] ?? 'ไม่ทราบชื่อสินค้า',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 5),
                  Text(
                    '฿ ${product['price'] ?? 'ไม่ทราบราคาสินค้า'}',
                    style: TextStyle(fontSize: 20, color: const Color.fromRGBO(228, 95, 43, 1)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Text('คงเหลือ', style: TextStyle(fontSize: 12)),
                            SizedBox(width: 10),
                            Text(
                              product['stock'] ?? 'หมด',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text('รหัสสินค้า', style: TextStyle(fontSize: 12)),
                          SizedBox(width: 10),
                          Text(
                            product['product_code'] ?? 'ไม่มีรายละเอียดสินค้า',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(height: 10),
                  SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('รายละเอียดสินค้า', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                      Column(
                        children: [
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('แบนด์'),
                              Text(product['band'] ?? 'ไม่ทราบรายละเอียด'),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('น้ำหนัก'),
                              Text(product['weight'] ?? 'ไม่มีรายละเอียดสินค้า'),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('ช่วงอายุ'),
                              Text(product['age'] ?? 'ไม่มีรายละเอียดสินค้า'),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('ความต้องการเฉพาะทาง'),
                              Text(product['size'] ?? 'ไม่มีรายละเอียดสินค้า'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1, 
                        child: IconButton(onPressed: () => GoRouter.of(context).go('/chat'),  
                          icon: Column(
                            children: [
                              Icon(Iconsax.chart, color: const Color.fromRGBO(148, 98, 88, 1)),
                              Text('แชท', style: TextStyle(color: const Color.fromRGBO(148, 98, 88, 1), fontSize: 12))
                            ],
                          )
                        ),
                      ),
                      Expanded(
                        flex: 1, 
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context, 
                              builder: (BuildContext context) {
                                return ShowBottomSheet(
                                  productName: product['name'] ?? '',
                                  productPrice: product['price'] ?? '',
                                  productImg: product['img'] ?? '',
                                  productStock: product['stock'] ?? '', 
                                  buttonText: 'เพิ่มลงตะกร้า',  
                                );
                              }
                            );
                          },  
                          icon: Column(
                            children: [
                              Icon(Iconsax.shopping_cart, color: const Color.fromRGBO(148, 98, 88, 1)),
                              Text('เพิ่มลงตะกร้า', style: TextStyle(color: const Color.fromRGBO(148, 98, 88, 1), fontSize: 12))
                            ],
                          )
                        ),
                      ),
                      Expanded(
                        flex: 2, 
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            backgroundColor: const Color.fromRGBO(233, 188, 133, 1),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context, 
                              builder: (BuildContext context) {
                                return ShowBottomSheet(
                                  productName: product['name'] ?? '',
                                  productPrice: product['price'] ?? '',
                                  productImg: product['img'] ?? '',
                                  productStock: product['stock'] ?? '', 
                                  buttonText: 'ซื้อสินค้า',  
                                );
                              }
                            );
                          }, 
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Text('ซื้อสินค้า', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
