import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/models/booked_model_advanced.dart';
import 'package:prosta_aplikcja/providers/booked_provider.dart';
import 'package:prosta_aplikcja/screens/inner_screens/userOrders/orders_widget.dart';
import 'package:prosta_aplikcja/services/assets_manager.dart';
import 'package:prosta_aplikcja/widgets/empty_widget_bag.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';
import 'package:provider/provider.dart';

class OrdersScreenFree extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreenFree({Key? key}) : super(key: key);

  @override
  State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreenFree> {
  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<BookedProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const TitlesTextWidget(
            label: 'Wypożyczone ksiązki',
          ),
        ),
        body: FutureBuilder<List<BookedModelAdvanced>>(
          future: ordersProvider.fetchUserOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: SelectableText(snapshot.error.toString()),
              );
            } else if (!snapshot.hasData || ordersProvider.getOrders.isEmpty) {
              return EmptyBagWidget(
                imagePath: AssetsManager.orderBag,
                title: "Nie masz wypożyczonych ksiązek",
                subtitle: "",
                buttonText: "Przeglądaj",
                appBarText: 'Brak wypożyczonych ksiązek',
              );
            }
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                  child: OrdersWidgetFree(
                      ordersModelAdvanced: ordersProvider.getOrders[index]),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                    thickness: 8,
                    color: Colors.red,
                    );
              },
            );
          },
        ));
  }
}
