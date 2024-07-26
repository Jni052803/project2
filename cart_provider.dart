import 'package:flutter/foundation.dart';
import 'models.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(MenuItem item) {
    final index = _items.indexWhere((cartItem) => cartItem.item == item);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(item: item));
    }
    notifyListeners();
  }

  void removeItem(MenuItem item) {
    _items.removeWhere((cartItem) => cartItem.item == item);
    notifyListeners();
  }

  double get totalPrice => _items.fold(
        0.0,
        (total, cartItem) => total + cartItem.item.price * cartItem.quantity,
      );
}
