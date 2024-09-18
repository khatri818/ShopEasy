import 'package:flutter/material.dart';
import 'package:shopeasy/features/home/domain/entities/product.dart';
import 'package:shopeasy/features/home/domain/usecases/fetch_products.dart';
import 'package:shopeasy/features/home/presentation/widgets/product_item.dart';
import 'package:shopeasy/core/theme/app_theme.dart';
import 'package:shopeasy/features/home/presentation/widgets/category_button.dart';
import 'package:shopeasy/features/home/domain/usecases/favorite_manager.dart';
import 'package:shopeasy/features/cart/domain/usecases/cart_use_cases.dart';
import 'package:shopeasy/features/favorite/presentation/screens/favorite_screen.dart';
import 'package:shopeasy/features/auth/presentation/screens/registration_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final FetchProducts fetchProducts;
  final AddToCart addToCart;
  final Product product;

  const HomeScreen({Key? key, required this.fetchProducts, required this.addToCart, required this.product}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _fetchProductsFuture;
  String _selectedCategory = 'All Products';

  final FavoriteManager favoriteManager = FavoriteManager();

  @override
  void initState() {
    super.initState();
    _fetchProductsFuture = widget.fetchProducts();
  }

  Widget _buildCategoryButton(String category, String imagePath) {
    return CategoryButton(
      category: category,
      isSelected: _selectedCategory == category,
      onPressed: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      imagePath: imagePath,
    );
  }

  void _navigateToFavorites(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoriteScreen(favoriteManager: favoriteManager,addToCart: widget.addToCart,product: widget.product,),
      ),
    );
  }

  void _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('phoneNumber');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const RegistrationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ShopEasy',
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                _navigateToFavorites(context);
              },
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            _logout(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 50, // Adjust the height as needed
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adjust the value as needed
                    child: _buildCategoryButton('All Products', 'assets/category_images/all_cat.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adjust the value as needed
                    child: _buildCategoryButton('Shoes', 'assets/category_images/cat1.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adjust the value as needed
                    child: _buildCategoryButton('Jackets', 'assets/category_images/cat2.jpg'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _fetchProductsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error fetching products'),
                    );
                  } else {
                    List<Product> filteredProducts = snapshot.data!;
                    if (_selectedCategory != 'All Products') {
                      filteredProducts = filteredProducts.where((product) =>
                      product.category == _selectedCategory).toList();
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.all(8.0), // Add padding around the GridView
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return ProductItem(
                          product: filteredProducts[index],
                          favoriteManager: favoriteManager,
                          addToCart: widget.addToCart,
                        );
                      },
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
