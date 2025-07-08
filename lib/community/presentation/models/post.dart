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
      content: json['content'] ?? '',
      mediaUrls: List<String>.from(json['media_urls'] ?? []),
      userId: json['user_id'] ?? 0,
      username: json['username'] ?? '',
      originalPostId: json['original_post_id'],
      likesCount: json['likes_count'] ?? 0,
      dislikesCount: json['dislikes_count'] ?? 0,
      comments: (json['comments'] as List<dynamic>? ?? [])
          .map((c) => Comment.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'media_urls': mediaUrls,
      'user_id': userId,
      'username': username,
      'original_post_id': originalPostId,
      'likes_count': likesCount,
      'dislikes_count': dislikesCount,
      'comments': comments.map((c) => {
        'id': c.id,
        'content': c.content,
        'user_id': c.userId,
        'post_id': c.postId,
        'username': c.username,
      }).toList(),
    };
  }

  // Add equality and hashCode for easy comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Post &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  Post copyWith({
    int? id,
    String? title,
    String? content,
    List<String>? mediaUrls,
    int? userId,
    String? username,
    int? originalPostId,
    int? likesCount,
    int? dislikesCount,
    List<Comment>? comments,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      originalPostId: originalPostId ?? this.originalPostId,
      likesCount: likesCount ?? this.likesCount,
      dislikesCount: dislikesCount ?? this.dislikesCount,
      comments: comments ?? this.comments,
    );
  }
}
