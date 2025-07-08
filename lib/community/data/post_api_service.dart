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

  Future<Post> updatePost(int id, String title, String content, List<String> mediaUrls, {String? token}) async {
    final url = Uri.parse('$baseUrl/posts/$id');
    final bodyData = json.encode({
      'title': title,
      'content': content,
      'media_urls': mediaUrls,
    });
    print('updatePost request url: $url');
    print('updatePost request body: $bodyData');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    print('updatePost headers: $headers');
    final response = await http.put(
      url,
      headers: headers,
      body: bodyData,
    );
    print('updatePost status: ${response.statusCode}');
    print('updatePost body: ${response.body}');
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return Post.fromJson(json.decode(response.body));
    } else if (response.statusCode == 204 || response.body.isEmpty) {
      return Post(
        id: id,
        title: title,
        content: content,
        mediaUrls: mediaUrls,
        userId: 0,
        username: '',
        originalPostId: null,
        likesCount: 0,
        dislikesCount: 0,
        comments: [],
      );
    } else {
      throw Exception('Failed to update post');
    }
  }

  Future<Comment> updateComment(int postId, int commentId, String content, {String? token}) async {
    final url = Uri.parse('$baseUrl/posts/$postId/comment/$commentId');
    final bodyData = json.encode({'content': content});
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    print('updateComment request url: $url');
    print('updateComment request body: $bodyData');
    print('updateComment headers: $headers');
    final response = await http.put(
      url,
      headers: headers,
      body: bodyData,
    );
    print('updateComment status: ${response.statusCode}');
    print('updateComment body: ${response.body}');
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return Comment.fromJson(json.decode(response.body));
    } else if (response.statusCode == 204 || response.body.isEmpty) {
      return Comment(
        id: commentId,
        content: content,
        userId: 0,
        postId: postId,
        username: '',
      );
    } else {
      throw Exception('Failed to update comment');
    }
  }

  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete post');
    }
  }

  Future<void> deleteComment(int postId, int commentId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/posts/$postId/comment/$commentId'),
    );
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete comment');
    }
  }
}
