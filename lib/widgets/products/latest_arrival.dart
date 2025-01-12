import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/providers/viewed_recently_provider.dart';
import 'package:prosta_aplikcja/screens/inner_screens/product_details.dart';
import 'package:prosta_aplikcja/widgets/subtitles_text.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';

class LatestArrivalProductsWidget extends StatelessWidget {
  const LatestArrivalProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productsModel = Provider.of<ProductModel>(context);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          viewedProdProvider.addViewedProd(productId: productsModel.productId);
          await Navigator.pushNamed(
            context,
            ProductDetails.routeName,
            arguments: productsModel.productId,
          );
        },
        child: SizedBox(
          width: size.width * 0.9,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: FancyShimmerImage(
                    imageUrl: productsModel.productImage,
                    height: size.width * 0.4,
                    width: size.width * 0.4,
                  ),
                ),
              ),
              FittedBox(
                child: Column(
                  children: [
                    SubtitileTextWidget(
                      label: productsModel.productTitle,
                      fontWeight: FontWeight.w600,
                    ),
                    SubtitileTextWidget(
                  label: productsModel.productAutor,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
