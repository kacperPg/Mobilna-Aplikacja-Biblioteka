import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/models/product_model.dart';
import 'package:uuid/uuid.dart';

class ProductsProvider with ChangeNotifier {
   List<ProductModel> _products = [];
 
 List<ProductModel> get getProducts {
   fetchProducts();
    return _products;
  }

 List<ProductModel> get getProductsFromDB {
     fetchProducts();
    return _products;
  }

  ProductModel? findByProdId(String productId) {
    if (_products.where((element) => element.productId == productId).isEmpty) {
      return null;
    }
    return _products.firstWhere((element) => element.productId == productId);
  }

  List<ProductModel> findByCategory({required String categoryName}) {
    fetchProductsStream();
    List<ProductModel> ctgList = _products
        .where((element) => element.productCategory
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return ctgList;
  }

  List<ProductModel> searchQuery(
      {required String searchText, required List<ProductModel> passedList}) {
    List<ProductModel> searchList = passedList
        .where(
          (element) => element.productTitle.toLowerCase().contains(
                searchText.toLowerCase(),
              ),
        )
        .toList();
    return searchList;
  }

  final productDB = FirebaseFirestore.instance.collection("products");
  
  Future<List<ProductModel>> fetchProducts() async {
    try {
      await productDB.get().then((productsSnapshot) {
        _products.clear();
        for (var element in productsSnapshot.docs) {
          _products.insert(0, ProductModel.fromFirestore(element));
        }
      });
      notifyListeners();
      return _products;
    } catch (error) {
      rethrow;
    }
  }

  Stream<List<ProductModel>> fetchProductsStream() {
    try {
      return productDB.snapshots().map((snapshot) {
       _products = [];
        for (var element in snapshot.docs) {
          _products.add( ProductModel.fromFirestore(element));
        }
        return _products;
      });
    } catch (e) {
      rethrow;
    }
  }

  List<ProductModel> products = [
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Podstawy algorytmów",
      productAutor: "Donald Knuth",
      productCategory: "Informatyka",
      productDescription: "Podstawowa książka na temat algorytmów.",
      productImage: "https://www.flutterengineering.io/bookcover_isbn.png",
      productQuantity: "5",
    ),
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Zarys chemii organicznej",
      productAutor: "John Smith",
      productCategory: "Chemia",
      productDescription: "Kompletny przewodnik po chemii organicznej.",
      productImage: "https://www.flutterengineering.io/bookcover_isbn.png",
      productQuantity: "10",
    ),
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Historia starożytnego Rzymu",
      productAutor: "Jane Doe",
      productCategory: "Historia",
      productDescription: "Dogłębne badania nad starożytnym Rzymem.",
      productImage: "https://www.flutterengineering.io/bookcover_isbn.png",
      productQuantity: "8",
    ),
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Teorie ekonomiczne XXI wieku",
      productAutor: "Adam Smith",
      productCategory: "Ekonomia",
      productDescription: "Analiza współczesnych teorii ekonomicznych.",
      productImage: "https://www.flutterengineering.io/bookcover_isbn.png",
      productQuantity: "12",
    ),
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Nowoczesne inżynieria lądowa",
      productAutor: "Robert Lang",
      productCategory: "Inżynieria",
      productDescription: "Przegląd współczesnych technologii budowlanych.",
      productImage: "https://www.flutterengineering.io/bookcover_isbn.png",
      productQuantity: "7",
    ),
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Koncepcje psychologiczne",
      productAutor: "Sigmund Freud",
      productCategory: "Psychologia",
      productDescription: "Omówienie kluczowych teorii psychologicznych.",
      productImage: "https://www.flutterengineering.io/bookcover_isbn.png",
      productQuantity: "9",
    ),
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Klasyczne powieści grozy",
      productAutor: "Edgar Allan Poe",
      productCategory: "Horror",
      productDescription: "Zbiór przerażających historii grozy.",
      productImage: "https://www.flutterengineering.io/bookcover_isbn.png",
      productQuantity: "15",
    ),
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Podróż do gwiazd",
      productAutor: "Isaac Asimov",
      productCategory: "Science fiction",
      productDescription: "Eksploracja kosmosu w formie science fiction.",
      productImage: "https://www.flutterengineering.io/bookcover_isbn.png",
      productQuantity: "4",
    ),
  ];
}
