import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  final String userId, userName, userEmail;
  final String? userImage; // Made optional
  final Timestamp createdAt;
  final List<dynamic> userBooked, userWish; // Specify dynamic for lists

  UserModel({
    required this.userId,
    required this.userName,
    this.userImage, // Optional field
    required this.userEmail,
    this.userBooked = const [], 
    this.userWish = const [],   // Default to empty list
    required this.createdAt,
  });

}