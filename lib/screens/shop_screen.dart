import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:thungthung/components/product/all_product.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
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
      body: AllProduct(),
    );
  }
}