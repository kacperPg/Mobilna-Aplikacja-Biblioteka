import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/models/product_model.dart';
import 'package:uuid/uuid.dart';

class ProductsProvider with ChangeNotifier {
   List<ProductModel> products = [];
 
 List<ProductModel> get getProducts {
   fetchProducts();
    return products;
  }

 List<ProductModel> get getProductsFromDB {
     fetchProducts();
    return products;
  }

  ProductModel? findByProdId(String productId) {
    fetchProductsStream();
    if (products.where((element) => element.productId == productId).isEmpty) {
      return null;
    }
    return products.firstWhere((element) => element.productId == productId);
  }

  List<ProductModel> findByCategory({required String categoryName}) {
    fetchProductsStream();
    List<ProductModel> ctgList = products
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
        products.clear();
        for (var element in productsSnapshot.docs) {
          products.insert(0, ProductModel.fromFirestore(element));
        }
      });
      notifyListeners();
      return products;
    } catch (error) {
      rethrow;
    }
  }

  Stream<List<ProductModel>> fetchProductsStream() {
    try {
      return productDB.snapshots().map((snapshot) {
       products = [];
        for (var element in snapshot.docs) {
          products.add( ProductModel.fromFirestore(element));
        }
        return products;
      });
    } catch (e) {
      rethrow;
    }
  }
}
