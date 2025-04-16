import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prosta_aplikcja/models/Booked_model.dart';
import 'package:prosta_aplikcja/services/my_app_methods.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final Map<String, BookedModel> _cartItems = {};

  Map<String, BookedModel> get getCartItems {
    return _cartItems;
  }

  final userstDb = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;

  Future<void> addToCartFirebase({
    required String productId,
    required int qty,
    required BuildContext context,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      MyAppMethods.showErrorOrWarningDialog(
        context: context,
        subtitle: "Najpierw zaloguj się",
        fct: () {},
      );
      return;
    }
    final uid = user.uid;
    final cartId = const Uuid().v4();
    try {
      await userstDb.doc(uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': qty,
          }
        ])
      });
      await fetchCart();
      Fluttertoast.showToast(msg: "Dodano książkę do koszyka");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchCart() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      _cartItems.clear();
      return;
    }
    try {
      final userDoc = await userstDb.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey('userCart')) {
        return;
      }
      final leng = userDoc.get("userCart").length;
      for (int index = 0; index < leng; index++) {
        _cartItems.putIfAbsent(
          userDoc.get("userCart")[index]['productId'],
              () => BookedModel(
              cartId: userDoc.get("userCart")[index]['cartId'],
              productId: userDoc.get("userCart")[index]['productId'],
              quantity: userDoc.get("userCart")[index]['quantity']),
        );
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeCartItemFromFirestore({
    required String cartId,
    required String productId,
    required int qty,
  }) async {
    final User? user = _auth.currentUser;
    try {
      await userstDb.doc(user!.uid).update({
        'userCart': FieldValue.arrayRemove([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': qty,
          }
        ])
      });
      await fetchCart();
      _cartItems.remove(productId);
      Fluttertoast.showToast(msg: "Usunięto produkt z koszyka!");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearCartFromFirebase() async {
    final User? user = _auth.currentUser;
    try {
      await userstDb.doc(user!.uid).update({
        'userCart': [],
      });
      await fetchCart();
      _cartItems.clear();
      Fluttertoast.showToast(msg: "Wyczyszczono koszyk");
    } catch (e) {
      rethrow;
    }
  }


  bool isProdinCart({required String productId}) {
    return _cartItems.containsKey(productId);
  }

  void updateQty({required String productId, required int qty}) {
    _cartItems.update(
      productId,
      (cartItem) => BookedModel(
        cartId: cartItem.cartId,
        productId: productId,
        quantity: qty,
      ),
    );
    notifyListeners();
  }


  int getQty() {
    int total = 0;
    _cartItems.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }


}
