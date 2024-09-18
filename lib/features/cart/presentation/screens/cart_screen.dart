import 'package:flutter/material.dart';
import 'package:shopeasy/core/theme/app_theme.dart';
import 'package:shopeasy/features/cart/domain/usecases/cart_use_cases.dart';
import 'package:shopeasy/features/checkout/presentation/screens/checkout_screen.dart'; // Import the CheckoutPage

class CartScreen extends StatefulWidget {
  final AddToCart addToCart;

  const CartScreen(this.addToCart, {super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double taxAndFees = widget.addToCart.totalAmount * 0.1; // Example 10% tax
    final double delivery = 0.0; // Free delivery
    final double total = widget.addToCart.totalAmount + taxAndFees + delivery;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyCart',
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
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          if (widget.addToCart.cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal', style: TextStyle(fontSize: 16)),
                            Text('\$${widget.addToCart.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tax and Fees', style: TextStyle(fontSize: 16)),
                            Text('\$${taxAndFees.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delivery', style: TextStyle(fontSize: 16)),
                            Text('Free', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                            Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          widget.addToCart.cartItems.isEmpty
              ? const Expanded(
            child: Center(
              child: Text(
                'No items in cart',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          )
              : Expanded(
            child: ListView.builder(
              itemCount: widget.addToCart.cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                final cartItem = widget.addToCart.cartItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 4.0,
                    color: Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      leading: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: AssetImage(cartItem.product.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        cartItem.product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('\$${cartItem.product.price} x ${cartItem.quantity}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () {
                              if (cartItem.quantity > 1) {
                                setState(() {
                                  widget.addToCart.remove(cartItem.product);
                                });
                              } else {
                                _showDeleteConfirmationDialog().then((confirmed) {
                                  if (confirmed) {
                                    setState(() {
                                      widget.addToCart.remove(cartItem.product);
                                    });
                                  }
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: Colors.green),
                            onPressed: () {
                              setState(() {
                                widget.addToCart.call(cartItem.product);
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.grey),
                            onPressed: () {
                              _showDeleteConfirmationDialog().then((confirmed) {
                                if (confirmed) {
                                  setState(() {
                                    widget.addToCart.delete(cartItem.product);
                                  });
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.addToCart.cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CheckoutPage(totalAmount: total)),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Checkout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
