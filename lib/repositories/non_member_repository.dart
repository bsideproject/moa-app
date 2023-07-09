import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

// todo : 비회원의 취향 아이템들을 저장하는 레포지토리로 쓸 예정

class NonUserModel {
  NonUserModel({
    required this.id,
    this.nickname,
  });
  String id;
  String? nickname;
}

abstract class INonMemberRepository {
  Future<void> removeUser();
  Future<Database> initDB();
  Future<NonUserModel>? getNickname();
  Future<void> setUserNickname({required String nickname});
}

class NonMemberRepository implements INonMemberRepository {
  const NonMemberRepository._();
  static NonMemberRepository instance = const NonMemberRepository._();

  @override
  Future<Database> initDB() async {
    if (kIsWeb) {
      // Use the ffi web factory in web apps (flutter or dart)
      databaseFactory = databaseFactoryFfiWeb;
      var db = await openDatabase('non_member_database.db');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS user(id TEXT PRIMARY KEY, nickname TEXT)');
      return db;
    }

    var database = openDatabase(
      // 데이터베이스 경로를 지정합니다. 참고: `path` 패키지의 `join` 함수를 사용하는 것이
      // 각 플랫폼 별로 경로가 제대로 생성됐는지 보장할 수 있는 가장 좋은 방법입니다.
      join(await getDatabasesPath(), 'non_member_database.db'),

      onCreate: (db, version) {
        // 데이터베이스에 CREATE TABLE 수행
        return db.execute(
          'CREATE TABLE user(id TEXT PRIMARY KEY, nickname TEXT)',
        );
      },
      version: 1,
    );

    var db = await database;
    return db;
  }

  @override
  Future<void> removeUser() async {
    var db = await initDB();
    await db.delete('user');
  }

  @override
  Future<NonUserModel>? getNickname() async {
    var db = await initDB();
    List<Map<String, dynamic>> maps = await db.query('user');
    if (maps.isEmpty) {
      await NonMemberRepository.instance.setUserNickname(nickname: '');
      return NonUserModel(id: '0', nickname: '');
    }

    return maps
        .map((e) => NonUserModel(id: e['id'], nickname: e['nickname']))
        .toList()
        .first;
  }

  @override
  Future<void> setUserNickname({required String nickname}) async {
    var db = await initDB();
    Map<String, dynamic> user = {
      'id': '0',
      'nickname': nickname,
    };

    await db.insert('user', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
