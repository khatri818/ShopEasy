// fetch_products.dart
import 'package:shopeasy/features/home/domain/entities/product.dart';
import 'package:shopeasy/features/home/data/sample_data.dart';

class FetchProducts {
  Future<List<Product>> call() async {
    return sampleProducts;
  }
}
