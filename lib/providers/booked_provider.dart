import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/models/booked_model_advanced.dart';

class BookedProvider with ChangeNotifier {
  final List<BookedModelAdvanced> orders = [];
  List<BookedModelAdvanced> get getOrders => orders;

  Future<List<BookedModelAdvanced>> fetchOrder() async {
    // final auth = FirebaseAuth.instance;
    // User? user = auth.currentUser;
    // var uid = user!.uid;
    try {
      await FirebaseFirestore.instance
          .collection("ordersAdvanced")
          .orderBy("orderDate", descending: false)
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
              quantity: element.get('quantity').toString(),
              imageUrl: element.get('imageUrl'),
              userName: element.get('userName'),
              orderDate: element.get('orderDate'),
            ),
          );
        }
      });
      return orders;
    } catch (e) {
      rethrow;
    }
  }
}