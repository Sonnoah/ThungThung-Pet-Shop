import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}


class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: Icon(Iconsax.arrow_left_2, color: Color.fromRGBO(148, 98, 88, 1)),
         onPressed: () {
           Navigator.of(context).pop();
        },
      ),

      title: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ตั้งค่าบัญชี', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),
          ],  
        ),
      ),
      actions: const [
          SizedBox(width: 50,)
        ],
    ),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(thickness: 19, color: const Color.fromARGB(41, 207, 207, 207),),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 29, top: 10),
                child: Text('บัญชีของฉัน', style: TextStyle(color: const Color.fromARGB(117, 0, 0, 0)),),
              ),
              buildText(text:'บัญชีและความปลอดภัย', icon: Iconsax.arrow_right_3),
              buildText(text:'ที่อยู่ของฉัน', icon: Iconsax.arrow_right_3),
              buildText(text:'ข้อมูลบัญชีธนาคาร', icon: Iconsax.arrow_right_3),
              SizedBox(height: 5,),
              Divider(thickness: 19, color: const Color.fromARGB(41, 207, 207, 207),),
              
              Padding(
                padding: const EdgeInsets.only(left: 29, top: 10),
                child: Text('ตั้งค่า', style: TextStyle(color: const Color.fromARGB(117, 0, 0, 0))),
              ),
              buildText(text:'ตั้งค่าแชท', icon: Iconsax.arrow_right_3),
              buildText(text:'ตั้งค่าแชทการแจ้งเตือน', icon: Iconsax.arrow_right_3),
              buildText(text:'ตั้งค่าความเป็นส่วนตัว', icon: Iconsax.arrow_right_3),
              buildText(text:'ภาษา / Language', icon: Iconsax.arrow_right_3),
              SizedBox(height: 5,),
              Divider(thickness: 19, color: const Color.fromARGB(41, 207, 207, 207),),
               
               Padding(
                padding: const EdgeInsets.only(left: 29, top: 10),
                child: Text('ช่วยเหลือ', style: TextStyle(color: const Color.fromARGB(117, 0, 0, 0))),
              ),
              buildText(text:'นโยบาย', icon: Iconsax.arrow_right_3),
              buildText(text:'กฎระเบียบ', icon: Iconsax.arrow_right_3),
              SizedBox(height: 5,),
              Divider(thickness: 19, color: const Color.fromARGB(41, 207, 207, 207),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton( onPressed: () async {
                      await logout(context);
                      GoRouter.of(context).go('/');
                      setState(() {
                        
                      }); 
                    }, 
                      child: Text('ออกจากระบบ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color.fromRGBO(148, 98, 88, 1)))),
                ],
              ),
            ),
          ],
        ),
      ), 
    );
    }
    Future<void> logout(BuildContext context) async {

    await FirebaseAuth.instance.signOut();

    GoRouter.of(context).go('/login'); 
  }

  Widget buildText ({
    required String text, required IconData icon,
  }){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, right: 5),
            child: Text(
              text,
                textAlign: TextAlign.center,
                style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 15,
              ),
            ),
          ),
          Icon(
             icon, 
              color:Color.fromRGBO(0, 0, 0, 1),
              size: 15,
          )
        ],
      ),
    );
  }
}