import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:floor/floor.dart';
import 'package:tareas/database/user_dao.dart';
import 'package:tareas/models/user.dart';

part 'database_helper.g.dart';

@Database(version: 1, entities: [User])
abstract class DatabaseHelper extends FloorDatabase {
  UserDao get userDao;
}
