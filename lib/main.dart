import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';  
import 'package:thungthung/components/cart_provider.dart';
import 'package:thungthung/components/nav.dart';
import 'package:thungthung/components/product/product_screen.dart';
import 'package:thungthung/components/screens/cat_screen.dart';
import 'package:thungthung/components/screens/dog_screen.dart';
import 'package:thungthung/components/screens/search_screen.dart';
import 'package:thungthung/components/screens/setting_screen.dart';
import 'package:thungthung/screens/cart_screen.dart';
import 'package:thungthung/screens/chat_screen.dart';
import 'package:thungthung/screens/home_screen.dart';
import 'package:thungthung/screens/login/login_screen.dart';
import 'package:thungthung/screens/payment/already_shipped.dart';
import 'package:thungthung/screens/payment/delivery_success.dart';
import 'package:thungthung/screens/payment/history.dart';
import 'package:thungthung/screens/payment/not_yet.dart';
import 'package:thungthung/screens/payment/payment_screen.dart';
import 'package:thungthung/screens/payment/success.dart';
import 'package:thungthung/screens/product_detail/product_detail_screen.dart';
import 'package:thungthung/screens/register/register_screen.dart';
import 'package:thungthung/screens/shop_screen.dart';
import 'package:thungthung/screens/user_screen.dart';

import 'package:thungthung/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint("Flutter Error: ${details.exception}");
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'thungthung',

      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(0, 255, 255, 255), 
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
        ),
        splashColor: Colors.transparent, 
        highlightColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }


  final _router = GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Nav();
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => HomeScreen(),
          ),
          GoRoute(
            path: '/shop',
            builder: (context, state) => ShopScreen(),
          ),
          GoRoute(
            path: '/cart',
            builder: (context, state) => CartScreen(),
          ),
          GoRoute(
            path: '/user',
            builder: (context, state) => UserScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/product/:category/:id',
        builder: (context, state) {
          final categoryId = state.pathParameters['category']!;  
          final productId = state.pathParameters['id']!;  
          return ProductDetailScreen(categoryDocId: categoryId, productId: productId);
        },
      ),
      GoRoute(path: '/product', builder: (context, state) => ProductScreen()),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => Registerscreen()),
      GoRoute(path: '/setting', builder: (context, state) => Setting()),
      GoRoute(path: '/search', builder: (context, state) => SearchScreen()),
      GoRoute(path: '/cat_food', builder: (context, state) => CatScreen()),
      GoRoute(path: '/dog_food', builder: (context, state) => DogScreen()),
      GoRoute(path: '/payment', builder: (context, state) => PaymentScreen(),),//เอฟ
      GoRoute(path: '/success', builder: (context, state) => Success(),),//เอฟ
      GoRoute(path: '/history', builder: (context, state) => History(),),//เอฟ
      GoRoute(path: '/already', builder: (context, state) => AleradyShipped(),),
      GoRoute(path: '/chat', builder: (context, state) => ChatScreen(),),//เอฟ
      GoRoute(path: '/delivery_success', builder: (context, state) => DeliverySuccess(),),
      GoRoute(path: '/notyet', builder: (context, state) => NotYet(),),
    ],
  );
}
