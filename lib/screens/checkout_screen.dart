import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thungthung/components/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CheckoutScreen({super.key, required this.cartItems});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _savedAddress;
  bool _isAddressComplete = false;

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedAddress = prefs.getString('user_address');
      _isAddressComplete = _savedAddress != null;
    });
  }


  void _showAddressModal(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController housenumberController = TextEditingController();
    TextEditingController subDistrictController = TextEditingController();
    TextEditingController districtController = TextEditingController();
    TextEditingController provinceController = TextEditingController();
    TextEditingController postalCodeController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("กรอกที่อยู่จัดส่ง", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                SizedBox(height: 10),

                _buildTextField(nameController, "ชื่อ-นามสกุล"),
                _buildTextField(housenumberController, "บ้านเลขที่/หมู่/ซอย"),
                _buildTextField(subDistrictController, "ตำบล"),
                _buildTextField(districtController, "อำเภอ/เมือง"),
                _buildTextField(provinceController, "จังหวัด"),
                _buildTextField(postalCodeController, "รหัสไปรษณีย์", keyboardType: TextInputType.number),
                _buildTextField(phoneController, "เบอร์โทร", keyboardType: TextInputType.phone),

                SizedBox(height: 15),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                  backgroundColor: const Color.fromRGBO(233,188,133,1), padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String address = "${nameController.text}, ${subDistrictController.text}, ${districtController.text}, ${provinceController.text}, ${postalCodeController.text}, ${phoneController.text}";

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('user_address', address);

                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .update({'user_address': address});
                      }

                      setState(() {
                        _savedAddress = address;
                        _isAddressComplete = true;
                      });

                      Navigator.pop(context);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("ยืนยัน", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10), 
      ),
      validator: (value) => value == null || value.isEmpty ? "กรุณากรอก $label" : null,
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    double totalAmount = widget.cartItems.fold(0, (_sum, item) => _sum + (item.productPrice * item.quantity));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_2, color: Color.fromRGBO(148, 98, 88, 1)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('ชำระเงิน', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: const [SizedBox(width: 50)],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                  child: ListTile(
                    leading: Image.asset(item.productImg),
                    title: Text(
                      item.productName,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('฿ ${(item.productPrice * item.quantity).toStringAsFixed(2)}'),
                        Text('x ${item.quantity}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Divider(),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => _showAddressModal(context),  
                            icon: Row(
                              children: [
                                Icon(Iconsax.location, color: Color.fromRGBO(228, 95, 43, 1)),
                                SizedBox(width: 5),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text('ที่อยู่สำหรับจัดส่ง', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20,top: 3),
                          child: Text( _savedAddress ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Column(
              children: [
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 60, top: 10),
                        child: Text('รวมทั้งหมด: ฿${totalAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        flex: 1, 
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: const Color.fromRGBO(233, 188, 133, 1),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          ),
                        
                          onPressed: widget.cartItems.isNotEmpty && _isAddressComplete ? () => GoRouter.of(context).go('/payment') : null,
                          
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'ชำระเงิน',
                              style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
