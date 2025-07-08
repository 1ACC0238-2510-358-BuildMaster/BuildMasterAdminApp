import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/community_provider.dart';
import 'pages/post_management_screen.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CommunityProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Posts'),
          backgroundColor: Colors.green,
        ),
        body: PostManagementScreen(key: UniqueKey()),
        floatingActionButton: Builder(
          builder: (context) {
            return Container(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsets.only(bottom: 80, right: 16),
              child: FloatingActionButton(
                onPressed: () async {
                  final titleController = TextEditingController();
                  final contentController = TextEditingController();
                  final result = await showDialog<_PostDialogResult>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Crear nueva publicación'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: titleController,
                            decoration: const InputDecoration(labelText: 'Título'),
                          ),
                          TextField(
                            controller: contentController,
                            decoration: const InputDecoration(labelText: 'Contenido'),
                            maxLines: 3,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final title = titleController.text.trim();
                            final content = contentController.text.trim();
                            if (title.isNotEmpty && content.isNotEmpty) {
                              Navigator.of(context).pop(_PostDialogResult(title, content));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Título y contenido no pueden estar vacíos')),
                              );
                            }
                          },
                          child: const Text('Publicar'),
                        ),
                      ],
                    ),
                  );
                  if (result != null) {
                    await Provider.of<CommunityProvider>(context, listen: false)
                        .createPost(result.title, result.content, []);
                    await Provider.of<CommunityProvider>(context, listen: false).fetchPosts();
                  }
                },
                child: const Icon(Icons.add),
                tooltip: 'Crear publicación',
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PostDialogResult {
  final String title;
  final String content;

  _PostDialogResult(this.title, this.content);
}
