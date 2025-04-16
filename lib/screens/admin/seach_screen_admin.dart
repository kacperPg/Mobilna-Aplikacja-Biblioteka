import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:prosta_aplikcja/models/product_model.dart';
import 'package:prosta_aplikcja/providers/products_provider.dart';
import 'package:prosta_aplikcja/services/assets_manager.dart';
import 'package:prosta_aplikcja/widgets/modify_product_widget.dart';
import 'package:prosta_aplikcja/widgets/products/product_widget.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';
import 'package:provider/provider.dart';

class SearchScreenAdmin extends StatefulWidget {
  static const routeName = '/SearchScreenAdmin';
  const SearchScreenAdmin({super.key});

  @override
  State<SearchScreenAdmin> createState() => _SearchScreenAdminState();
}

class _SearchScreenAdminState extends State<SearchScreenAdmin> {
  late TextEditingController searchTextController;
  List<ProductModel> productListSearch = [];
  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

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
          leading:IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          title: TitlesTextWidget(label: passedCategory ?? "Wyszukaj"),
        ),
        body: productList.isEmpty
            ? const Center(
          child: TitlesTextWidget(label: "Nic nie znaleziono"),
        )
            : StreamBuilder<List<ProductModel>>(
            stream: productsProvider.fetchProductsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: SelectableText(snapshot.error.toString()),
                );
              } else if (snapshot.data == null) {
                return const Center(
                  child: SelectableText("No products has been added"),
                );
              }
              List<ProductModel> productList = snapshot.data!;
              if (passedCategory != null) {
                productList = productList
                    .where((product) => product.productCategory
                    .toLowerCase()
                    .contains(passedCategory.toLowerCase()))
                    .toList();
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15.0,
                    ),
                    TextField(
                      controller: searchTextController,
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            // setState(() {
                            FocusScope.of(context).unfocus();
                            searchTextController.clear();
                            // });
                          },
                          child: const Icon(
                            Icons.clear,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      // onChanged: (value) {
                      //   setState(() {
                      //     productListSearch = productsProvider.searchQuery(
                      //         searchText: searchTextController.text);
                      //   });
                      // },
                      onSubmitted: (value) {
                        setState(() {
                          productListSearch = productsProvider.searchQuery(
                              searchText: searchTextController.text,
                              passedList: productList);
                        });
                      },
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    if (searchTextController.text.isNotEmpty &&
                        productListSearch.isEmpty) ...[
                      const Center(
                        child: TitlesTextWidget(label: "Nic nie znalezion"),
                      ),
                    ],
                    Expanded(
                      child: DynamicHeightGridView(
                        itemCount: searchTextController.text.isNotEmpty
                            ? productListSearch.length
                            : productList.length,
                        builder: ((context, index) {
                          return ModifyProductWidget(
                            productId: searchTextController.text.isNotEmpty
                                ? productListSearch[index].productId
                                : productList[index].productId,
                          );
                        }),
                        crossAxisCount: 2,
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}