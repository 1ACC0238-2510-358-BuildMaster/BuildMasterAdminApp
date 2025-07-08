import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../providers/community_provider.dart';
import '../widgets/post_card.dart';

class PostManagementScreen extends StatefulWidget {
  final VoidCallback? onCreatePost;
  const PostManagementScreen({super.key, this.onCreatePost});

  @override
  State<PostManagementScreen> createState() => _PostManagementScreenState();
}

class _PostManagementScreenState extends State<PostManagementScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CommunityProvider>().fetchPosts());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommunityProvider>();
    return Builder(
      builder: (context) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error != null) {
          return Center(child: Text('Error: \\${provider.error}'));
        }
        final posts = provider.posts;
        if (posts.isEmpty) {
          return const Center(child: Text('No hay publicaciones.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          itemBuilder: (context, i) {
            final post = posts[i];
            return PostCard(
              post: post,
              onEdit: () {
                // TODO: Implement edit functionality
              },
              onDelete: () async {
                await provider.deletePost(post.id);
              },
            );
          },
        );
      },
    );
  }
}

class _PostDialogResult {
  final String title;
  final String content;
  _PostDialogResult(this.title, this.content);
}

class _CreatePostDialog extends StatefulWidget {
  @override
  State<_CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<_CreatePostDialog> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Crear publicación'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (value) => value == null || value.isEmpty ? 'Ingrese un título' : null,
              onSaved: (value) => _title = value ?? '',
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Contenido'),
              validator: (value) => value == null || value.isEmpty ? 'Ingrese contenido' : null,
              onSaved: (value) => _content = value ?? '',
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              Navigator.of(context).pop(_PostDialogResult(_title, _content));
            }
          },
          child: const Text('Crear'),
        ),
      ],
    );
  }
}
