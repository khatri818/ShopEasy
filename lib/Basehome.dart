import 'package:flutter/material.dart';
import 'package:shopeasy/features/home/domain/entities/product.dart';
import 'package:shopeasy/features/home/presentation/screens/home_screen.dart';
import 'package:shopeasy/features/home/domain/usecases/fetch_products.dart';
import 'package:shopeasy/features/home/domain/usecases/favorite_manager.dart';
import 'package:shopeasy/features/cart/domain/usecases/cart_use_cases.dart';// Import FavoriteManager
import 'package:shopeasy/features/cart/presentation/screens/cart_screen.dart';
import 'features/Profile/presentation/profile_screen.dart';


void main() {
  // Instantiate FavoriteManager here
  final favoriteManager = FavoriteManager();

  runApp(MyApp(favoriteManager: favoriteManager,addToCart: AddToCart(), product: Product(),));
}

class MyApp extends StatelessWidget {
  // Pass FavoriteManager as a parameter to MyApp
  final FavoriteManager favoriteManager;
  final AddToCart addToCart;
  final Product product;

  const MyApp({super.key, required this.favoriteManager, required this.addToCart, required this.product,});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShopEasy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Pass FavoriteManager to BottomNavWrapper
      home: MyHomePage(
        fetchProducts: FetchProducts(),
        favoriteManager: favoriteManager, product: Product(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  // Pass FetchProducts and FavoriteManager as parameters to MyHomePage
  final FetchProducts fetchProducts;
  final FavoriteManager favoriteManager;
  final Product product;

  const MyHomePage({super.key,
    required this.fetchProducts,
    required this.favoriteManager,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomNavWrapper(
        fetchProducts: fetchProducts,
        favoriteManager: favoriteManager,
        addToCart: AddToCart(),
        product: product,
      ),
    );
  }
}

class BottomNavWrapper extends StatefulWidget {
  final FetchProducts fetchProducts;
  final FavoriteManager favoriteManager;
  final AddToCart addToCart;
  final Product product;

  const BottomNavWrapper({super.key,
    required this.fetchProducts,
    required this.favoriteManager,
    required this.addToCart,
    required this.product,
  });

  @override
  _BottomNavWrapperState createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> {
  int _selectedIndex = 0; // Set initial index to 0 for "Home" screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(fetchProducts: widget.fetchProducts, addToCart: widget.addToCart, product: widget.product,),
          CartScreen(widget.addToCart),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF448AFF), // Selected item text color
        unselectedItemColor: Colors.grey, // Unselected item text color
        elevation: 8.0, // Add a slight elevation
        backgroundColor:  Colors.white, // Background color
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
