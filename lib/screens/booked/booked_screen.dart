import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:prosta_aplikcja/providers/cart_provider.dart';
import 'package:prosta_aplikcja/providers/products_provider.dart';
import 'package:prosta_aplikcja/screens/booked/booked_bottom_checkout.dart';
import 'package:prosta_aplikcja/screens/booked/booked_widget.dart';
import 'package:prosta_aplikcja/services/assets_manager.dart';
import 'package:prosta_aplikcja/services/my_app_methods.dart';
import 'package:prosta_aplikcja/widgets/empty_widget_bag.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';
import 'package:provider/provider.dart';

class BookedScreen extends StatelessWidget {
  const BookedScreen({super.key});
  final bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    // final productsProvider =Provider.of<ProductsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);

    return cartProvider.getCartItems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
            imagePath: AssetsManager.shoppingBasket,
            title: "Ups!",
            subtitle: "Nie ma żadnych wybranych książek do rezerwacji.",
            buttonText: "Znajdź nową książkę",
            appBarText: "Rezerwacja",
          ))
        : Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      MyAppMethods.showErrorOrWarningDialog(
                          context: context,
                          subtitle: "Usuń przedmioty",
                          fct: () {
                            cartProvider.clearLocalCart();
                          });
                    },
                    icon: const Icon(
                      IconlyLight.delete,
                      color: Colors.red,
                    ))
              ],
              title: TitlesTextWidget(
                  label: "Rezerwacja (${cartProvider.getCartItems.length})"),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AssetsManager.libraryIcon),
              ),
            ),
            body: ListView.builder(
                itemCount: cartProvider.getCartItems.length,
                itemBuilder: (context, index) {
                  return ChangeNotifierProvider.value(
                    value: cartProvider.getCartItems.values.toList()[index],
                    child: const BookedWidget(),
                  );
                }),
            bottomSheet: const BookedBottomCheckout(),
          );
  }
}
