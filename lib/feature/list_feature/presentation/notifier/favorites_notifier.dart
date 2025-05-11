import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/service/shared_pref_services.dart';

part 'favorites_notifier.g.dart';

@riverpod
class FavoritesNotifier extends _$FavoritesNotifier {
  static const _key = 'favorite_ids';

  @override
  FutureOr<Set<int>> build() async {
    final prefs = await SharedPreferencesService.getInstance();
    final stored = prefs.getString(_key);
    if (stored == null) return {};
    return stored.split(',').where((e) => e.isNotEmpty).map(int.parse).toSet();
  }

  Future<void> toggleFavorite(int postId) async {
    final prefs = await SharedPreferencesService.getInstance();
    final current = Set<int>.from(state.value ?? {});

    if (current.contains(postId)) {
      current.remove(postId);
    } else {
      current.add(postId);
    }

    await prefs.setString(_key, current.join(','));
    state = AsyncData(current);
  }

  bool isFavorite(int postId) {
    return state.value?.contains(postId) ?? false;
  }
}
