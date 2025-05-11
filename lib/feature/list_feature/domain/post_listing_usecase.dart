import 'package:kushal_assignment/feature/list_feature/data/post_dto.dart';
import '../../../core/network/api_result.dart';
import '../data/data_source.dart';
abstract class PostUseCase {
  Future<ApiResult<List<Post>>> getPosts({required int currentPage, required int perPage});
  Future<ApiResult<Post>> getPostDetails({required int id});
}
class PostUseCaseImpl implements PostUseCase  {
  final PostDatasource _postDatasource;

  PostUseCaseImpl(this._postDatasource);

  Future<ApiResult<List<Post>>> getPosts({
    required int currentPage,
    required int perPage,
  }) {
    return _postDatasource.getPosts(
      currentPage: currentPage,
      perPage: perPage,
    );
  }

  Future<ApiResult<Post>> getPostDetails({required int id}) {
    return _postDatasource.getPostDetails(id: id);
  }
}
