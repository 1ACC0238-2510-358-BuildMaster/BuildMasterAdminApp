import 'package:flutter/material.dart';
import '../models/post.dart';
import '../../data/post_api_service.dart';

class CommunityProvider extends ChangeNotifier {
  final List<Post> _favoritePosts = [];
  final List<Post> _posts = [];
  final PostApiService _apiService = PostApiService();
  bool _isLoading = false;
  String? _error;

  List<Post> get favoritePosts => List.unmodifiable(_favoritePosts);
  List<Post> get posts => List.unmodifiable(_posts);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPosts({int limit = 10, int offset = 0}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final fetched = await _apiService.fetchPosts(limit: limit, offset: offset);
      _posts.clear();
      _posts.addAll(fetched);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchPosts(String query, {int limit = 10, int offset = 0}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final results = await _apiService.searchPosts(query, limit: limit, offset: offset);
      _posts.clear();
      _posts.addAll(results);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createPost(String title, String content, List<String> mediaUrls) async {
    try {
      final post = await _apiService.createPost(title, content, mediaUrls);
      _posts.insert(0, post);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updatePost(int id, String title, String content, List<String> mediaUrls) async {
    try {
      final updated = await _apiService.updatePost(id, title, content, mediaUrls);
      final idx = _posts.indexWhere((p) => p.id == id);
      if (idx != -1) {
        _posts[idx] = updated;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deletePost(int id) async {
    try {
      await _apiService.deletePost(id);
      _posts.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

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
