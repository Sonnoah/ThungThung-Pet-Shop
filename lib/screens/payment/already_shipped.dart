import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class AleradyShipped extends StatelessWidget {
  const AleradyShipped({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_2, color: Color.fromRGBO(148, 98, 88, 1)),
          onPressed: () => GoRouter.of(context).go('/cart'),
        ),
        title: Text('จัดส่งแล้ว', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: const [SizedBox(width: 5)],
      ),
      body: Center(child: Text('ยังไม่มีรายการ')),
    );
  }
}
