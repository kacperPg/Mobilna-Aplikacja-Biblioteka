import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:prosta_aplikcja/models/Booked_model.dart';
import 'package:prosta_aplikcja/providers/cart_provider.dart';
import 'package:prosta_aplikcja/providers/products_provider.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';
import 'package:provider/provider.dart';

class BookedWidget extends StatelessWidget {
  const BookedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final cartModel = Provider.of<BookedModel>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    final getCurrProduct = productsProvider.findByProdId(cartModel.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    return getCurrProduct == null
        ? const SizedBox.shrink()
        : FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FancyShimmerImage(
                      imageUrl: getCurrProduct.productImage,
                      height: size.height * 0.2,
                      width: size.height * 0.2,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IntrinsicWidth(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(children: [
                              SizedBox(
                                width: size.width * 0.6,
                                child: TitlesTextWidget(
                                  label: getCurrProduct.productTitle,
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.6,
                                child: TitlesTextWidget(
                                  label: getCurrProduct.productAutor,
                                  color: Colors.blue,
                                  maxLines: 2,
                                ),
                              ),
                            ]),
                            Column(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      IconlyLight.heart,
                                      color: Colors.red,
                                    ))
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
