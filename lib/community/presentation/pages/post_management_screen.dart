import 'package:flutter/material.dart';
import '../widgets/post_card.dart';

class PostManagementScreen extends StatelessWidget {
  const PostManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      {'title': 'Bienvenidos', 'author': 'Admin'},
      {'title': 'Reglas del foro', 'author': 'Moderador'},
      {'title': '¡Comparte tu proyecto!', 'author': 'Juan'},
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, i) {
        final post = posts[i];
        return PostCard(
          title: post['title']!,
          author: post['author']!,
          onEdit: () {},
          onDelete: () {},
        );
      },
    );
  }
}
