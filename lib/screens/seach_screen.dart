import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:prosta_aplikcja/models/product_model.dart';
import 'package:prosta_aplikcja/providers/products_provider.dart';
import 'package:prosta_aplikcja/services/assets_manager.dart';
import 'package:prosta_aplikcja/widgets/products/product_widget.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController serachTextController;

  @override
  void initState() {
    serachTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    serachTextController.dispose();
    super.dispose();
  }

  List<ProductModel> productListSearch = [];

  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    String? passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;
    List<ProductModel> productList = passedCategory == null
        ? productsProvider.products
        : productsProvider.findByCategory(categoryName: passedCategory);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              AssetsManager.libraryIcon,
            ),
          ),
          title: TitlesTextWidget(label: passedCategory ?? "Wyszukaj"),
        ),
        body: productList.isEmpty
            ? const Center(
                child: TitlesTextWidget(label: "Nic nie znaleziono"),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: serachTextController,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            IconlyLight.search,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  serachTextController.clear();
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              icon: const Icon(
                                IconlyLight.closeSquare,
                                color: Colors.red,
                              ))),
                      onFieldSubmitted: (value) {
                        setState(() {
                          productListSearch = productsProvider.searchQuery(
                              searchText: serachTextController.text,
                              passedList: productList);
                        });
                      },
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    if (serachTextController.text.isNotEmpty &&
                        productListSearch.isEmpty) ...[
                      const Center(
                        child: TitlesTextWidget(label: "Nic nie znaleziono"),
                      ),
                    ],
                    Expanded(
                      child: DynamicHeightGridView(
                        builder: (context, index) {
                          return ProductWidget(
                            productId: serachTextController.text.isNotEmpty
                                ? productListSearch[index].productId
                                : productList[index].productId,
                          );
                        },
                        itemCount: serachTextController.text.isNotEmpty
                            ? productListSearch.length
                            : productList.length,
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
