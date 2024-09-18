import 'package:flutter/material.dart';
import 'package:shopeasy/features/home/domain/entities/product.dart';
import 'package:shopeasy/features/home/domain/usecases/favorite_manager.dart';
import 'package:shopeasy/core/theme/app_theme.dart';
import 'package:shopeasy/features/home/presentation/screens/product_detail_screen.dart';
import 'package:shopeasy/features/cart/domain/usecases/cart_use_cases.dart';

class FavoriteScreen extends StatefulWidget {
  final FavoriteManager favoriteManager;
  final AddToCart addToCart;

  const FavoriteScreen({
    Key? key,
    required this.favoriteManager,
    required this.addToCart, required Product product,
  }) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<Product>> favoriteProductsFuture;

  @override
  void initState() {
    super.initState();
    favoriteProductsFuture = widget.favoriteManager.getFavoriteProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites ♡',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.appBarGradient,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Product>>(
        future: favoriteProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading favorites'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite products'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final product = snapshot.data![index];
                return _buildProductTile(product);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildProductTile(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              product: product,
              addToCart: widget.addToCart,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      product.description,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _reloadFavorites() {
    setState(() {
      favoriteProductsFuture = widget.favoriteManager.getFavoriteProducts();
    });
  }
}
