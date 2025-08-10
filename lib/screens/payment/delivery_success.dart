import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:thungthung/components/cart_provider.dart';

class DeliverySuccess extends StatelessWidget {
  const DeliverySuccess({super.key});

  @override
  Widget build(BuildContext context) {
     final cartProvider = Provider.of<CartProvider>(context);
    
    double totalPrice = cartProvider.items.fold(0, (sum, item) => sum + (item.productPrice * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: Text('ชำระเงิน', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: const [SizedBox(width: 50)],
        
      ),
      body:  Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 300,
                        width: 300,
                        child: Lottie.asset('assets/lottie/check.json', width:500, height: 500)),
                      Text('ชำระเงินปลายทาง', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),)
                    ],
                  ),
                ),
          Divider(),
          Column(
            children: [
            Padding(
             padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text(
                    'ยอดทั้งหมด',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '฿${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                 ],
               ),
             ),
           ),
          ],
          )
        ],
      ),
    ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Container(      
                  width: double.infinity,
                  margin: EdgeInsets.all(5),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                       shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                      side: BorderSide(color: Color.fromRGBO(148, 98, 88, 1)),
                      padding: EdgeInsets.symmetric(vertical: 15 , horizontal: 15),
                    ),
                    onPressed: () => GoRouter.of(context).go('/'),
                    
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "เลือกซื้อสินค้า",
                        style: TextStyle(fontSize: 18, color: Color.fromRGBO(148, 98, 88, 1)),
                      ),
                    ),
                  ),
                ),
                  Container(      
                  width: double.infinity,
                  margin: EdgeInsets.all(5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                       shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                      backgroundColor: Color.fromRGBO(233, 188, 133, 1),
                      padding: EdgeInsets.symmetric(vertical: 15 , horizontal: 15),
                    ),
                    onPressed: () => GoRouter.of(context).go('/user'),
                    
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "เสร็จสิน",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),   
    );
  }
}