

import 'package:kushal_assignment/feature/list_feature/data/post_dto.dart';

import '../../../core/network/api_facade.dart';
import '../../../core/network/api_result.dart';

class PostDatasource {
  final ApiFacade apiFacade;

  const PostDatasource(this.apiFacade);

  Future<ApiResult<List<Post>>> getPosts({
    required int currentPage,
    required int perPage,
  }) async {
    final response = await apiFacade.get(
      'https://jsonplaceholder.typicode.com/posts',
      queryParams: {
        '_page': currentPage.toString(),
        '_limit': perPage.toString(),
      },
      needAccessToken: false,
    );

    return ApiResult.fromRawListResponse<Post>(response, Post.fromJson);
  }

  Future<ApiResult<Post>> getPostDetails({required int id}) async {
    final response = await apiFacade.get(
      'https://jsonplaceholder.typicode.com/posts/$id',
      needAccessToken: false,
    );

    return ApiResult.fromResponse<Post>(
      response,
          (json) => Post.fromJson(json),
    );
  }
}
