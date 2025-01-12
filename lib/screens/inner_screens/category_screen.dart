import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/consts/app_constants.dart';
import 'package:prosta_aplikcja/widgets/products/ctg_rounded_widget.dart';
import 'package:prosta_aplikcja/widgets/titles_text.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = "/Category";
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late TextEditingController serachTextController;
  @override
  void initState() {
    serachTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            title: const TitlesTextWidget(
              fontSize: 20,
              label: "Kategorie",
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                  )),
            )),
        body:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  children:
                      List.generate(AppConstants.categoriesList.length, (index) {
                    return CategoryRoundedWidget(
                      image: AppConstants.categoriesList[index].image,
                      name: AppConstants.categoriesList[index].name,
                    );
                  }),
                ),
        ),
      ),
    );
  }
}
