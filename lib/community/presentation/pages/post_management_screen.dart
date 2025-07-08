import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../providers/community_provider.dart';
import '../widgets/post_card.dart';

class PostManagementScreen extends StatelessWidget {
  const PostManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      Post(id: '1', title: 'Bienvenidos', author: 'Admin'),
      Post(id: '2', title: 'Reglas del foro', author: 'Moderador'),
      Post(id: '3', title: '¡Comparte tu proyecto!', author: 'Juan'),
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, i) {
        final post = posts[i];
        return PostCard(
          post: post,
          onEdit: () {},
          onDelete: () {},
        );
      },
    );
  }
}
