import 'package:flutter/material.dart';
import 'package:shopeasy/core/theme/app_theme.dart';
import 'package:shopeasy/features/home/domain/entities/product.dart';
import 'package:shopeasy/features/cart/domain/usecases/cart_use_cases.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final AddToCart addToCart;

  const ProductDetailPage({super.key,
    required this.product,
    required this.addToCart,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;
  String _selectedSize = 'M'; // Initial size selection
  Color _selectedColor = Colors.red;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Set background color for the container
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Image.asset(
                widget.product.imageUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.scaleDown,
              ),
            ),
            const SizedBox(height: 26.0),
            // Product name and price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18.0),
            // Product description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16.0),
              child: Text(
                widget.product.description,
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            const SizedBox(height: 16.0,),
            // Quantity selector
            // Quantity selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Text(
                    'Quantity ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    width: 32.0,
                    height: 32.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.remove, color: Colors.black),
                      iconSize: 16.0,
                      onPressed: () {
                        setState(() {
                          if (_quantity > 1) _quantity--;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0), // Adjust the spacing as needed
                  Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold, // Make the quantity text bold
                    ),
                  ),
                  const SizedBox(width: 8.0), // Adjust the spacing as needed
                  Container(
                    width: 32.0,
                    height: 32.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.black),
                      iconSize: 16.0,
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // Available size section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Sizes',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      _buildSizeOption('S'),
                      const SizedBox(width: 8.0),
                      _buildSizeOption('M'),
                      const SizedBox(width: 8.0),
                      _buildSizeOption('L'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // Available colors section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Colors',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      _buildColorOption(Colors.red),
                      const SizedBox(width: 8.0),
                      _buildColorOption(Colors.blue),
                      const SizedBox(width: 8.0),
                      _buildColorOption(Colors.green),
                      const SizedBox(width: 8.0),
                      _buildColorOption(Colors.yellow),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${(widget.product.price * _quantity).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  for (int i = 0; i < _quantity; i++) {
                    widget.addToCart.call(widget.product);
                  }
                  // Provide feedback to the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added to Cart'),
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Button border radius
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 26.0), // Button padding
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: _selectedColor == color ? Colors.purple : Colors.grey,
            width: 3.0,
          ),
          color: color,
        ),
      ),
    );
  }


  Widget _buildSizeOption(String size) {
    Color borderColor = _selectedSize == size ? Colors.blue : Colors.grey;
    Color textColor = _selectedSize == size ? Colors.white : Colors.black;
    Color backgroundColor = _selectedSize == size ? Colors.purple : Colors.transparent;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = size;
        });
      },
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: borderColor,
            width: 2.0,
          ),
          color: backgroundColor, // Background color
        ),
        child: Text(
          size,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
