import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/service_locator.dart';
import '../../../../core/network/api_result.dart';
import '../../data/post_dto.dart';
import '../../domain/post_listing_usecase.dart';

part 'post_notifier.g.dart';
final postSearchQueryProvider = StateProvider<String>((ref) => '');
@Riverpod(keepAlive: true)
class PostNotifier extends _$PostNotifier {
  late final PostUseCase usecase;

  @override
  FutureOr<List<Post>?> build() async {
    usecase = getIt<PostUseCase>();
    return getFirstPosts();
  }

  
  Future<List<Post>?> getFirstPosts() async {
    if (state.value == null || state.value!.isEmpty) {
      final result = await usecase.getPosts(currentPage: 1, perPage: 10);

      if (result is Success<List<Post>>) {
        state = AsyncValue.data(result.data);
      } else if (result is Failed<List<Post>>) {
        state = AsyncValue.error(result.errors.message ?? "Something went wrong", StackTrace.current);


      } else if (result is InternalError<List<Post>>) {
        state = AsyncValue.error("Internal error occurred", StackTrace.current);
      } else {
        state = const AsyncValue.error("Unknown error", StackTrace.empty);
      }
    } else {
      final sliced = state.value!
          .getRange(0, min(10, state.value!.length))
          .toList();
      state = AsyncValue.data(sliced);
    }

    return state.value;
  }

  Future<void> getMorePosts(int currentPage, int perPage) async {
    final result = await usecase.getPosts(currentPage: currentPage, perPage: perPage);

    if (result is Success<List<Post>>) {
      final existing = state.value ?? [];
      final combined = [...existing, ...result.data];
      state = AsyncValue.data(combined);
    } else if (result is Failed<List<Post>>) {
      state = AsyncValue.error(result.errors.message ?? "Something went wrong", StackTrace.current);
    } else if (result is InternalError<List<Post>>) {
      state = AsyncValue.error("Internal error occurred", StackTrace.current);
    }
  }
}
