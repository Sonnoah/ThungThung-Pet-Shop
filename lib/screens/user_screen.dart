import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:iconsax/iconsax.dart';
import 'package:go_router/go_router.dart';  

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool isLoggedIn = false; 
  String username = '';

 @override
void initState() {
  super.initState();
  FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        isLoggedIn = true;
        username = userDoc.exists
            ? userDoc['username'] ?? 'ผู้ใช้ไม่มีชื่อ'
            : 'ผู้ใช้ไม่มีชื่อ';
      });
    } else {
      setState(() {
        isLoggedIn = false;
        username = '';
      });
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isLoggedIn
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ProfilePicture(
                        name: username,
                        radius: 13,
                        fontsize: 11,
                        random: true,
                      ),
                      SizedBox(width: 9),
                      Text(username, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: IconButton(onPressed:(){GoRouter.of(context).push('/setting');
                    },
                    icon: Icon(Iconsax.setting, color: const Color.fromRGBO(148, 98, 88, 1),)),
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("บัญชีของฉัน", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isLoggedIn) 
              Center(
                child: Column(
                  children: [
                    Text(
                      "กรุณาเข้าสู่ระบบเพื่อดูข้อมูลบัญชีของคุณ",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            GoRouter.of(context).push('/login');
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(233, 188, 133, 1), shadowColor: Colors.transparent),
                          child: Text("เข้าสู่ระบบ",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1))),
                        ),
                        SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {
                            GoRouter.of(context).push('/register');
                          },
                          style: OutlinedButton.styleFrom(side: BorderSide(color: Color.fromRGBO(148, 98, 88, 1))),
                          child: Text("ลงทะเบียน", style: TextStyle(color: Color.fromRGBO(148, 98, 88, 1))),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              )
            else 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      "คำสั่งซื้อของฉัน",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        buildOrderButton(Iconsax.card, 'ที่ต้องชำระเงิน', () => GoRouter.of(context).go('/notyet'), color: Color.fromRGBO(148, 98, 88, 1)),
                        buildOrderButton(Iconsax.box, 'เตรียมจัดส่ง', () => GoRouter.of(context).go('/history'),color: Color.fromRGBO(148, 98, 88, 1)),
                        buildOrderButton(Iconsax.truck_fast, 'จัดส่งแล้ว', () => GoRouter.of(context).go('/already'),color: Color.fromRGBO(148, 98, 88, 1)),
                      ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderButton(IconData icon, String label, VoidCallback onPressed, {Color color = Colors.black}) {
  return InkWell(
    onTap: onPressed,  // กำหนดฟังก์ชันที่ต้องการให้ทำงานเมื่อกดปุ่ม
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 30,
          color: color, // ใช้สีที่ได้รับเข้ามาในฟังก์ชัน
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
}
