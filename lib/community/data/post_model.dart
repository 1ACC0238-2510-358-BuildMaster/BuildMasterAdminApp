class Comment {
  final int id;
  final String content;
  final int userId;
  final int postId;
  final String username;

  Comment({
    required this.id,
    required this.content,
    required this.userId,
    required this.postId,
    required this.username,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      userId: json['user_id'],
      postId: json['post_id'],
      username: json['username'],
    );
  }
}

class Post {
  final int id;
  final String title;
  final String content;
  final List<String> mediaUrls;
  final int userId;
  final String username;
  final int? originalPostId;
  final int likesCount;
  final int dislikesCount;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.mediaUrls,
    required this.userId,
    required this.username,
    required this.originalPostId,
    required this.likesCount,
    required this.dislikesCount,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      mediaUrls: List<String>.from(json['media_urls'] ?? []),
      userId: json['user_id'],
      username: json['username'],
      originalPostId: json['original_post_id'],
      likesCount: json['likes_count'],
      dislikesCount: json['dislikes_count'],
      comments: (json['comments'] as List<dynamic>? ?? [])
          .map((c) => Comment.fromJson(c))
          .toList(),
    );
  }
}

