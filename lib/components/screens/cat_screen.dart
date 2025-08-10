import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:thungthung/components/product/cat_product.dart';

class CatScreen extends StatefulWidget {
  const CatScreen({super.key});

  @override
  State<CatScreen> createState() => _CatScreenState();
}

class _CatScreenState extends State<CatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        elevation: 0,
         leading: IconButton(
         icon: Icon(Iconsax.arrow_left_2, color: Color.fromRGBO(148, 98, 88, 1)),
         onPressed: () {
           Navigator.of(context).pop();
        },
      ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text('สินค้าสำหรับน้องแมว',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
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
      body: CatProduct(),
    );
  }
}