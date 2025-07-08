import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../providers/community_provider.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PostCard({
    super.key,
    required this.post,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.watch<CommunityProvider>().isFavorite(post);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.forum, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(post.content, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            if (post.mediaUrls.isNotEmpty)
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: post.mediaUrls.length,
                  itemBuilder: (context, index) {
                    final url = post.mediaUrls[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.network(
                        url,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 8),
            Text('Por: ${post.username}'),
            Text('ID: ${post.id} | User ID: ${post.userId}'),
            if (post.originalPostId != null)
              Text('Repost de: ${post.originalPostId}'),
            Row(
              children: [
                const Icon(Icons.thumb_up, size: 18, color: Colors.blue),
                const SizedBox(width: 2),
                Text(post.likesCount.toString()),
                const SizedBox(width: 12),
                const Icon(Icons.thumb_down, size: 18, color: Colors.red),
                const SizedBox(width: 2),
                Text(post.dislikesCount.toString()),
              ],
            ),
            const SizedBox(height: 8),
            if (post.comments.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Comentarios:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...post.comments.map((c) => Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: Text('- ${c.content} (por ${c.username})')),
                          Tooltip(
                            message: 'Editar comentario',
                            child: IconButton(
                              icon: const Icon(Icons.edit_note, color: Colors.orange),
                              onPressed: () async {
                                final controller = TextEditingController(text: c.content);
                                final newContent = await showDialog<String>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Editar comentario'),
                                    content: TextField(controller: controller),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                                      TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Guardar')),
                                    ],
                                  ),
                                );
                                if (newContent != null && newContent.trim().isNotEmpty && newContent != c.content) {
                                  await Provider.of<CommunityProvider>(context, listen: false).updateComment(post.id, c.id, newContent, context);
                                }
                              },
                            ),
                          ),
                          Tooltip(
                            message: 'Eliminar comentario',
                            child: IconButton(
                              icon: const Icon(Icons.delete_forever, color: Colors.red),
                              onPressed: () async {
                                await Provider.of<CommunityProvider>(context, listen: false).deleteComment(post.id, c.id, context);
                              },
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  tooltip: 'Favorito',
                  onPressed: () => context.read<CommunityProvider>().toggleFavorite(post),
                ),
                Tooltip(
                  message: 'Editar publicación',
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: onEdit,
                  ),
                ),
                Tooltip(
                  message: 'Eliminar publicación',
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
