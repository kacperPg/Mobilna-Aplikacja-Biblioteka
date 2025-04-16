import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/models/booked_model_advanced.dart';
import 'package:prosta_aplikcja/models/user_model.dart';
import 'package:prosta_aplikcja/providers/user_provider.dart';
import 'package:provider/provider.dart';

class BookedProvider with ChangeNotifier {
  final List<BookedModelAdvanced> orders = [];

  List<BookedModelAdvanced> get getOrders => orders;

  Future<List<BookedModelAdvanced>> fetchUserOrders() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    var uid = user!.uid;
    try {
      await FirebaseFirestore.instance
          .collection("ordersAdvanced")
          .where('userId', isEqualTo: uid)
          .orderBy("bookedDate", descending: true)
          .get()
          .then((orderSnapshot) {
        orders.clear();
        for (var element in orderSnapshot.docs) {
          orders.insert(
            0,
            BookedModelAdvanced(
              orderId: element.get('orderId'),
              productId: element.get('productId'),
              userId: element.get('userId'),
              productTitle: element.get('productTitle').toString(),
              quantity: element.get('quantity'),
              imageUrl: element.get('imageUrl'),
              userName: element.get('userName'),
              bookedDate: element.get('bookedDate'),
              returnDate: element.data().containsKey('returnDate')
                  ? element.get('returnDate')
                  : null,
              status: element.data().containsKey('status')
                  ? element.get('status')
                  : null,
            ),
          );
        }
      });
      return orders;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BookedModelAdvanced>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    UserModel? userModel = await userProvider.fetchUserInfo();

    List<BookedModelAdvanced> orders = [];

    if (userModel?.userRole == 'admin') {
      try {
        await FirebaseFirestore.instance
            .collection("ordersAdvanced")
            .orderBy("bookedDate", descending: true)
            .get()
            .then((orderSnapshot) {
          orders.clear();
          for (var element in orderSnapshot.docs) {
            orders.insert(
              0,
              BookedModelAdvanced(
                orderId: element.get('orderId'),
                productId: element.get('productId'),
                userId: element.get('userId'),
                productTitle: element.get('productTitle'),
                quantity: element.get('quantity'),
                imageUrl: element.get('imageUrl'),
                userName: element.get('userName'),
                bookedDate: element.get('bookedDate'),
                returnDate: element.data().containsKey('returnDate')
                    ? element.get('returnDate')
                    : null,
                status: element.get('status'),
              ),
            );
          }
        });

        if (orders.isEmpty) {
          print('Nie ma zamówień');
        }

        return orders;
      } catch (e) {
        rethrow;
      }
    }
    return orders;
    }
}
