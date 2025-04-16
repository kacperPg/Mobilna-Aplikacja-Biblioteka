import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  final String userId, userName, userEmail, userStatus,userRole;
  final String? userImage, birthYear, albumNumber; 
  final Timestamp createdAt;
  final List<dynamic> userBooked, userWish;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userRole,
    required this.userStatus,
    this.userImage,
    required this.userEmail,
    this.userBooked = const [],
    this.userWish = const [],
    required this.createdAt,
    this.birthYear, 
    this.albumNumber,
  });
}
