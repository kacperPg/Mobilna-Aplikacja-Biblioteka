import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/models/Booked_model.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final Map<String, BookedModel> _cartItem = {};

  Map<String, BookedModel> get getCartItems {
    return _cartItem;
  }

  void addProductToCart({required String productId}) {
    _cartItem.putIfAbsent(
        productId,
        () => BookedModel(
            cartId: const Uuid().v4(), productId: productId, quantity: 1));
    notifyListeners();
  }

  bool isProdinCart({required String productId}) {
    return _cartItem.containsKey(productId);
  }

  void updateQty({required String productId, required int qty}) {
    _cartItem.update(
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
    _cartItem.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }

  void clearLocalCart() {
    _cartItem.clear();
    notifyListeners();
  }

  void removeOneItem({required String productId}) {
    _cartItem.remove(productId);
    notifyListeners();
  }
}
