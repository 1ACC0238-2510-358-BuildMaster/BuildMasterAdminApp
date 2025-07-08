import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../../data/post_api_service.dart';
import '../../../user/presentation/providers/user_provider.dart';
import 'dart:convert';

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

  Future<void> updatePost(dynamic id, String title, String content, List<String> mediaUrls, BuildContext context) async {
    try {
      // Convertir id a int si es String
      final int postId = id is int ? id : int.parse(id.toString());
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final rawToken = userProvider.token;
      String? accessToken;

      if (rawToken != null) {
        // Si el token es un String que contiene access_token, extraerlo
        if (rawToken.contains('access_token:')) {
          // Extraer solo el valor del access_token del formato {access_token:..., token_type:...}
          final tokenStart = rawToken.indexOf('access_token:') + 'access_token:'.length;
          final tokenEnd = rawToken.indexOf(',', tokenStart);
          if (tokenEnd != -1) {
            accessToken = rawToken.substring(tokenStart, tokenEnd);
          } else {
            // Si no hay coma, tomar hasta el final menos la llave
            accessToken = rawToken.substring(tokenStart, rawToken.length - 1);
          }
        } else if (rawToken.trim().startsWith('{') && rawToken.contains('access_token')) {
          try {
            final decoded = jsonDecode(rawToken);
            if (decoded is Map && decoded['access_token'] is String) {
              accessToken = decoded['access_token'] as String;
            }
          } catch (_) {
            accessToken = null;
          }
        } else {
          // Si es un token plano (JWT o similar), usarlo directamente
          accessToken = rawToken;
        }
      }

      print('TOKEN ENVIADO updatePost: ' + (accessToken ?? 'NULL'));
      await _apiService.updatePost(postId, title, content, mediaUrls, token: accessToken);
      await fetchPosts();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateComment(int postId, int commentId, String content, BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final rawToken = userProvider.token;
      String? accessToken;

      if (rawToken != null) {
        // Si el token es un String que contiene access_token, extraerlo
        if (rawToken.contains('access_token:')) {
          // Extraer solo el valor del access_token del formato {access_token:..., token_type:...}
          final tokenStart = rawToken.indexOf('access_token:') + 'access_token:'.length;
          final tokenEnd = rawToken.indexOf(',', tokenStart);
          if (tokenEnd != -1) {
            accessToken = rawToken.substring(tokenStart, tokenEnd);
          } else {
            // Si no hay coma, tomar hasta el final menos la llave
            accessToken = rawToken.substring(tokenStart, rawToken.length - 1);
          }
        } else if (rawToken.trim().startsWith('{') && rawToken.contains('access_token')) {
          try {
            final decoded = jsonDecode(rawToken);
            if (decoded is Map && decoded['access_token'] is String) {
              accessToken = decoded['access_token'] as String;
            }
          } catch (_) {
            accessToken = null;
          }
        } else {
          // Si es un token plano (JWT o similar), usarlo directamente
          accessToken = rawToken;
        }
      }

      print('TOKEN ENVIADO updateComment: ' + (accessToken ?? 'NULL'));
      await _apiService.updateComment(postId, commentId, content, token: accessToken);
      await fetchPosts();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deletePost(int id, BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final rawToken = userProvider.token;
      String? accessToken;

      if (rawToken != null) {
        // Si el token es un String que contiene access_token, extraerlo
        if (rawToken.contains('access_token:')) {
          // Extraer solo el valor del access_token del formato {access_token:..., token_type:...}
          final tokenStart = rawToken.indexOf('access_token:') + 'access_token:'.length;
          final tokenEnd = rawToken.indexOf(',', tokenStart);
          if (tokenEnd != -1) {
            accessToken = rawToken.substring(tokenStart, tokenEnd);
          } else {
            // Si no hay coma, tomar hasta el final menos la llave
            accessToken = rawToken.substring(tokenStart, rawToken.length - 1);
          }
        } else if (rawToken.trim().startsWith('{') && rawToken.contains('access_token')) {
          try {
            final decoded = jsonDecode(rawToken);
            if (decoded is Map && decoded['access_token'] is String) {
              accessToken = decoded['access_token'] as String;
            }
          } catch (_) {
            accessToken = null;
          }
        } else {
          // Si es un token plano (JWT o similar), usarlo directamente
          accessToken = rawToken;
        }
      }

      print('TOKEN ENVIADO deletePost: ' + (accessToken ?? 'NULL'));
      await _apiService.deletePost(id, token: accessToken);
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

  Future<void> deleteComment(int postId, int commentId, BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final rawToken = userProvider.token;
      String? accessToken;

      if (rawToken != null) {
        // Si el token es un String que contiene access_token, extraerlo
        if (rawToken.contains('access_token:')) {
          // Extraer solo el valor del access_token del formato {access_token:..., token_type:...}
          final tokenStart = rawToken.indexOf('access_token:') + 'access_token:'.length;
          final tokenEnd = rawToken.indexOf(',', tokenStart);
          if (tokenEnd != -1) {
            accessToken = rawToken.substring(tokenStart, tokenEnd);
          } else {
            // Si no hay coma, tomar hasta el final menos la llave
            accessToken = rawToken.substring(tokenStart, rawToken.length - 1);
          }
        } else if (rawToken.trim().startsWith('{') && rawToken.contains('access_token')) {
          try {
            final decoded = jsonDecode(rawToken);
            if (decoded is Map && decoded['access_token'] is String) {
              accessToken = decoded['access_token'] as String;
            }
          } catch (_) {
            accessToken = null;
          }
        } else {
          // Si es un token plano (JWT o similar), usarlo directamente
          accessToken = rawToken;
        }
      }

      print('TOKEN ENVIADO deleteComment: ' + (accessToken ?? 'NULL'));
      await _apiService.deleteComment(postId, commentId, token: accessToken);
      // Refrescar los posts para reflejar el cambio
      await fetchPosts();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
