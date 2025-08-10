import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:thungthung/components/cart_provider.dart'; 

class PromptPayScreen extends StatelessWidget {
  const PromptPayScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<CartProvider>(context);
    
    double totalPrice = cartProvider.items.fold(0, (sum, item) => sum + (item.productPrice * item.quantity));


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_2, color: Color.fromRGBO(148, 98, 88, 1)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('QR promptpay', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: const [SizedBox(width: 5)],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Image.asset(
                  'assets/payment/qrcode.png', 
                  width: 300,  
                  height: 300, 
                   ),
                  SizedBox(height: 20),
            
                Column(
                  children: [
                    Text(
                      '฿${totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(228, 95, 43, 1),
                      ),
                    ),
                
                     Padding(
                       padding: const EdgeInsets.symmetric(vertical: 10),
                       child: Column(
                         children: [
                           Text(
                            'บริษัท ถุงถุงเพ็ทช็อป จำกัด',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                           Text(
                            'ThungThungPetshop Co.,LTD',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                         ],
                       ),
                     ),
                  ],
                ),
                Divider(),
            
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(
                          'ยอดชำระ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ),
                        Text(
                          '฿${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(228, 95, 43, 1),
                          ),
                        ),
                       ],
                     ),
                   ),
                 ),
                Divider(),
                SizedBox(height: 20),
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
                    onPressed: () => GoRouter.of(context).pop(),
                    
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "ยกเลิก",
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
                    onPressed: () => GoRouter.of(context).go('/success'),
                    
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "ยืนยันการชำระเงิน",
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
