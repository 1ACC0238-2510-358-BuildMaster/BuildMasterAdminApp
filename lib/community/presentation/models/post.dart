class Post {
  final int id;
  final String title;
  final String content;
  final List<String> mediaUrls;
  final int userId;
  final String username;
  final int originalPostId;
  final int likesCount;
  final int dislikesCount;
  final List<dynamic> comments;

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
      originalPostId: json['original_post_id'] ?? 0,
      likesCount: json['likes_count'] ?? 0,
      dislikesCount: json['dislikes_count'] ?? 0,
      comments: json['comments'] ?? [],
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
      'comments': comments,
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
}
