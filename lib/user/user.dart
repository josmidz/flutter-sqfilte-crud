import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class User {
  final photo, id, nom, description, favorite;

  User({this.id, this.photo, this.nom, this.description, this.favorite});

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'description': description,
      'photo': photo,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    Map<String, dynamic> map = {};
    if (nom != null) map[nomField] = nom;
    if (favorite != null) map[favoriteField] = favorite;
    if (description != null) map[descriptionField] = description;
    if (photo != null) map[photoField] = photo;
    return map;
  }

  @override
  String toString() {
    return "User(nom: $nom, description: $description, id: $id, isfavorite: $favorite)";
  }
}

final userTable = 'usertable',
    useridField = '_iduser',
    nomField = 'nom',
    favoriteField = 'isfavorite',
    descriptionField = 'description',
    photoField = 'photo';

class UserDbHelper {
  Future<bool> saveImageFileLocally({Uint8List bytes, String filename}) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      File file = new File(join(directory.path, filename));
      await file.writeAsBytes(bytes);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Uint8List> readImageFileLocally({String filename}) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      File filePath = new File(join(directory.path, filename));
      final file = await filePath.readAsBytes();
      return file;
    } catch (e) {
      return null;
    }
  }

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await open();
    return _database;
  }

  Future open() async {
    final dbPath = await getDatabasesPath();
    String _path = join(dbPath, 'user.db');
    Database _opened = await openDatabase(_path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE $userTable(
          $useridField integer primary key autoincrement,
          $nomField text not null,
          $descriptionField text,
          $favoriteField integer,
          $photoField text
        )
      ''');
    });
    return _opened;
  }

  //INSERT USER
  Future<int> insertUser({User user}) async {
    final _dbClient = await database;
    final _saved = await _dbClient.insert(userTable, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return _saved;
  }

  Future<List<User>> getUsers() async {
    final _dbClient = await database;
    List<Map> maps = await _dbClient.query(userTable);
    if (maps.length > 0) {
      List<User> _users = [];
      for (var item in maps) {
        print(item);
        //chargement de la photo
        var _photo = await readImageFileLocally(filename: item[photoField]);
        _users.add(User(
            photo: _photo,
            nom: item[nomField],
            description: item[descriptionField],
            id: item[useridField],
            favorite: item[favoriteField]));
      }
      return _users;
    }
    return <User>[];
  }

  Future<int> updateUser({User user, dynamic id}) async {
    final _dbClient = await database;
    final _saved = await _dbClient.update(userTable, user.toMapUpdate(),
        where: "$useridField = ?", whereArgs: [id]);
    return _saved;
  }

  Future<List<User>> getFavoriteUsers() async {
    final _dbClient = await database;
    List<Map> maps =
        await _dbClient.query(userTable, where: favoriteField, whereArgs: [1]);
    if (maps.length > 0) {
      List<User> _users = [];
      for (var item in maps) {
        //chargement de la photo
        var _photo = await readImageFileLocally(filename: item[photoField]);
        _users.add(User(
            photo: _photo,
            nom: item[nomField],
            id: item[useridField],
            description: item[descriptionField],
            favorite: item[favoriteField]));
      }
      return _users;
    }
    return <User>[];
  }

  //delete user
  Future<int> deleteUser(dynamic id) async {
    final _dbClient = await database;
    int _deletion = await _dbClient
        .delete(userTable, where: "$useridField = ?", whereArgs: [id]);
    return _deletion;
  }
}
