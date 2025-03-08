import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/providers/viewed_recently_provider.dart';
import 'package:prosta_aplikcja/services/assets_manager.dart';
import 'package:prosta_aplikcja/widgets/empty_widget_bag.dart';
import 'package:prosta_aplikcja/widgets/products/product_widget.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';
import 'package:provider/provider.dart';

class ViewedRecentlyScreen extends StatelessWidget {
  static const routeName = "/RecentlyViewedScreen";
  const ViewedRecentlyScreen({super.key});
  final bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);

    return viewedProdProvider.getViewedProds.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
            imagePath: AssetsManager.shoppingBasket,
            title: "Ups!",
            subtitle: "Nie wyświetliłeś ostanio żadnej ksiązki.",
            buttonText: "Znajdź nową książkę",
            appBarText: "Ostanio wyświetlone",
          ))
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                  title: const TitlesTextWidget(
                    fontSize: 20,
                    label: "Ostanio wyświetlane",
                  ),
               leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),),
              body: DynamicHeightGridView(
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                builder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProductWidget(
                        productId: viewedProdProvider.getViewedProds.values
                            .toList()[index]
                            .productId),
                  );
                },
                itemCount: viewedProdProvider.getViewedProds.length,
                crossAxisCount: 2,
              ),
            ),
          );
  }
}
