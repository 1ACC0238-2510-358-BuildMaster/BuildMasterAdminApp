import 'package:flutter/material.dart';
import '../widgets/reported_post_card.dart';

class ModerationScreen extends StatelessWidget {
  const ModerationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reportedPosts = [
      {'user': 'Juan', 'reason': 'Lenguaje inapropiado', 'content': 'Este post es ofensivo'},
      {'user': 'Ana', 'reason': 'Spam', 'content': '¡Compra ahora!'},
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reportedPosts.length,
      itemBuilder: (context, i) {
        final post = reportedPosts[i];
        return ReportedPostCard(
          user: post['user']!,
          reason: post['reason']!,
          content: post['content']!,
          onApprove: () {},
          onRemove: () {},
        );
      },
    );
  }
}
