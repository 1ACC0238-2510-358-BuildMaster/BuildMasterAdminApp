import 'dart:convert';
import 'package:http/http.dart' as http;
import '../presentation/models/post.dart';


class PostApiService {
  static const String baseUrl = 'https://buildmaster-api-ddh3asdah2bsggfs.canadacentral-01.azurewebsites.net';

  Future<List<Post>> fetchPosts({int limit = 10, int offset = 0}) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/?limit=$limit&offset=$offset'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<List<Post>> searchPosts(String query, {int limit = 10, int offset = 0}) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/search?query=$query&limit=$limit&offset=$offset'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search posts');
    }
  }

  Future<Post> createPost(String title, String content, List<String> mediaUrls) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'content': content,
        'media_urls': mediaUrls,
      }),
    );
    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create post');
    }
  }

  Future<Post> updatePost(int id, String title, String content, List<String> mediaUrls) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'content': content,
        'media_urls': mediaUrls,
      }),
    );
    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update post');
    }
  }

  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete post');
    }
  }
}

