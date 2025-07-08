import 'package:flutter/material.dart';
import '../models/post.dart';

class CommunityProvider extends ChangeNotifier {
  final List<Post> _favoritePosts = [];

  List<Post> get favoritePosts => List.unmodifiable(_favoritePosts);

  void toggleFavorite(Post post) {
    if (_favoritePosts.contains(post)) {
      _favoritePosts.remove(post);
    } else {
      _favoritePosts.add(post);
    }
    notifyListeners();
  }

  bool isFavorite(Post post) => _favoritePosts.contains(post);
}
