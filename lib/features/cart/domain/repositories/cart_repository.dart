import 'package:shopeasy/features/cart/domain/entities/cart.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<void> clearCart();
  Future<void> addToCart(CartItem item);
  Future<void> removeFromCart(String productName);
  Future<void> updateCartItem(CartItem item);
}
