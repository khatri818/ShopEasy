import 'package:flutter/material.dart';
import 'package:shopeasy/features/home/domain/entities/product.dart';
import 'package:shopeasy/features/home/presentation/screens/product_detail_screen.dart';
import 'package:shopeasy/features/home/domain/usecases/favorite_manager.dart';
import 'package:shopeasy/features/cart/domain/usecases/cart_use_cases.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  final FavoriteManager favoriteManager;
  final AddToCart addToCart;

  ProductItem({
    required this.product,
    required this.favoriteManager,
    required this.addToCart,
    Key? key,
  }) : super(key: key ?? ValueKey(product.id));

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  late Future<bool> _isFavoriteFuture;

  @override
  void initState() {
    super.initState();
    _isFavoriteFuture = widget.favoriteManager.isFavorite(widget.product);
  }

  Future<void> _toggleFavorite() async {
    await widget.favoriteManager.toggleFavorite(widget.product);
    setState(() {
      _isFavoriteFuture = widget.favoriteManager.isFavorite(widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3, // Add elevation for shadow effect
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Add rounded corners
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0), // Match the card's borderRadius
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(
                product: widget.product,
                addToCart: widget.addToCart,
              ),
            ),
          );
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.white, // Set background color to white
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(9.0),
                        topRight: Radius.circular(9.0),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(widget.product.imageUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(9.0),
                            topRight: Radius.circular(9.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 8.0,
              right: 8.0,
              child: FutureBuilder<bool>(
                future: _isFavoriteFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Icon(Icons.error, color: Colors.red);
                  } else {
                    bool isFavorite = snapshot.data ?? false;
                    return IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: _toggleFavorite,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
