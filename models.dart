class Restaurant {
  final String name;
  final List<MenuItem> menu;

  Restaurant({required this.name, required this.menu});
}

class MenuItem {
  final String name;
  final double price;

  MenuItem({required this.name, required this.price});
}

class CartItem {
  final MenuItem item;
  int quantity;

  CartItem({required this.item, this.quantity = 1});
}

class Review {
  final String username;
  final String restaurantName;
  final String comment;
  final double rating;

  Review({
    required this.username,
    required this.restaurantName,
    required this.comment,
    required this.rating,
  });
}
