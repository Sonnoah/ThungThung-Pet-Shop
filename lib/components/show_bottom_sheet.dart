import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';  
import 'package:thungthung/components/cart_provider.dart';
import 'package:thungthung/screens/checkout_screen.dart';

class ShowBottomSheet extends StatefulWidget {
  final String productName;
  final dynamic productPrice;
  final String productImg;
  final String productStock;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  const ShowBottomSheet({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productImg,
    required this.productStock,
    required this.buttonText,
    this.onButtonPressed,
  });

  @override
  State<ShowBottomSheet> createState() => _ShowBottomSheetState();
}

class _ShowBottomSheetState extends State<ShowBottomSheet> {
  int quantity = 1;
  late int availableStock;
  bool isLoggedIn = false;

  @override
  void initState() {
  super.initState();
  availableStock = int.tryParse(widget.productStock) ?? 0; 
  final user = FirebaseAuth.instance.currentUser;
  setState(() {
    isLoggedIn = user != null;
  });
}

  void _decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _increaseQuantity() {
    if (quantity < availableStock) {
      setState(() {
        quantity++;
      });
    }
  }

  void _handleButtonClick() {
  if (!isLoggedIn) {
    _showLoginDialog(); 
    return;
  }

  if (widget.buttonText.trim() == "ซื้อสินค้า") {  
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          cartItems: [
            CartItem(
              productName: widget.productName,
              productPrice: double.tryParse(widget.productPrice.toString()) ?? 0,
              quantity: quantity,
              productImg: widget.productImg,
            )
          ],
        ),
      ),
    );
  } else {
    _purchase();
  }
}
  void _purchase() {
    if (quantity <= availableStock) {
      setState(() {
        availableStock -= quantity;
      });

      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      double productPrice = double.tryParse(widget.productPrice.toString()) ?? 0;
      double totalPrice = productPrice * quantity; 

      cartProvider.addToCart(
        widget.productName,
        totalPrice, 
        quantity,
        widget.productImg,
      );


      

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('lottie/ccjZdvvg6J.json', height: 100),
                const SizedBox(height: 20),
                Text("เพิ่มสินค้าลงในตะกร้า: ฿${totalPrice.toStringAsFixed(2)}"), 
              ],
            ),
          );
        },
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); 
        }
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); 
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("จำนวนสินค้าใน stock หมด!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (widget.productImg.isNotEmpty)
            Row(
              children: [
                Image.asset(
                  widget.productImg,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.productName,
                        style: const TextStyle(
                          fontSize: 13, 
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '฿ ${widget.productPrice}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(228, 95, 43, 1),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "คงเหลือ: $availableStock",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('จำนวน'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _decreaseQuantity,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(
                      "$quantity",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _increaseQuantity,
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleButtonClick, 
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(233, 188, 133, 1),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                widget.buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _showLoginDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: AlertDialog(
          title: Text("กรุณาเข้าสู่ระบบ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
          content: Text("คุณต้องเข้าสู่ระบบก่อนทำการซื้อสินค้า"),
          actions: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  GoRouter.of(context).push('/login');
                },
                style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(233, 188, 133, 1), shadowColor: Colors.transparent),
                child: Text("เข้าสู่ระบบ",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1))),
              ),
              SizedBox(width: 10),
        
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  GoRouter.of(context).push('/register');
                },
                style: OutlinedButton.styleFrom(side: BorderSide(color: Color.fromRGBO(148, 98, 88, 1))),
                child: Text("ลงทะเบียน", style: TextStyle(color: Color.fromRGBO(148, 98, 88, 1))),
              ),
            ],
          ),
          ],
        ),
      );
    },
  );
}
}
