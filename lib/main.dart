import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prosta_aplikcja/consts/theme_data.dart';
import 'package:prosta_aplikcja/providers/cart_provider.dart';
import 'package:prosta_aplikcja/providers/products_provider.dart';
import 'package:prosta_aplikcja/providers/theme_provider.dart';
import 'package:prosta_aplikcja/providers/user_provider.dart';
import 'package:prosta_aplikcja/providers/viewed_recently_provider.dart';
import 'package:prosta_aplikcja/providers/wishlist_provider.dart';
import 'package:prosta_aplikcja/root_screen.dart';
import 'package:prosta_aplikcja/screens/admin/bookedAdmin/booked_screen.dart';
import 'package:prosta_aplikcja/screens/admin/dashborad_screen.dart';
import 'package:prosta_aplikcja/screens/admin/edit_upload_product_form.dart';
import 'package:prosta_aplikcja/screens/admin/seach_screen_admin.dart';
import 'package:prosta_aplikcja/screens/auth/login.dart';
import 'package:prosta_aplikcja/screens/auth/register.dart';
import 'package:prosta_aplikcja/screens/inner_screens/category_screen.dart';
import 'package:prosta_aplikcja/screens/inner_screens/product_details.dart';
import 'package:prosta_aplikcja/screens/inner_screens/update_profile.dart';
import 'package:prosta_aplikcja/screens/inner_screens/viewed_recently.dart';
import 'package:prosta_aplikcja/screens/inner_screens/wishlist_screen.dart';
import 'package:prosta_aplikcja/screens/profile_screen.dart';
import 'package:prosta_aplikcja/screens/seach_screen.dart';
import 'package:prosta_aplikcja/screens/auth/forgot_password.dart';
import 'package:provider/provider.dart';

void main() async {
  await Firebase.initializeApp;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: SelectableText(snapshot.error.toString()),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => ThemeProvider(),
              ),
              ChangeNotifierProvider(create: (_) => ProductsProvider()),
              ChangeNotifierProvider(create: (_) {
                return ViewedProdProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return CartProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return ViewedProdProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return WishlistProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return UserProvider();
              }),
            ],
            child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                title: 'Biblioteka',
                theme: Styles.themeData(
                    isDarkTheme: themeProvider.getIsDarkTheme,
                    context: context),
                home: const LoginScreen(),
                routes: {
                  ProductDetails.routeName: (context) => const ProductDetails(),
                  WishListScreen.routeName: (context) => const WishListScreen(),
                  CategoryScreen.routeName: (context) => const CategoryScreen(),
                  UpdateUserScreen.routeName: (context) =>
                      const UpdateUserScreen(),
                  ViewedRecentlyScreen.routeName: (context) =>
                      const ViewedRecentlyScreen(),
                  RootScreen.routeName: (context) => const RootScreen(),
                  RegisterScreen.routeName: (context) => const RegisterScreen(),
                  LoginScreen.routeName: (context) => const LoginScreen(),
                  ForgotPasswordScreen.routeName: (context) =>
                      const ForgotPasswordScreen(),
                  SearchScreen.routeName: (context) => const SearchScreen(),
                  BookedScreenFree.routeName: (context) =>
                      const BookedScreenFree(),
                  DashboardScreen.routeName: (context) =>
                      const DashboardScreen(),
                  SearchScreenAdmin.routeName: (context) =>
                      const SearchScreenAdmin(),
                  EditOrUploadProductScreen.routeName: (context) =>
                      const EditOrUploadProductScreen(),
                  ProfileScreen.routeName: (context) => const ProfileScreen(),
                },
              );
            }),
          );
        });
  }
}
