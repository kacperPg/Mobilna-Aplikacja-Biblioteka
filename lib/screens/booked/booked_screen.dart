import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prosta_aplikcja/models/user_model.dart';
import 'package:prosta_aplikcja/providers/cart_provider.dart';
import 'package:prosta_aplikcja/providers/products_provider.dart';
import 'package:prosta_aplikcja/providers/user_provider.dart';
import 'package:prosta_aplikcja/screens/admin/loading_manager.dart';
import 'package:prosta_aplikcja/screens/booked/booked_bottom_checkout.dart';
import 'package:prosta_aplikcja/screens/booked/booked_widget.dart';
import 'package:prosta_aplikcja/services/assets_manager.dart';
import 'package:prosta_aplikcja/services/my_app_methods.dart';
import 'package:prosta_aplikcja/widgets/empty_widget_bag.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class BookedScreen extends StatefulWidget {
  const BookedScreen({super.key});

  @override
  State<BookedScreen> createState() => _BookedScreenState();
}

class _BookedScreenState extends State<BookedScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return cartProvider.getCartItems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.shoppingBasket,
              title: "Twój koszyk jest pusty",
              subtitle:
                  "Wygląda na to że twój koszyk jest pust, znajdz nową książkę",
              buttonText: "Szukaj",
              appBarText: '',
            ),
          )
        : Scaffold(
            bottomSheet: BookedBottomCheckout(function: () async {
              await placeOrderAdvanced(
                cartProvider: cartProvider,
                productProvider: productsProvider,
                userProvider: userProvider,
              );
            }),
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  AssetsManager.shoppingCart,
                ),
              ),
              title: TitlesTextWidget(
                  label: "Koszyk (${cartProvider.getCartItems.length})"),
              actions: [
                IconButton(
                  onPressed: () {
                    MyAppMethods.showErrorOrWarningDialog(
                      isError: false,
                      context: context,
                      subtitle: "Wyczyść koszyk?",
                      fct: () async {
                        cartProvider.clearCartFromFirebase();
                        // cartProvider.clearLocalCart();
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            body: LoadingManager(
              isLoading: _isLoading,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: cartProvider.getCartItems.length,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider.value(
                              value: cartProvider.getCartItems.values
                                  .toList()[index],
                              child: const BookedWidget());
                        }),
                  ),
                  const SizedBox(
                    height: kBottomNavigationBarHeight + 10,
                  )
                ],
              ),
            ),
          );
  }

  Future<void> placeOrderAdvanced({
    required CartProvider cartProvider,
    required ProductsProvider productProvider,
    required UserProvider userProvider,
  }) async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    UserModel? userModel= await userProvider.fetchUserInfo();
    final userstDb = FirebaseFirestore.instance.collection("users");

    if (user == null) {
      return;
    }
    final uid = user.uid;
    try {
      setState(() {
        _isLoading = true;
      });
      cartProvider.getCartItems.forEach((key, value) async {
        final getCurrProduct = productProvider.findByProdId(value.productId);

        if (getCurrProduct == null) {
          print("Nie znaleziono produktu z ID : ${value.productId}");
          return;
        }
        final orderId = const Uuid().v4();
        final bookedDate= Timestamp.now();
        await FirebaseFirestore.instance
            .collection("ordersAdvanced")
            .doc(orderId)
            .set({
          'orderId': orderId,
          'userId': uid,
          'userName': userModel?.userEmail,
          'productId': value.productId,
          "productTitle": getCurrProduct!.productTitle,
          'quantity': value.quantity,
          'imageUrl': getCurrProduct!.productImage,
          'bookedDate': bookedDate,
          'status': "Wypożyczona",
        });

        await userstDb.doc(uid).update({
          'userBooked': FieldValue.arrayUnion([
            {
              'orderId': orderId,
              'BookedDate': bookedDate,
            }
          ])
        });

      });
      await cartProvider.clearCartFromFirebase();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Twoje zamówienie zostało pomyślnie złożone!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      await MyAppMethods.showErrorOrWarningDialog(
        context: context,
        subtitle: e.toString(),
        fct: () {},
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
