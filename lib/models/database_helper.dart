import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recipe_book.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final fullPath = path.join(dbPath, filePath);

    return await openDatabase(fullPath, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recipe_book (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        ingredients TEXT NOT NULL,
        description TEXT NOT NULL,
        steps TEXT NOT NULL
      )
    ''');
  }

  Future<List<Recipe>> getRecipes() async {
    final db = await instance.database;
    final result = await db.query('recipe_book');
    return result.map((json) => Recipe(
      id: json['id'] as int,
      title: json['title'] as String,
      ingredients: json['ingredients'] as String,
      description: json['description'] as String,
      steps: json['steps'] as String,
    )).toList();
  }

  Future<int> addRecipe(Recipe recipe) async {
    final db = await instance.database;
    return await db.insert('recipe_book', recipe.toMap());
  }

  Future<int> updateRecipe(Recipe recipe) async {
    final db = await instance.database;
    return await db.update(
      'recipe_book',
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<int> deleteRecipe(int id) async {
    final db = await instance.database;
    return await db.delete(
      'recipe_book',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}