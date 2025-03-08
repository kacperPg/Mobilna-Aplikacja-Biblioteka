import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:prosta_aplikcja/models/product_model.dart';
import 'package:prosta_aplikcja/providers/products_provider.dart';
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
    final productProvider = Provider.of<ProductsProvider>(context);
    final String? passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;

    List<ProductModel> productList = (passedCategory == null
            ? productProvider.getProductsFromDB
            : productProvider.findByCategory(categoryName: passedCategory))
        .where((product) => product.productId != null)
        .toList();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 18),
                onPressed: () =>
                    Navigator.canPop(context) ? Navigator.pop(context) : null,
              ),
            ),
            title: TitlesTextWidget(label: passedCategory ?? "Wyszukaj"),
          ),
          body: StreamBuilder<List<ProductModel>>(
              stream: productProvider.fetchProductsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: TitlesTextWidget(
                      label: snapshot.error.toString(),
                    ),
                  );
                } else if (snapshot.data == null) {
                  return const Center(
                    child: TitlesTextWidget(
                      label: "Nic nie znaleziono ",
                    ),
                  );
                }
                List<ProductModel> productList = snapshot.data!;

                // Jeśli podana jest kategoria, filtrujemy listę:
                final String? passedCategory =
                    ModalRoute.of(context)!.settings.arguments as String?;
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
                          hintText: "Szukaj",
                          filled: true,
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              // setState(() {
                              searchTextController.clear();
                              FocusScope.of(context).unfocus();
                              // });
                            },
                            child: const Icon(
                              Icons.clear,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          // setState(() {
                          //   productListSearch = productProvider.searchQuery(
                          //       searchText: searchTextController.text);
                          // });
                        },
                        onSubmitted: (value) {
                          setState(() {
                            productListSearch = productProvider.searchQuery(
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
                            child: TitlesTextWidget(
                          label: "Nic nie znaleziono ",
                          fontSize: 40,
                        ))
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
              })),
    );
  }
}
