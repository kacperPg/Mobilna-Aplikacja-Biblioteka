import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookedModelAdvanced with ChangeNotifier {
  final String orderId;
  final String userId;
  final String productId;
  final String productTitle;
  final String userName;
  final String imageUrl;
  final String quantity;
  final Timestamp orderDate;

  BookedModelAdvanced(
      {required this.orderId,
      required this.userId,
      required this.productId,
      required this.productTitle,
      required this.userName,
      required this.imageUrl,
      required this.quantity,
      required this.orderDate});
}