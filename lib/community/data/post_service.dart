import 'dart:convert';
import 'package:http/http.dart' as http;
import 'post_model.dart';

class PostService {
  static const String baseUrl = 'https://buildmaster-api-ddh3asdah2bsggfs.canadacentral-01.azurewebsites.net';

  Future<List<Post>> fetchPosts({int limit = 10, int offset = 0}) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/?limit=$limit&offset=$offset'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener posts');
    }
  }

  Future<Post> createPost({required String title, required String content, List<String>? mediaUrls}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'content': content,
        'media_urls': mediaUrls ?? [],
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear post');
    }
  }

  Future<Comment> commentPost({required int postId, required String content}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts/$postId/comment'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'content': content}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Comment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al comentar post');
    }
  }

  Future<List<Post>> searchPosts(String query, {int limit = 10, int offset = 0}) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/search?q=$query&limit=$limit&offset=$offset'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar posts');
    }
  }

  Future<List<Post>> getPostsByUser(int userId, {int limit = 10, int offset = 0}) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/user/$userId?limit=$limit&offset=$offset'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener posts del usuario');
    }
  }

  Future<void> repost(int postId) async {
    final response = await http.post(Uri.parse('$baseUrl/posts/$postId/repost'));
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al repostear');
    }
  }

  Future<void> removeRepost(int postId) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$postId/repost'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al quitar repost');
    }
  }

  Future<void> likePost(int postId) async {
    final response = await http.post(Uri.parse('$baseUrl/posts/$postId/like'));
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al dar like');
    }
  }

  Future<void> removeLike(int postId) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$postId/like'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al quitar like');
    }
  }

  Future<void> dislikePost(int postId) async {
    final response = await http.post(Uri.parse('$baseUrl/posts/$postId/dislike'));
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al dar dislike');
    }
  }

  Future<void> removeDislike(int postId) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$postId/dislike'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al quitar dislike');
    }
  }

  Future<Post> updatePost(int postId, {String? title, String? content, List<String>? mediaUrls}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$postId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        if (title != null) 'title': title,
        if (content != null) 'content': content,
        if (mediaUrls != null) 'media_urls': mediaUrls,
      }),
    );
    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar post');
    }
  }

  Future<void> deletePost(int postId) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$postId'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar post');
    }
  }

  Future<Comment> updateComment(int postId, int commentId, String content) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$postId/comment/$commentId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'content': content}),
    );
    if (response.statusCode == 200) {
      return Comment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar comentario');
    }
  }

  Future<void> deleteComment(int postId, int commentId) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$postId/comment/$commentId'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar comentario');
    }
  }
}
