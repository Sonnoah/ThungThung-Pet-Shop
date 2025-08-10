import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:thungthung/components/circle_bg.dart';
import 'package:thungthung/service/auth/firebase_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose(){
    _emailController.dispose();
     _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CircleBg(),
          Positioned(
            top: 25, 
            left: 30, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),),
                Text('ยินดีต้อนรับสู่', style: TextStyle(fontSize: 15)),
              ],
            )
          ),

          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(right:50 ,left: 50 ,top:50 ,bottom:50 ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    SizedBox(
                      width: 250,
                      height: 250,
                      child: Image.asset('app_logo/logo.png'),
                    ),


                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        label: Text(
                          'อีเมล',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 15, 15, 1)),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        labelText: 'รหัสผ่าน',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 15, 15, 1)),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Iconsax.eye_slash
                              : Iconsax.eye),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    InkWell(
                      onTap: _signIn,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color.fromRGBO(242, 205, 120, 1),
                        ),
                        child: Center(
                          child: Text(
                            'เข้าสู่ระบบ',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Color.fromARGB(255, 78, 78, 78),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'เข้าสู่ระบบโดย',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Color.fromARGB(255, 78, 78, 78),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('band_logo/facebook.png', height: 40, width: 40),
                        SizedBox(width: 15),
                        Image.asset('band_logo/apple.png', height: 40, width: 40),
                        SizedBox(width: 15),
                        Image.asset('band_logo/search.png', height: 40, width: 40),
                      ],
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('ยังไม่ได้สมัครสมาชิก?'),

                        TextButton(
                        onPressed: (){
                          GoRouter.of(context).go('/register');
                        }, 
                        child: Text('ลงทะเบียน', style: TextStyle(color: Color.fromRGBO(188, 100, 70, 1)),))
                      ],
                    )
                  ],
                ),      
              ),
            ),
          ),
            Positioned(
            top: 20, 
            right: 20, 
            child: IconButton(
              icon: Icon(Iconsax.close_circle, color: Color.fromRGBO(148, 98, 88, 1)), 
              onPressed: () {
                GoRouter.of(context).canPop() 
                  ? GoRouter.of(context).pop()
                  : GoRouter.of(context).go('/');

              },
            ),
          ),

        ],
      ),
    );
  }
  
  void _signIn() async {

    showDialog(context: context,
    builder: (context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('lottie/ccjZdvvg6J.json'),
      ],
    );
   }
  );

  String email = _emailController.text.trim();
  String password = _passwordController.text.trim();

  if (email.isEmpty) {
    _showSnackBar("กรุณากรอกอีเมล");
    return;
  }

  if (password.isEmpty) {
    _showSnackBar("กรุณากรอกรหัสผ่าน");
    return;
  }


  if (!_isValidEmail(email)) {
    _showSnackBar("กรุณากรอกอีเมลให้ถูกต้อง");
    return;
  }

  User? user = await _auth.signInWithEmailAndPassword(email, password);

  if (user != null) {
    print("User successfully logged in");
    _showSnackBar("เข้าสู่ระบบสำเร็จ");
    GoRouter.of(context).go('/');
  } else {
    _showSnackBar("อีเมลหรือรหัสผ่านไม่ถูกต้อง");
  }
}

bool _isValidEmail(String email) {
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

void _showSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
  Navigator.of(context).pop();
}
}
