import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:thungthung/components/cart_provider.dart';
import 'package:thungthung/screens/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ตะกร้าสินค้า',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),

      body: Consumer<CartProvider>(builder: (context, cartProvider, child) {
          if (cartProvider.items.isEmpty) {
          cartProvider.loadCartFromFirestore();
        }
          final cartItems = cartProvider.items;
          double totalPrice = cartItems.fold(
              0, (sum, item) => sum + (item.productPrice * item.quantity));

          return cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('lottie/ccjZdvvg6J.json'),
                      Text('ไม่มีสินค้าในตะกร้า'),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: Image.asset(item.productImg),
                              title: Text(
                                item.productName,
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w800),
                                textAlign: TextAlign.justify,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "฿ ${item.productPrice.toStringAsFixed(2)}"),
                                    Text('x ${item.quantity.toString()}'),
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Iconsax.trash),
                                onPressed: () {
                                  cartProvider.removeFromCart(item);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 16),
                      child: Column(
                        children: [
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 50, top: 10),
                                child: Text(
                                  'รวมทั้งหมด: ฿${totalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(
                                          255, 0, 0, 0)),
                                ),
                              ),
                              SizedBox(width: 30),
                              Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor:
                                        const Color.fromRGBO(233, 188, 133, 1),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                  ),
                                  onPressed: cartItems.isNotEmpty
                                      ? () {
                                          if (FirebaseAuth
                                                  .instance.currentUser ==
                                              null) {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AlertDialog(
                                                title: Text(
                                                  "กรุณาเข้าสู่ระบบ",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                content: Text(
                                                    "คุณต้องเข้าสู่ระบบก่อนทำการชำระเงิน"),
                                                actions: [
                                                  Row(
                                                    children: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          GoRouter.of(context)
                                                              .push('/login');
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Color.fromRGBO(233,188,133,1),
                                                                shadowColor: Colors.transparent),
                                                        child: Text("เข้าสู่ระบบ",
                                                            style: TextStyle(
                                                                color: Color.fromRGBO(255,255,255,1))),
                                                      ),
                                                      SizedBox(width: 10),
                                                      OutlinedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          GoRouter.of(context)
                                                              .push(
                                                                  '/register');
                                                        },
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                                side: BorderSide(
                                                                    color: Color.fromRGBO(148,98,88,1))),
                                                        child: Text("ลงทะเบียน",
                                                            style: TextStyle(
                                                                color: Color.fromRGBO(148,98,88,1))),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CheckoutScreen(
                                                        cartItems: cartItems),
                                              ),
                                            );
                                          }
                                        }
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'ชำระเงิน',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
