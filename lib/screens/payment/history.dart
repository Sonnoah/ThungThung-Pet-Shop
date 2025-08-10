import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:thungthung/components/cart_provider.dart';
 // Import the CartProvider ที่คุณมี

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_2, color: Color.fromRGBO(148, 98, 88, 1)),
          onPressed: () => GoRouter.of(context).go('/user'),
        ),
        title: Text('เตรียมจัดส่ง', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          double totalPrice = 0;
          cartProvider.items.forEach((item) {
            totalPrice += item.productPrice * item.quantity;
          });

          return cartProvider.items.isEmpty
              ? Center(child: Text('ตะกร้าของคุณว่างเปล่า'))
              : ListView.builder(
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: Image.asset(item.productImg, width: 60, height: 60, fit: BoxFit.cover),

                        title: Text(item.productName, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        
                        subtitle: Text('ราคาต่อชิ้น: ฿${item.productPrice.toStringAsFixed(2)}\nจำนวน: ${item.quantity}'),
                        trailing: Text('฿${(item.productPrice * item.quantity).toStringAsFixed(2)}'),
                      ),
                    );
                  },
                );
        },
      ),);
  }
}
