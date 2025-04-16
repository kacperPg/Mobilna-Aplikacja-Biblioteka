import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;
  List<UserModel> allUsers = [];

  UserModel? get getUserModel {
    return userModel;
  }

  List<UserModel> get getAllUsers {
    return allUsers;
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
       userStatus: userDoc.get('userStatus'),
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

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProvidedUser({
    required String userName,
    String? userImage,
    String? birthYear,
  String? userStatus,
    required UserModel user
  }) async {
    try {
      final updateData = {
        'userName': userName,
        if (userImage != null) 'userImage': userImage,
        if (birthYear != null) 'yearOfBirth': birthYear,
        if (userStatus != null) 'userStatus': userStatus,
      };

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.userId)
          .update(updateData);

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAllUsers() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return;
    }
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      final userRole = userDoc.get('userRole');

      if (userRole == 'admin') {
        final usersSnapshot =
            await FirebaseFirestore.instance.collection("users").get();

        allUsers.clear();

        for (var userDoc in usersSnapshot.docs) {
          allUsers.add(
            UserModel(
              userId: userDoc.get('userId'),
              userName: userDoc.get('userName'),
              userImage: userDoc.get('userImage'),
              userEmail: userDoc.get('userEmail'),
              userRole: userDoc.get('userRole'),
              userStatus: userDoc.get('userStatus'),
              userBooked: userDoc.data().containsKey("userBooked")
                  ? userDoc.get("userBooked")
                  : [],
              userWish: userDoc.data().containsKey("userWish")
                  ? userDoc.get("userWish")
                  : [],
              createdAt: userDoc["createdAt"] is Timestamp
                  ? userDoc["createdAt"] as Timestamp
                  : Timestamp.now(),
              birthYear: userDoc.get("yearOfBirth"),
              albumNumber: userDoc.get("studentId"),
            ),
          );
        }

        notifyListeners();
      } else {
        throw Exception('Brak uprawnień do pobrania użytkowników');
      }
    } catch (error) {
      rethrow;
    }
  }
}
