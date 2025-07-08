import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/community_provider.dart';
import 'pages/moderation_screen.dart';
import 'pages/post_management_screen.dart';
import 'pages/settings_screen.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CommunityProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Comunidad'),
          backgroundColor: Colors.green,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(icon: Icon(Icons.report), text: 'Moderación'),
              Tab(icon: Icon(Icons.forum), text: 'Posts'),
              Tab(icon: Icon(Icons.settings), text: 'Ajustes'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ModerationScreen(),
            // Remove 'const' to allow rebuild after post creation
            PostManagementScreen(key: UniqueKey()),
            SettingsScreen(),
          ],
        ),
        floatingActionButton: AnimatedBuilder(
          animation: _tabController,
          builder: (context, child) {
            if (_tabController.index == 1) {
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
                      // Refetch posts to update the list after creation
                      await Provider.of<CommunityProvider>(context, listen: false).fetchPosts();
                    }
                  },
                  child: const Icon(Icons.add),
                  tooltip: 'Crear publicación',
                ),
              );
            }
            return const SizedBox.shrink();
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
