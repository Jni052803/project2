import 'package:flutter/material.dart';
import 'review_manager.dart';

class ReviewsPage extends StatelessWidget {
  final String restaurantName;

  const ReviewsPage({super.key, required this.restaurantName});

  @override
  Widget build(BuildContext context) {
    final reviews = ReviewManager().getReviewsForRestaurant(restaurantName);

    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews for $restaurantName'),
      ),
      body: reviews.isEmpty
          ? const Center(child: Text('No reviews yet'))
          : ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ListTile(
                  title: Text(review.username),
                  subtitle: Text(review.comment),
                  trailing: Text('${review.rating} ★'),
                );
              },
            ),
    );
  }
}
