import 'package:moa_app/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// todo : 비회원의 취향 아이템들을 저장하는 레포지토리로 쓸 예정

abstract class INonMemberRepository {
  Future<void> login(UserModel user);
  Future<void> logout();
  Future<Database> initDB();
  Future<List<UserModel>>? getMe();
}

class NonMemberRepository implements INonMemberRepository {
  const NonMemberRepository._();
  static NonMemberRepository instance = const NonMemberRepository._();

  @override
  Future<Database> initDB() async {
    var database = openDatabase(
      // 데이터베이스 경로를 지정합니다. 참고: `path` 패키지의 `join` 함수를 사용하는 것이
      // 각 플랫폼 별로 경로가 제대로 생성됐는지 보장할 수 있는 가장 좋은 방법입니다.
      join(await getDatabasesPath(), 'non_member_database.db'),

      onCreate: (db, version) {
        // 데이터베이스에 CREATE TABLE 수행
        return db.execute(
          'CREATE TABLE user(id TEXT PRIMARY KEY ,email TEXT, password TEXT)',
        );
      },
      version: 1,
    );

    var db = await database;
    return db;
  }

  @override
  Future<void> login(UserModel user) async {
    var db = await initDB();

    await db.insert('user', user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> logout() async {
    var db = await initDB();
    await db.delete('user');
  }

  @override
  Future<List<UserModel>>? getMe() async {
    var db = await initDB();
    List<Map<String, dynamic>> maps = await db.query('user');

    return List.generate(maps.length, (i) {
      return UserModel(
        id: maps[i]['id'],
        email: maps[i]['email'],
        password: maps[i]['password'],
      );
    });
  }
}