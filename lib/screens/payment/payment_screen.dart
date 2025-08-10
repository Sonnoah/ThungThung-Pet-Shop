import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:thungthung/screens/payment/cash_on_delivery_screen.dart';
import 'package:thungthung/screens/payment/credit_card_screen.dart';
import 'package:thungthung/screens/payment/prompt_pay_screen.dart';
import 'package:thungthung/screens/payment/true_money_screen.dart';


class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int? selectedPaymentMethod = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_2, color: Color.fromRGBO(148, 98, 88, 1)),
          onPressed: () => GoRouter.of(context).go('/cart'),
        ),
        title: Text('ชำระเงิน', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: const [SizedBox(width: 50)],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                paymentOption(0, "QR PromptPay", "", "assets/payment/PromptPay-logo.png"),
                paymentOption(1, "เก็บเงินปลายทาง", "", "assets/payment/Cash.png"),
                // paymentOption(2, "บัตรเครดิต/บัตรเดบิต", "", "assets/payment/creditcard.png"),
                // paymentOption(3, "True Money", "", "assets/payment/truemoney.png"),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Divider(),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(16),
                  child: Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Color.fromRGBO(233, 188, 133, 1),
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      ),
                      onPressed: () {
                        if (selectedPaymentMethod != null) {
                          switch (selectedPaymentMethod) {
                            case 0:
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PromptPayScreen()),
                              );
                              break;
                            case 1:
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CashOnDeliveryScreen()),
                              );
                              break;
                            case 2:
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CreditCardScreen()),
                              );
                              break;
                            case 3:
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TrueMoneyScreen()),
                              );
                              break;
                            default:
                              break;
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          "ยืนยัน",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
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

  Widget paymentOption(int value, String title, String subtitle, String assetPath) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),),
      child: RadioListTile<int>(
        value: value,
        groupValue: selectedPaymentMethod,
        onChanged: (int? newValue) {
          setState(() {
            selectedPaymentMethod = newValue;
          });
        },
        title: Row(
          children: [
            Image.asset(assetPath, width: 60, height: 60),
            SizedBox(width: 10),
            Text(title),
          ],
        ),
        subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
        activeColor: Color.fromRGBO(233, 188, 133, 1),
      ),
    );
  }
}
