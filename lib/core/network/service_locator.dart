import 'package:get_it/get_it.dart';

import '../../feature/list_feature/data/data_source.dart';
import '../../feature/list_feature/domain/post_listing_usecase.dart';
import 'api_config.dart';
import 'api_facade.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<ApiConfig>(DefaultApiConfig());
  getIt.registerSingleton<ApiFacade>(ApiFacade());
  getIt.registerSingleton<PostDatasource>(
    PostDatasource(getIt<ApiFacade>()),
  );

  // Register PostUseCaseImpl with PostDatasource dependency
  getIt.registerSingleton<PostUseCase>(
    PostUseCaseImpl(getIt<PostDatasource>()),
  );
}