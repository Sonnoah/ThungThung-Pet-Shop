import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:thungthung/components/circle_bg.dart';
import 'package:thungthung/service/auth/firebase_auth_service.dart';


class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose(){
    _usernameController.dispose();
    _emailController.dispose();
     _passwordController.dispose();
    super.dispose();
  }

  bool _obscureText = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          CircleBg(),
          Positioned(
            top: 25, 
            left: 30, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('สมัครสมาชิก', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),),
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

                    // Logo
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: Image.asset('app_logo/logo.png'),
                    ),

                    //  User 
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        label: Text(
                          'ขื่อผู้ใช้',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 15, 15, 1)),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Email 
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

                    // Password 
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

                    // Login Button
                    InkWell(
                      onTap: _signUp,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color.fromRGBO(242, 205, 120, 1),
                        ),
                        child: Center(
                          child: Text(
                            'ลงทะเบียน',
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('มีบัญชีแล้ว?'),

                        TextButton(
                        onPressed: (){
                          GoRouter.of(context).go('/login');
                        }, 
                        child: Text('เข้าสู่ระบบ', style: TextStyle(color: Color.fromRGBO(188, 100, 70, 1)),))
                      ],
                    ),
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

void _signUp() async {

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

  String username = _usernameController.text.trim();
  String email = _emailController.text.trim();
  String password = _passwordController.text.trim();

  if (username.isEmpty || email.isEmpty || password.isEmpty) {
    _showSnackBar("กรุณากรอกข้อมูลให้ครบถ้วน");
    return;
  }

  if (password.length < 6) {
    _showSnackBar("รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร");
    return;
  }

   if (!_isValidEmail(email)) {
    _showSnackBar("กรุณากรอกอีเมลให้ถูกต้อง");
    return;
  }
  
  User? user = await _auth.signUpWithEmailAndPassword(username, email, password);

  if (user != null) {
    print("User successfully created");
    _showSnackBar("ลงทะเบียนสำเร็จ");
    GoRouter.of(context).go('/login');
  } else {
    _showSnackBar("เกิดข้อผิดพลาดในการลงทะเบียน");
  }
}

bool _isValidEmail(String email) {
  String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExp regex = RegExp(emailPattern);
  return regex.hasMatch(email);
}

void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
    );

    Navigator.of(context).pop();
  }
}