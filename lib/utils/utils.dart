import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

Future<String> deleteDbCreateDbDirectory() async {
  final databasePath = await getDatabasesPath();
  final paths = path.join(databasePath, "you_db_name");

  // make sure the folder exists
  // ignore: avoid_slow_async_io
  if (await Directory(path.dirname(paths)).exists()) {
    await deleteDatabase(paths);
    await File(paths).delete();
  } else {
    try {
      await Directory(path.dirname(paths)).create(recursive: true);
    } catch (e) {
      // ignore: avoid_print
      //print(e);
    }
  }
  ////print("path: $path");
  return paths;
}