import 'package:prosta_aplikcja/models/categories_model.dart';

import '../services/assets_manager.dart';


class AppConstants {
  static String productUrl="https://www.flutterengineering.io/bookcover_isbn.png";
  static List<String> bannersImages = [
    AssetsManager.banner1,
    AssetsManager.banner2
  ];

  static List<CategoriesModel> categoriesList = [
    CategoriesModel(
      id: "Matematyka",
      image: AssetsManager.matematyka,
      name: "Matematyka",
    ),
    CategoriesModel(
      id: "Fizyka",
      image: AssetsManager.fizyka,
      name: "Fizyka",
    ),
    CategoriesModel(
      id: "Chemia",
      image: AssetsManager.chemia,
      name: "Chemia",
    ),
    CategoriesModel(
      id: "Informatyka",
      image: AssetsManager.informatyka,
      name: "Informatyka",
    ),
    CategoriesModel(
      id: "Ekonomia",
      image: AssetsManager.ekonomia,
      name: "Ekonomia",
    ),
    CategoriesModel(
      id: "Medycyna",
      image: AssetsManager.medycyna,
      name: "Medycyna",
    ),
    CategoriesModel(
      id: "Prawo",
      image: AssetsManager.prawo,
      name: "Prawo",
    ),
    CategoriesModel(
      id: "Inżynieria",
      image: AssetsManager.inzynieria,
      name: "Inżynieria",
    ),
    CategoriesModel(
      id: "Biotechnologia",
      image: AssetsManager.biotechnologia,
      name: "Biotechnologia",
    ),
    CategoriesModel(
      id: "Psychologia",
      image: AssetsManager.psychologia,
      name: "Psychologia",
    ),
    CategoriesModel(
      id: "Filozofia",
      image: AssetsManager.filozofia,
      name: "Filozofia",
    ),
    CategoriesModel(
      id: "Historia",
      image: AssetsManager.historia,
      name: "Historia",
    ),
    CategoriesModel(
      id: "Socjologia",
      image: AssetsManager.socjologia,
      name: "Socjologia",
    ),
    CategoriesModel(
      id: "Językoznawstwo",
      image: AssetsManager.jezykoznawstwo,
      name: "Językoznawstwo",
    ),
    CategoriesModel(
      id: "Poezja",
      image: AssetsManager.poezja,
      name: "Poezja",
    ),
    CategoriesModel(
      id: "Prace doktorskie",
      image: AssetsManager.praceDoktorskie,
      name: "Prace doktorskie",
    ),
    CategoriesModel(
      id: "Czasopisma",
      image: AssetsManager.czasopismaNaukowe,
      name: "Czasopisma",
    ),
    CategoriesModel(
      id: "Monografie",
      image: AssetsManager.monografie,
      name: "Monografie",
    ),
    CategoriesModel(
      id: "Powieści klasyczne",
      image: AssetsManager.powiesciKlasyczne,
      name: "Powieści klasyczne",
    ),
    CategoriesModel(
      id: "Horror",
      image: AssetsManager.horror,
      name: "Horror",
    ),
    CategoriesModel(
      id: "Science fiction",
      image: AssetsManager.scienceFiction,
      name: "Science fiction",
    ),
    CategoriesModel(
      id: "Romanse",
      image: AssetsManager.romanse,
      name: "Romanse",
    )];
}