import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopeasy/Basehome.dart';
import 'package:shopeasy/features/home/domain/entities/product.dart';
import 'package:shopeasy/features/home/domain/usecases/favorite_manager.dart';
import 'package:shopeasy/features/home/domain/usecases/fetch_products.dart';

import 'features/auth/presentation/screens/registration_screen.dart';

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

  // Check if phone number exists in shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? phoneNumber = prefs.getString('phoneNumber');

  Widget homeScreen;

  if (phoneNumber != null && phoneNumber.isNotEmpty) {
    homeScreen = MyHomePage(
      fetchProducts: FetchProducts(),
      favoriteManager: FavoriteManager(),
      product: Product(),// Provide FavoriteManager instance here
    ); // Navigate to home page
  } else {
    homeScreen = const RegistrationPage();
  }

  runApp(MyApp(homeScreen: homeScreen));
}

class MyApp extends StatelessWidget {
  final Widget homeScreen;

  const MyApp({super.key, required this.homeScreen});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Auth Check',
      home: homeScreen,
    );
  }
}

