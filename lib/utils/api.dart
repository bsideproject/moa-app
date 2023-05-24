import 'package:dio/dio.dart';
import 'package:moa_app/utils/config.dart';

Dio get dio {
  BaseOptions options = BaseOptions(
    baseUrl: Config().baseUrl,
    // connectTimeout: const Duration(seconds: 5),
    // receiveTimeout: const Duration(seconds: 3),
  );
  Dio dio = Dio(options);
  return dio;
}
