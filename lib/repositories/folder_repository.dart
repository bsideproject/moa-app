import 'package:dio/dio.dart';
import 'package:moa_app/models/folder_model.dart';
import 'package:moa_app/repositories/token_repository.dart';
import 'package:moa_app/utils/api.dart';

abstract class IFolderRepository {
  Future<List<FolderModel>> getFolderList();
  Future<void> addFolder({required String folderName});
  Future<void> editFolderName(
      {required String currentFolderName, required String editFolderName});
}

class FolderRepository implements IFolderRepository {
  const FolderRepository._();
  static FolderRepository instance = const FolderRepository._();

  @override
  Future<List<FolderModel>> getFolderList() async {
    var token = await TokenRepository.instance.getToken();
    var res = await dio.get(
      '/api/v1/folder/view',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return res.data['data']
        .map<FolderModel>((e) => FolderModel.fromJson(e))
        .toList();
  }

  @override
  Future<void> addFolder({required String folderName}) async {
    var token = await TokenRepository.instance.getToken();
    await dio.post(
      '/api/v1/folder/create',
      data: {
        'folderName': folderName,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  @override
  Future<void> editFolderName({
    required String currentFolderName,
    required String editFolderName,
  }) async {
    var token = await TokenRepository.instance.getToken();
    await dio.post(
      '/api/v1/folder/edit',
      data: {
        'currentFolderName': currentFolderName,
        'editFolderName': editFolderName,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
