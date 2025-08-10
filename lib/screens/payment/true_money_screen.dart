import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:thungthung/components/cart_provider.dart';

class TrueMoneyScreen extends StatefulWidget {
  const TrueMoneyScreen({super.key});

  @override
  _TrueMoneyScreenState createState() => _TrueMoneyScreenState();
}

class _TrueMoneyScreenState extends State<TrueMoneyScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _submitPayment() {
    String phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty || phoneNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกหมายเลขโทรศัพท์ที่ถูกต้อง (10 หลัก)')),
      );
    } else {
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
        title: Text('TrueMoney', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: const [SizedBox(width: 5)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/payment/truemoney.png',  
              width: 300,  
              height: 300, 
            ),
            SizedBox(height: 20),
            Text(
              'ยอดชำระ: ฿${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: 'หมายเลขโทรศัพท์',
                      border: OutlineInputBorder(),
                      counterText: "",
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                 TextButton(
                  onPressed: _submitPayment,
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromRGBO(233, 188, 133, 1),
                    // Text color changed to red
                  ),
                  child: Text('Pay'),
                ),
              ],
            ),
            SizedBox(height: 20),
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
