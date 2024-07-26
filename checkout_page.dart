import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  CheckoutPageState createState() => CheckoutPageState();
}

class CheckoutPageState extends State<CheckoutPage> {
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();
  final nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Create a logger instance
  final _logger = Logger('CheckoutPage');

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      // Retrieve data from controllers
      final cardNumber = cardNumberController.text;
      final expiryDate = expiryDateController.text;
      final cvv = cvvController.text;
      final name = nameController.text;

      // Use the logger to log information
      _logger.info('Card Number: $cardNumber');
      _logger.info('Expiry Date: $expiryDate');
      _logger.info('CVV: $cvv');
      _logger.info('Name: $name');

      // For demonstration purposes
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment processed for $name'),
        ),
      );

      // Clear fields after payment
      cardNumberController.clear();
      expiryDateController.clear();
      cvvController.clear();
      nameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name on Card'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: cardNumberController,
                decoration: const InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your card number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: expiryDateController,
                decoration: const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the expiry date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: cvvController,
                decoration: const InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the CVV';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _processPayment,
                child: const Text('Pay Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
