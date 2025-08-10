import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:thungthung/components/cart_provider.dart';

class CreditCardScreen extends StatefulWidget {
  const CreditCardScreen({super.key});

  @override
  _CreditCardScreenState createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {
  final TextEditingController _cardNumberController = TextEditingController();

  void _submitPayment() {
    String cardNumber = _cardNumberController.text.trim();

    if (cardNumber.isEmpty || cardNumber.length < 13 || cardNumber.length > 16) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกหมายเลขบัตรเครดิตที่ถูกต้อง (13-16 หลัก)')),
      );
    } else {
      // ไปยังหน้าสำเร็จหลังจากกรอกบัตรถูกต้อง
      GoRouter.of(context).push('/success');
    }
  }

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
        title: Text('ชำระเงินด้วยบัตรเครดิต', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: const [SizedBox(width: 5)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/payment/creditcard.png',  // Replace with the correct path to your image
              width: 300,  // You can adjust the width as needed
              height: 300, // You can adjust the height as needed
               ),
              SizedBox(height: 20),
            // แสดงยอดรวม
            Text(
              'ยอดชำระ: ฿${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            

            // ช่องกรอกเลขบัตรเครดิต + ปุ่ม Pay
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cardNumberController,
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    decoration: InputDecoration(
                      labelText: 'หมายเลขบัตรเครดิต',
                      border: OutlineInputBorder(),
                      counterText: "",
                      prefixIcon: Icon(Icons.credit_card),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _submitPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(233, 188, 133, 1),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  child: Text('Pay', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),

            SizedBox(height: 20),

            // ปุ่ม ยืนยัน/ยกเลิก
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _submitPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(233, 188, 133, 1),
                    shadowColor: Colors.transparent,
                  ),
                  child: Text("ยืนยันการชำระ", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 40),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color.fromRGBO(148, 98, 88, 1)),
                  ),
                  child: Text("ยกเลิก", style: TextStyle(color: Color.fromRGBO(148, 98, 88, 1))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
