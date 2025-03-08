import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/screens/admin/bookedAdmin/booked_screen.dart';
import 'package:prosta_aplikcja/screens/admin/edit_upload_product_form.dart';
import 'package:prosta_aplikcja/screens/admin/seach_screen_admin.dart';
import 'package:prosta_aplikcja/services/assets_manager.dart';

class DashboardButtonsModel {
  final String text, imagePath;
  final Function onPressed;

  DashboardButtonsModel({
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });

  static List<DashboardButtonsModel> dashboardBtnList(BuildContext context) => [
        DashboardButtonsModel(
          text: "Dodaj Produkt",
          imagePath: AssetsManager.upload,
          onPressed: () {
            Navigator.pushNamed(
              context,
              EditOrUploadProductScreen.routeName,
            );
          },
        ),
        DashboardButtonsModel(
          text: "Modyfikuj Produkty",
          imagePath: AssetsManager.search,
          onPressed: () {
            Navigator.pushNamed(
              context,
              SearchScreenAdmin.routeName,
            );
          },
        ),
        DashboardButtonsModel(
          text: "Zobacz Wypożyczenia",
          imagePath: AssetsManager.bookedSvg,
          onPressed: () {
            Navigator.pushNamed(
              context,
              BookedScreenFree.routeName,
            );
          },
        ),
        DashboardButtonsModel(
          text: "Zobacz Użytkowników",
          imagePath: AssetsManager.userIcon,
          onPressed: () {},
        ),
      ];
}
