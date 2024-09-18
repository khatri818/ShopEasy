import 'package:shopeasy/features/home/domain/entities/product.dart';

class FavoriteManager {
  // Simulate a database with a list
  List<Product> _favoriteProducts = [];

  // Check if a product is in favorites
  Future<bool> isFavorite(Product product) async {
    return _favoriteProducts.contains(product);
  }

  // Toggle favorite status of a product
  Future<void> toggleFavorite(Product product) async {
    if (_favoriteProducts.contains(product)) {
      _favoriteProducts.remove(product);
    } else {
      _favoriteProducts.add(product);
    }
  }

  // Get all favorite products
  Future<List<Product>> getFavoriteProducts() async {
    return _favoriteProducts;
  }
}
