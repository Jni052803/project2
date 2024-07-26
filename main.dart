// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'models.dart';
import 'checkout_page.dart';
import 'review_page.dart';
import 'reviews_page.dart';
import 'cart_provider.dart';
import 'review_manager.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  final _secureStorage = const FlutterSecureStorage();

  Future<void> _signIn() async {
    setState(() {
      _errorMessage = null;
    });
    final username = _usernameController.text;
    final password = _passwordController.text;

    final storedPassword = await _secureStorage.read(key: username);
    
    if (mounted) {
      if (storedPassword == password) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        setState(() {
          _errorMessage = 'Invalid username or password';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: const Text('Sign In'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignUpPage(secureStorage: _secureStorage)),
                );
              },
              child: const Text('Don\'t have an account? Sign Up'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  final FlutterSecureStorage secureStorage;

  const SignUpPage({super.key, required this.secureStorage});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _signUp() async {
    setState(() {
      _errorMessage = null;
    });
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      final storedPassword = await widget.secureStorage.read(key: username);
      
      // Check if widget is still mounted before updating state or navigating
      if (mounted) {
        if (storedPassword != null) {
          setState(() {
            _errorMessage = 'Username already exists';
          });
        } else {
          await widget.secureStorage.write(key: username, value: password);
          if (mounted) {
            Navigator.pop(context);
          }
        }
      }
    } else {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              child: const Text('Sign Up'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Restaurant> restaurants = [
    Restaurant(
      name: 'McDonald\'s',
      menu: [
        MenuItem(name: 'Big Mac', price: 5.99),
        MenuItem(name: 'Fries', price: 2.99),
        MenuItem(name: 'McNuggets', price: 4.99),
      ],
    ),
    Restaurant(
      name: 'Subway',
      menu: [
        MenuItem(name: 'Turkey Sandwich', price: 6.99),
        MenuItem(name: 'Veggie Delight', price: 5.99),
        MenuItem(name: 'Chicken Teriyaki', price: 7.99),
      ],
    ),
    Restaurant(
      name: 'KFC',
      menu: [
        MenuItem(name: 'Fried Chicken', price: 9.99),
        MenuItem(name: 'Chicken Sandwich', price: 5.99),
        MenuItem(name: 'Mashed Potatoes', price: 2.99),
      ],
    ),
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Food Delivery App'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Cart'),
              Tab(text: 'Address'),
              Tab(text: 'Reviews'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHomePage(context),
            const CartPage(),
            const AddressPage(),
            const ReviewsPage(restaurantName: ''), // Adjust if needed
          ],
        ),
      ),
    );
  }

  Widget _buildHomePage(BuildContext context) {
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return ListTile(
          title: Text(restaurant.name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RestaurantMenuPage(restaurant: restaurant),
              ),
            );
          },
        );
      },
    );
  }
}

class RestaurantMenuPage extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantMenuPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: restaurant.menu.length,
              itemBuilder: (context, index) {
                final menuItem = restaurant.menu[index];
                return ListTile(
                  title: Text(menuItem.name),
                  trailing: Text('\$${menuItem.price.toStringAsFixed(2)}'),
                  onTap: () {
                    cartProvider.addItem(menuItem);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${menuItem.name} added to cart'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewPage(restaurantName: restaurant.name),
                  ),
                );
              },
              child: const Text('Leave a Review'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewsPage(restaurantName: restaurant.name),
                  ),
                );
              },
              child: const Text('View Reviews'),
            ),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: cartProvider.items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final cartItem = cartProvider.items[index];
                return ListTile(
                  title: Text(cartItem.item.name),
                  trailing: Text(
                    '\$${(cartItem.item.price * cartItem.quantity).toStringAsFixed(2)}',
                  ),
                  subtitle: Text('Quantity: ${cartItem.quantity}'),
                  onLongPress: () {
                    cartProvider.removeItem(cartItem.item);
                  },
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckoutPage(),
                    ),
                  );
                },
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  AddressPageState createState() => AddressPageState();
}

class AddressPageState extends State<AddressPage> {
  final _addressController = TextEditingController();
  String? _address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Enter your address',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final address = _addressController.text;
                if (mounted) {
                  setState(() {
                    _address = address;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Address saved: $_address'),
                    ),
                  );
                }
              },
              child: const Text('Save Address'),
            ),
          ],
        ),
      ),
    );
  }
}

