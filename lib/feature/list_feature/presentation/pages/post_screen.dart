import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kushal_assignment/feature/list_feature/presentation/pages/post_details_screen.dart';
import '../notifier/favorites_notifier.dart';
import '../notifier/post_notifier.dart';
import '../../data/post_dto.dart';
import '../widgets/list_view_widget.dart';
import 'favorites_screen.dart';

class PostListScreen extends ConsumerWidget {
  const PostListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postNotifierProvider);
    final query = ref.watch(postSearchQueryProvider);
    final favorites = ref.watch(favoritesNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: postsAsync.when(
        data: (posts) {
          if (posts == null || posts.isEmpty) {
            return const Center(child: Text("No posts found"));
          }

          final filteredPosts = posts.where((post) {
            final q = query.toLowerCase();
            return (post.title ?? '').toLowerCase().contains(q) ||
                (post.body ?? '').toLowerCase().contains(q);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  onTapOutside: (val) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (val) =>
                      ref.read(postSearchQueryProvider.notifier).state = val,
                ),
              ),
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () async {
                  await ref.read(postNotifierProvider.notifier).getFirstPosts();
                },
                child: ReusableListView<Post>(
                  items: filteredPosts,
                  itemBuilder: (context, post, index) {
                    return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PostDetailScreen(post: post),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              post.title ?? 'No Title',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              post.body ?? 'No Body',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                favorites.valueOrNull?.contains(post.id) ??
                                        false
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              onPressed: () => ref
                                  .read(favoritesNotifierProvider.notifier)
                                  .toggleFavorite(post.id),
                            ),
                          ),
                        ));
                  },
                ),
              )),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FavoritesScreen()),
          );
        },
        child:  Icon(Icons.favorite),
        tooltip: 'View Favorites',
      ),

    );
  }
}
