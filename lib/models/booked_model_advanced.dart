import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookedModelAdvanced with ChangeNotifier {
  final String orderId;
  final String userId;
  final String productId;
  final String productTitle;
  final String userName;
  final String imageUrl;
  final int quantity;
  final Timestamp bookedDate;
  final String? status;
  final Timestamp? returnDate;

  BookedModelAdvanced({
    required this.orderId,
    required this.userId,
    required this.productId,
    required this.productTitle,
    required this.userName,
    required this.imageUrl,
    required this.quantity,
    required this.bookedDate,
    this.status,
    this.returnDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'productId': productId,
      'productTitle': productTitle,
      'userName': userName,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'bookedDate': bookedDate,
      'status': status,
      'returnDate': returnDate,
    };
  }
}
