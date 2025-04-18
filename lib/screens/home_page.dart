import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/consts/app_constants.dart';
import 'package:prosta_aplikcja/providers/products_provider.dart';
import 'package:prosta_aplikcja/screens/inner_screens/category_screen.dart';
import 'package:prosta_aplikcja/widgets/products/ctg_rounded_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:prosta_aplikcja/providers/products_provider.dart';
import 'package:prosta_aplikcja/services/assets_manager.dart';
import 'package:prosta_aplikcja/widgets/app_name_text.dart';
import 'package:prosta_aplikcja/widgets/products/latest_arrival.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productsProvider = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.libraryIcon),
        ),
        title: const AppNameTextWidger(fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: size.height * 0.25,
                child: ClipRRect(
                  child: Swiper(
                    autoplay: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        AppConstants.bannersImages[index],
                        fit: BoxFit.fill,
                      );
                    },
                    itemCount: AppConstants.bannersImages.length,
                    pagination: const SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                          activeColor: Colors.red, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, CategoryScreen.routeName);
                },
                title: const TitlesTextWidget(label: "Kategorie"),
              ),
              const SizedBox(
                height: 15.0,
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children: List.generate(8, (index) {
                  return CategoryRoundedWidget(
                    image: AppConstants.categoriesList[index].image,
                    name: AppConstants.categoriesList[index].name,
                  );
                }),
              ),
              const TitlesTextWidget(label: "Populare i polecane"),
              const SizedBox(
                height: 15.0,
              ),
              Visibility(
                visible: productsProvider.getProducts.isNotEmpty,
                child: SizedBox(
                  height: size.height * 0.2,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productsProvider.getProducts.length < 10
                          ? productsProvider.getProducts.length
                          : 10,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: productsProvider.getProducts[index],
                            child: ChangeNotifierProvider.value(value: productsProvider.getProducts[index],
                            child: const LatestArrivalProductsWidget()));
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
