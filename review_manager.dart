import 'models.dart';

class ReviewManager {
  static final ReviewManager _instance = ReviewManager._internal();

  factory ReviewManager() => _instance;

  ReviewManager._internal();

  final List<Review> _reviews = [];

  List<Review> getReviewsForRestaurant(String restaurantName) {
    return _reviews.where((review) => review.restaurantName == restaurantName).toList();
  }

  void addReview(Review review) {
    _reviews.add(review);
  }
}
