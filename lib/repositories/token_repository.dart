import 'package:moa_app/utils/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class ITokenRepository {
  Future<Database> initDB();
  Future<void> setToken({required String token});
  Future<void> removeToken();
  Future<Object?> getToken();
}

class TokenRepository implements ITokenRepository {
  const TokenRepository._();
  static TokenRepository instance = const TokenRepository._();

  @override
  Future<Database> initDB() async {
    var database = openDatabase(
      // 데이터베이스 경로를 지정합니다. 참고: `path` 패키지의 `join` 함수를 사용하는 것이
      // 각 플랫폼 별로 경로가 제대로 생성됐는지 보장할 수 있는 가장 좋은 방법입니다.
      join(await getDatabasesPath(), 'token_database.db'),

      onCreate: (db, version) {
        // 데이터베이스에 CREATE TABLE 수행
        return db.execute(
          'CREATE TABLE token(token TEXT)',
        );
      },
      version: 1,
    );

    var db = await database;
    return db;
  }

  @override
  Future<void> setToken({required String token}) async {
    var db = await initDB();
    try {
      await db.insert('token', {'token': token},
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      logger.d(e);
    }
  }

  @override
  Future<void> removeToken() async {
    var db = await initDB();
    try {
      await db.delete('token');
    } catch (e) {
      logger.d(e);
    }
  }

  @override
  Future<Object?> getToken() async {
    var db = await initDB();
    var res = await db.query('token');
    if (res.isNotEmpty) {
      return res.first['token'];
    }
    return null;
  }
}
