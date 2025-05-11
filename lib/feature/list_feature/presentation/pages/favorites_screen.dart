import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifier/favorites_notifier.dart';
import '../notifier/post_notifier.dart';
import '../../data/post_dto.dart';
import '../widgets/list_view_widget.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesNotifierProvider);
    final postsAsync = ref.watch(postNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (favoriteIds) {
          return postsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (posts) {
              final favoritePosts = posts
                  ?.where((post) => favoriteIds.contains(post.id))
                  .toList() ??
                  [];

              if (favoritePosts.isEmpty) {
                return const Center(child: Text('No favorites yet.'));
              }

              return ReusableListView<Post>(
                items: favoritePosts,
                itemBuilder: (context, post, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(post.title,style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),),
                      subtitle: Text(post.body),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
