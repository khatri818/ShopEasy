import 'package:shopeasy/features/home/domain/entities/product.dart';
// Import sample data or implement data retrieval logic
import 'package:shopeasy/features/home/domain/usecases/fetch_products.dart';

class FilterProducts {
  final FetchProducts fetchProducts; // Inject FetchProducts dependency

  FilterProducts({required this.fetchProducts});

  Future<List<Product>> filterProducts({String? category, String? subcategory}) async {
    List<Product> allProducts = await fetchProducts(); // Fetch all products using the fetchProducts use case

    // Implement filtering logic
    if (category != null && subcategory != null) {
      return allProducts.where((product) => product.category == category && product.subcategory == subcategory).toList();
    }

    if (category != null) {
      return allProducts.where((product) => product.category == category).toList();
    }

    if (subcategory != null) {
      return allProducts.where((product) => product.subcategory == subcategory).toList();
    }

    return allProducts;
  }
}