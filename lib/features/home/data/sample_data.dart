import 'package:shopeasy/features/home/domain/entities/product.dart';

// Define sample product data
final List<Product> sampleProducts = [
  Product(
    id: '1',
    name: 'NIKE SPORTS',
    description: 'Description for Product 1',
    price: 19.99,
    imageUrl: 'assets/product_images/prod1.png', // Example image asset path
    category: 'Shoes', // Example category
    subcategory: 'Shoes', // Example subcategory
  ),
  Product(
    id: '2',
    name: 'Jacket Blue',
    description: 'Description for Product 2',
    price: 9.99,
    imageUrl: 'assets/product_images/prod2.png', // Example image asset path
    category: 'Jackets', // Example category
    subcategory: 'Subcategory 2', // Example subcategory
  ),
  Product(
    id: '3',
    name: 'Product 3',
    description: 'Description for Product 3',
    price: 39.99,
    imageUrl: 'assets/product_images/prod3.jpg', // Example image asset path
    category: 'Category 1', // Example category
    subcategory: 'Subcategory 2', // Example subcategory
  ),
  // Add more sample products as needed
];
