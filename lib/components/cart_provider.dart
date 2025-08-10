import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartItem {
  final String productName;
  final double productPrice;
  final int quantity;
  final String productImg;

  CartItem({
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.productImg,
  });

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'productImg': productImg,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productName: json['productName'],
      productPrice: json['productPrice'],
      quantity: json['quantity'],
      productImg: json['productImg'],
    );
  }
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  List<CartItem> get items => _items;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CartProvider() {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        await loadCartFromFirestore();
      } else {
        _items.clear();
        notifyListeners();
      }
    });
  }

  Future<void> addToCart(String name, double price, int qty, String img) async {
    final user = _auth.currentUser;
    if (user == null) return;

    var existingIndex = _items.indexWhere((item) => item.productName == name);

    if (existingIndex != -1) {
      _items[existingIndex] = CartItem(
        productName: name,
        productPrice: price,
        quantity: _items[existingIndex].quantity + qty,
        productImg: img,
      );
    } else {
      _items.add(CartItem(
        productName: name,
        productPrice: price,
        quantity: qty,
        productImg: img,
      ));
    }

    await saveCartToFirestore();
    notifyListeners();
  }

  Future<void> removeFromCart(CartItem item) async {
    _items.remove(item);
    await saveCartToFirestore();
    notifyListeners();
  }

  Future<void> saveCartToFirestore() async {
  final user = _auth.currentUser;
  if (user == null) return;

  final userRef = _firestore.collection('users').doc(user.uid);
  List<Map<String, dynamic>> cartData = _items.map((item) => item.toJson()).toList();

  await userRef.set({'carts': cartData}, SetOptions(merge: true)); 
}

  Future<void> loadCartFromFirestore() async {
  final user = _auth.currentUser;
  if (user == null) return;

  final userRef = _firestore.collection('users').doc(user.uid);
  final doc = await userRef.get();

  if (doc.exists && doc.data()?['carts'] != null) {
    List<CartItem> loadedItems = (doc.data()?['carts'] as List)
        .map((item) => CartItem.fromJson(item))
        .toList();

    _items = loadedItems;
    notifyListeners();
    }
  }
}
