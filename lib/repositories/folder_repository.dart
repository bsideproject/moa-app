import 'package:dio/dio.dart';
import 'package:moa_app/repositories/token_repository.dart';
import 'package:moa_app/utils/api.dart';

abstract class IFolderRepository {
  Future<String?> getFolderList();
}

class FolderRepository implements IFolderRepository {
  const FolderRepository._();
  static FolderRepository instance = const FolderRepository._();

  @override
  Future<String?> getFolderList() async {
    var token = await TokenRepository.instance.getToken();

    var res = await dio.get(
      '/api/v1/folder/view/',
      options: Options(
        headers: {'oauth-token': token},
      ),
    );

    print('res:$res');
    return 'string';
  }
}
