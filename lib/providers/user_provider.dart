import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;
  UserModel? get getUserModel {
    return userModel;
  }

  Future<UserModel?> fetchUserInfo() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return null;
    }
    String uid = user.uid;
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      final userDocDict = userDoc.data();
      userModel = UserModel(
        userId: userDoc.get("userId"),
        userName: userDoc.get("userName"),
        userImage: userDoc.get("userImage"),
        userEmail: userDoc.get('userEmail'),
        userRole: userDoc.get('userRole'),
        userBooked: userDocDict!.containsKey("userBooked")
            ? userDoc.get("userBooked")
            : [],
        userWish:
            userDocDict.containsKey("userWish") ? userDoc.get("userWish") : [],
        createdAt: userDoc["createdAt"] is Timestamp
            ? userDoc["createdAt"] as Timestamp
            : Timestamp.now(),
        birthYear: userDoc.get("yearOfBirth"),
        albumNumber: userDoc.get("studentId"),
      );
      return userModel;
    } on FirebaseException {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

 Future<void> updateUser({
  required String userName,
  String? userImage,
  String? birthYear, 
}) async {
  final auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  if (user == null) return;

  try {
    final updateData = {
      'userName': userName,
      if (userImage != null) 'userImage': userImage,
      if (birthYear != null) 'yearOfBirth': birthYear, 
    };

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .update(updateData);

    userModel = UserModel(
      userId: userModel?.userId ?? user.uid,
      userName: userName,
      userImage: userImage ?? userModel?.userImage ?? "",
      userEmail: userModel?.userEmail ?? "",
      userRole: userModel?.userRole ?? "",
      userBooked: userModel?.userBooked ?? [],
      userWish: userModel?.userWish ?? [],
      createdAt: userModel?.createdAt ?? Timestamp.now(),
      birthYear: birthYear ?? userModel?.birthYear,  
      albumNumber: userModel?.albumNumber ?? "",
    );

    notifyListeners(); 
  } catch (error) {
    rethrow;
  }
}
}
