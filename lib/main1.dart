/*import 'package:flutter/material.dart';
import 'package:shopeasy/features/home/presentation/screens/home_screen.dart';
import 'package:shopeasy/features/favorite/presentation/screens/favorite_screen.dart';
import 'package:shopeasy/features/home/presentation/screens/cart_screen.dart';
import 'package:shopeasy/features/home/domain/usecases/fetch_products.dart';
import 'package:shopeasy/features/home/domain/usecases/favorite_manager.dart'; // Import FavoriteManager

void main() {
  // Instantiate FavoriteManager here
  final favoriteManager = FavoriteManager();

  runApp(MyApp(favoriteManager: favoriteManager));
}

class MyApp extends StatelessWidget {
  // Pass FavoriteManager as a parameter to MyApp
  final FavoriteManager favoriteManager;

  const MyApp({required this.favoriteManager});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShopEasy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Pass FavoriteManager to BottomNavWrapper
      home: BottomNavWrapper(
        fetchProducts: FetchProducts(),
        favoriteManager: favoriteManager,
      ),
    );
  }
}

class BottomNavWrapper extends StatefulWidget {
  final FetchProducts fetchProducts;
  final FavoriteManager favoriteManager;

  const BottomNavWrapper({
    required this.fetchProducts,
    required this.favoriteManager,
  });

  @override
  _BottomNavWrapperState createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(fetchProducts: widget.fetchProducts),
          FavoriteScreen(favoriteManager: widget.favoriteManager),
          //CartScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

//register
class MyHomePage extends StatelessWidget {
  final FetchProducts fetchProducts;
  final FavoriteManager favoriteManager;

  MyHomePage({required this.fetchProducts, required this.favoriteManager});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Shopeasy!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistrationScreen(),
                  ),
                );
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

//main_previous
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shopeasy/Basehome.dart';
import 'package:shopeasy/features/home/domain/usecases/favorite_manager.dart';
import 'package:shopeasy/features/auth/presentation/screens/registration_screen.dart';

// Import FetchProducts class
import 'package:shopeasy/features/home/domain/usecases/fetch_products.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAjOt4h-AAxnVBJ63GDHPJ-QQ9nGRQLJtY',
      appId: '1:557756585735:android:9299f158f222ef898557a2',
      messagingSenderId: '557756585735',
      projectId: 'shopeasy-81d4f',
      storageBucket: 'shopeasy-81d4f.appspot.com',
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Instantiate FetchProducts and FavoriteManager here
    final fetchProducts = FetchProducts();
    final favoriteManager = FavoriteManager();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Auth Check',
      home: MyHomePage(
        fetchProducts: fetchProducts,
        favoriteManager: favoriteManager, // Provide FavoriteManager instance here
      ),
    );
  }
}


*/