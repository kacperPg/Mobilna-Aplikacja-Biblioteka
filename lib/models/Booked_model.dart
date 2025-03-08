import 'package:flutter/material.dart';

class BookedModel with ChangeNotifier {
  final String cartId;
  final String productId;
  final int quantity;

  BookedModel({
    required this.cartId,
    required this.productId,
    required this.quantity,
  });
}