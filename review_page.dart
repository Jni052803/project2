import 'package:flutter/material.dart';
import 'models.dart';
import 'review_manager.dart';

class ReviewPage extends StatefulWidget {
  final String restaurantName;

  const ReviewPage({super.key, required this.restaurantName});

  @override
  ReviewPageState createState() => ReviewPageState();
}

class ReviewPageState extends State<ReviewPage> {
  final _usernameController = TextEditingController();
  final _commentController = TextEditingController();
  double _rating = 0.0;

  void _submitReview() {
    final username = _usernameController.text;
    final comment = _commentController.text;

    if (username.isEmpty || comment.isEmpty || _rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final review = Review(
      username: username,
      restaurantName: widget.restaurantName,
      comment: comment,
      rating: _rating,
    );

    ReviewManager().addReview(review);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review submitted')),
    );

    _usernameController.clear();
    _commentController.clear();
    setState(() {
      _rating = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(labelText: 'Comment'),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            Text('Rating: ${_rating.toStringAsFixed(1)}'),
            Slider(
              value: _rating,
              min: 0.0,
              max: 5.0,
              divisions: 5,
              label: _rating.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReview,
              child: const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}
