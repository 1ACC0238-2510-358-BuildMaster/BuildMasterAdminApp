import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../providers/community_provider.dart';
import '../widgets/post_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritePosts = context.watch<CommunityProvider>().favoritePosts;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: Colors.green,
      ),
      body: favoritePosts.isEmpty
          ? const Center(child: Text('No tienes posts favoritos.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoritePosts.length,
              itemBuilder: (context, index) {
                final post = favoritePosts[index];
                return PostCard(
                  post: post,
                  onEdit: () {}, // Implement edit if needed
                  onDelete: () {}, // Implement delete if needed
                );
              },
            ),
    );
  }
}

