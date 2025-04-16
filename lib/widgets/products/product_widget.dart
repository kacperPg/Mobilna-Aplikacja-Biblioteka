import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/providers/cart_provider.dart';
import 'package:prosta_aplikcja/providers/products_provider.dart';
import 'package:prosta_aplikcja/providers/viewed_recently_provider.dart';
import 'package:prosta_aplikcja/screens/inner_screens/product_details.dart';
import 'package:prosta_aplikcja/services/my_app_methods.dart';
import 'package:prosta_aplikcja/widgets/products/heart_btn_witdget.dart';
import 'package:prosta_aplikcja/widgets/subtitles_text.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    super.key,
    required this.productId,
  });
  final String productId;
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productsProvider.findByProdId(widget.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    Size size = MediaQuery.of(context).size;
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);

    return getCurrProduct == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(0.0),
            child: GestureDetector(
              onTap: () async {
                viewedProdProvider.addViewedProd(
                    productId: getCurrProduct.productId);
                await Navigator.pushNamed(
                  context,
                  ProductDetails.routeName,
                  arguments: getCurrProduct.productId,
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: FancyShimmerImage(
                      imageUrl: getCurrProduct.productImage,
                      height: size.height * 0.22,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  IntrinsicWidth(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(children: [
                                SizedBox(
                                  width: size.width * 0.6,
                                  child: TitlesTextWidget(
                                    label: getCurrProduct.productTitle,
                                    fontSize: 13,
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.6,
                                  child: SubtitileTextWidget(
                                    label: getCurrProduct.productAutor,
                                    fontSize: 10,
                                  ),
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(12.0),
                                      onTap: () async {
                                        if (cartProvider.isProdinCart(
                                            productId:
                                                getCurrProduct.productId)) {
                                          return;
                                        }
                                        try {
                                          cartProvider.addToCartFirebase(
                                              productId:
                                                  getCurrProduct.productId, qty: 1, context: context);
                                        } catch (e) {
                                          await MyAppMethods
                                              .showErrorOrWarningDialog(
                                            context: context,
                                            subtitle: e.toString(),
                                            fct: () {},
                                          );
                                        }
                                        if (cartProvider.isProdinCart(
                                            productId:
                                                getCurrProduct.productId)) {
                                          return;
                                        }
                                        cartProvider.addToCartFirebase(
                                            productId:
                                            getCurrProduct.productId, qty: 1, context: context);
                                      },
                                      splashColor: Colors.red,
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Icon(
                                          cartProvider.isProdinCart(
                                                  productId:
                                                      getCurrProduct.productId)
                                              ? Icons.check
                                              : Icons.bookmark,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: HeartButtonWidgetState(
                                        productId: getCurrProduct.productId,
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(2.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Flexible(
                  //         flex: 1,
                  //         child: SubtitileTextWidget(
                  //           label: getCurrProduct.productAutor,
                  //           fontWeight: FontWeight.w600,
                  //           color: Colors.blue,
                  //         ),
                  //       ),
                  //       Flexible(
                  //         child: Material(
                  //           borderRadius: BorderRadius.circular(12.0),
                  //           color: Colors.lightBlue,
                  //           child: InkWell(
                  //             borderRadius: BorderRadius.circular(12.0),
                  //             onTap: () async {
                  //               // if (cartProvider.isProdinCart(
                  //               //     productId: getCurrProduct.productId)) {
                  //               //   return;
                  //               // }
                  //               // try {
                  //               //   await cartProvider.addToCartFirebase(
                  //               //       productId: getCurrProduct.productId,
                  //               //       qty: 1,
                  //               //       context: context);
                  //               // } catch (e) {
                  //               //   await MyAppFunctions.showErrorOrWarningDialog(
                  //               //     context: context,
                  //               //     subtitle: e.toString(),
                  //               //     fct: () {},
                  //               //   );
                  //               // }
                  //               // if (cartProvider.isProdinCart(
                  //               //     productId: getCurrProduct.productId)) {
                  //               //   return;
                  //               // }
                  //               // cartProvider.addProductToCart(
                  //               //     productId: getCurrProduct.productId);
                  //             },
                  //             splashColor: Colors.red,
                  //             // child: Padding(
                  //             //   padding: const EdgeInsets.all(6.0),
                  //             //   child: Icon(
                  //             //     cartProvider.isProdinCart(
                  //             //             productId: getCurrProduct.productId)
                  //             //         ? Icons.check
                  //             //         : Icons.add_shopping_cart_outlined,
                  //             //     size: 20,
                  //             //     color: Colors.white,
                  //             //   ),
                  //             // ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          );
  }
}
