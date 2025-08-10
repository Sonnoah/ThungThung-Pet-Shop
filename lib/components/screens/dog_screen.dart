import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:thungthung/components/product/dog_product.dart';


class DogScreen extends StatefulWidget {
  const DogScreen({super.key});

  @override
  State<DogScreen> createState() => _DogScreenState();
}

class _DogScreenState extends State<DogScreen> {
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
              child: Text('สินค้าสำหรับน้องหมา',
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
      body: DogProduct(),
    );
  }
}