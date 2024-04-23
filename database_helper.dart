import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'user.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user (
            id INTEGER PRIMARY KEY,
            username TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            email TEXT NOT NULL,
            age INTEGER NOT NULL,
            sex TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> registerUser(Map<String, dynamic> user) async {
    try {
      final db = await database;
      await db.insert('user', user);
    } catch (e) {
      if (kDebugMode) {
        print('Error registering user: $e');
      }
      rethrow; // Rethrow the error to handle it in UI layer if needed
    }
  }

  Future<Map<String, dynamic>?> authenticateUser(String email, String password) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query(
        'user',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      if (kDebugMode) {
        print('Error authenticating user: $e');
      }
      rethrow; // Rethrow the error to handle it in UI layer if needed
    }
  }

  // Add context parameter or handle snackbar presentation in UI layer
  Future<void> deleteUser(BuildContext context, String username, String password) async {
    final db = await database;
    await db.transaction((txn) async {
      final List<Map<String, dynamic>> result = await txn.query(
        'user',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );
      if (result.isNotEmpty) {
        await txn.delete(
          'user',
          where: 'username = ?',
          whereArgs: [username],
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User $username deleted'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User $username not found or password incorrect.'),
          ),
        );
      }
    });
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query('user', where: 'id = ?', whereArgs: [id]);
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user by ID: $e');
      }
      rethrow; // Rethrow the error to handle it in UI layer if needed
    }
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    try {
      final db = await database;
      await db.update('user', user, where: 'id = ?', whereArgs: [user['id']]);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user: $e');
      }
      rethrow; // Rethrow the error to handle it in UI layer if needed
    }
  }
}
