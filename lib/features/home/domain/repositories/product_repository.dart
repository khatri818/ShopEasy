import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts();
  Future<List<Product>> filterProducts({String? category, String? subcategory});
// - Future<void> addToCart(Product product);
// - Future<List<Product>> getCartItems();
// - Future<void> removeFromCart(Product product);
}
