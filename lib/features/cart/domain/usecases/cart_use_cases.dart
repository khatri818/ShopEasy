import 'package:shopeasy/features/cart/domain/entities/cart.dart';
import 'package:shopeasy/features/home/domain/entities/product.dart';

class AddToCart {
  final List<CartItem> _cartItems = [];

  void call(Product product) {
    final existingItemIndex = _cartItems.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex].quantity++;
    } else {
      _cartItems.add(CartItem(product: product, quantity: 1));
    }
  }

  void remove(Product product) {
    final existingItemIndex = _cartItems.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (existingItemIndex != -1) {
      if (_cartItems[existingItemIndex].quantity > 1) {
        _cartItems[existingItemIndex].quantity--;
      } else {
        _cartItems.removeAt(existingItemIndex);
      }
    }
  }

  void delete(Product product) {
    _cartItems.removeWhere((item) => item.product.id == product.id);
  }

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  double get totalAmount {
    return _cartItems.fold(
      0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
    );
  }
}
