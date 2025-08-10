import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';
import 'package:thungthung/screens/cart_screen.dart';
import 'package:thungthung/screens/home_screen.dart';
import 'package:thungthung/screens/shop_screen.dart';
import 'package:thungthung/screens/user_screen.dart';

class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _currentIndex = 0;

  final List<String> _routes = [
    '/',        
    '/shop',    
    '/cart',    
    '/user',    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IndexedStack(
          index: _currentIndex,
          children: const [
            HomeScreen(),
            ShopScreen(),
            CartScreen(),
            UserScreen(),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color.fromRGBO(242, 205, 120, 1),
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedItemColor: const Color.fromRGBO(148, 98, 88, 1),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home_1), label: 'หน้าหลัก'),
          BottomNavigationBarItem(icon: Icon(Iconsax.shopping_bag), label: 'ร้านค้า'),
          BottomNavigationBarItem(icon: Icon(Iconsax.shopping_cart), label: 'รถเข็น'),
          BottomNavigationBarItem(icon: Icon(Iconsax.user), label: 'บัญชี'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            context.go(_routes[index]); 
          });
        },
      ),
    );
  }
}
