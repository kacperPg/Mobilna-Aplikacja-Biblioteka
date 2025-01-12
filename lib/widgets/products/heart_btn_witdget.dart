import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:prosta_aplikcja/providers/wishlist_provider.dart';
import 'package:prosta_aplikcja/services/my_app_methods.dart';
import 'package:provider/provider.dart';

class HeartButtonWidgetState extends StatefulWidget {
  final double size;
  final Color colors;
  final String productId;

  const HeartButtonWidgetState({
    super.key,
    this.size = 22,
    this.colors = Colors.transparent,
    required this.productId,
  });

  @override
  State<HeartButtonWidgetState> createState() => _HeartButtonWidgetStateState();
}

class _HeartButtonWidgetStateState extends State<HeartButtonWidgetState> {
   bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final wishlistsProvider = Provider.of<WishlistProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: widget.colors,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        style: IconButton.styleFrom(elevation: 10),
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });
          try {
              wishlistsProvider.addOrRemoveFromWishlist(
              productId: widget.productId,
            );
          } catch (e) {
            await MyAppMethods.showErrorOrWarningDialog(
              context: context,
              subtitle: e.toString(),
              fct: () {},
            );
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        },
        icon: _isLoading
            ? const CircularProgressIndicator()
            : Icon(
                wishlistsProvider.isProdinWishlist(
                  productId: widget.productId,
                )
                    ? IconlyBold.heart
                    : IconlyLight.heart,
                size: widget.size,
                color: wishlistsProvider.isProdinWishlist(
                  productId: widget.productId,
                )
                    ? Colors.red
                    : Colors.grey,
              ),
      ),
    );
  }
}