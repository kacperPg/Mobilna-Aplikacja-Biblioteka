import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:prosta_aplikcja/providers/cart_provider.dart';
import 'package:prosta_aplikcja/providers/products_provider.dart';
import 'package:prosta_aplikcja/providers/user_provider.dart';
import 'package:prosta_aplikcja/providers/wishlist_provider.dart';
import 'package:prosta_aplikcja/screens/booked/booked_screen.dart';
import 'package:prosta_aplikcja/screens/home_page.dart';
import 'package:prosta_aplikcja/screens/profile_screen.dart';
import 'package:prosta_aplikcja/screens/seach_screen.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
    static const routeName = '/RootScreen';
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late PageController controller;
  bool isLoadingProd = true;
  int currentScreen = 0;
  late List<Widget> screens;

@override
  void initState() {
    super.initState();
    screens = const [
      HomePage(),
      SearchScreen(),
      BookedScreen(),
      ProfileScreen(),
    ];
    controller = PageController(initialPage: currentScreen);
  }

  Future<void> fetchFCT() async {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // final wishlistsProvider =
    //     Provider.of<WishlistProvider>(context, listen: false);
    // try {
    //   Future.wait({
    //     productsProvider.fetchProduct(),
    //     userProvider.fetchUserInfo(),
    //   });
    //   Future.wait({
    //     cartProvider.fetchCart(),
    //     wishlistsProvider.fetchWishlist(),
    //   });
    // } catch (error) {
    //   log(error.toString());
    // }
  }

  @override
  void didChangeDependencies() {
    if (isLoadingProd) {
      fetchFCT();
    }
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen,
        backgroundColor: Theme.of(context).cardColor,
        height: kBottomNavigationBarHeight,
        elevation: 2,
        onDestinationSelected: (value) {
          setState(() {
            currentScreen = value;
          });
          controller.jumpToPage(currentScreen);
        },
        destinations: const [
          NavigationDestination(
              selectedIcon: Icon(IconlyBold.home),
              icon: Icon(IconlyLight.home),
              label: "Katalog"),
          NavigationDestination(
              selectedIcon: Icon(IconlyBold.search),
              icon: Icon(IconlyLight.search),
              label: "Szukaj"),
          NavigationDestination(
              selectedIcon: Icon(IconlyBold.bookmark),
              icon: Icon(IconlyLight.bookmark),
              label: "Rezerwacje"),
          NavigationDestination(
              selectedIcon: Icon(IconlyBold.profile),
              icon: Icon(IconlyLight.profile),
              label: "Profil"),
        ],
      ),
    );
  }
}
