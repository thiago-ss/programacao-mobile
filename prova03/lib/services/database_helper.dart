import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/pet.dart';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  static bool _isWebPlatform = kIsWeb;

  static List<Pet> _webPets = [];
  static int _webPetId = 1;

  static List<User> _webUsers = [];
  static int _webUserId = 1;

  static User? _currentUser;
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_isWebPlatform) {
      throw UnsupportedError('SQLite não é suportado na web');
    }

    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  void clearCurrentUser() {
    _currentUser = null;
  }

  Future<int> deletePet(int id) async {
    if (_isWebPlatform) {
      final initialLength = _webPets.length;
      _webPets.removeWhere((pet) => pet.id == id);
      return initialLength - _webPets.length;
    } else {
      Database db = await database;
      return await db.delete(
        'pets',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  User? getCurrentUser() {
    return _currentUser;
  }

  Future<Pet?> getPet(int id) async {
    if (_isWebPlatform) {
      try {
        return _webPets.firstWhere((pet) => pet.id == id);
      } catch (e) {
        return null;
      }
    } else {
      Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'pets',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return Pet.fromMap(maps.first);
      }
      return null;
    }
  }

  Future<List<Pet>> getPets() async {
    if (_isWebPlatform) {
      return _webPets;
    } else {
      Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query('pets');
      return List.generate(maps.length, (i) {
        return Pet.fromMap(maps[i]);
      });
    }
  }

  Future<User?> getUser(int id) async {
    if (_isWebPlatform) {
      try {
        return _webUsers.firstWhere((user) => user.id == id);
      } catch (e) {
        return null;
      }
    } else {
      Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      }
      return null;
    }
  }

  Future<User?> getUserByEmail(String email, {String? password}) async {
    if (_isWebPlatform) {
      try {
        final user = _webUsers.firstWhere((user) => user.email == email);
        if (password != null && user.password != password) {
          return null;
        }
        return user;
      } catch (e) {
        return null;
      }
    } else {
      Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      if (maps.isNotEmpty) {
        final user = User.fromMap(maps.first);
        if (password != null && user.password != password) {
          return null;
        }
        return user;
      }
      return null;
    }
  }

  Future<int> insertPet(Pet pet) async {
    if (_isWebPlatform) {
      final newPet = Pet(
        id: _webPetId,
        name: pet.name,
        breed: pet.breed,
        age: pet.age,
        observations: pet.observations,
        genero: pet.genero,
        gostaCriancas: pet.gostaCriancas,
        conviveOutrosAnimais: pet.conviveOutrosAnimais,
        adaptaApartamentos: pet.adaptaApartamentos,
        gostaPasseios: pet.gostaPasseios,
        tranquiloVisitas: pet.tranquiloVisitas,
        latePouco: pet.latePouco,
        sociavelEstranhos: pet.sociavelEstranhos,
        compativelCriancasPequenas: pet.compativelCriancasPequenas,
        gostaCarrosViagens: pet.gostaCarrosViagens,
        disponivelParaAdocao: pet.disponivelParaAdocao,
        imageUrl: pet.imageUrl,
      );
      _webPets.add(newPet);
      _webPetId++;
      return newPet.id!;
    } else {
      Database db = await database;
      return await db.insert('pets', pet.toMap());
    }
  }

  Future<int> insertUser(User user) async {
    if (_isWebPlatform) {
      final existingUser =
          _webUsers.where((u) => u.email == user.email).toList();
      if (existingUser.isNotEmpty) {
        throw Exception('Email já cadastrado');
      }

      final newUser = User(
        id: _webUserId,
        name: user.name,
        email: user.email,
        imageUrl: user.imageUrl,
        bio: user.bio,
        phone: user.phone,
        address: user.address,
        isAdmin: user.isAdmin,
        createdAt: user.createdAt,
      );
      _webUsers.add(newUser);
      _webUserId++;
      return newUser.id!;
    } else {
      Database db = await database;
      try {
        return await db.insert('users', user.toMap());
      } catch (e) {
        if (e.toString().contains('UNIQUE constraint failed')) {
          throw Exception('Email já cadastrado');
        }
        rethrow;
      }
    }
  }

  Future<void> setCurrentUser(User user) async {
    _currentUser = user;
  }

  Future<int> updatePet(Pet pet) async {
    if (_isWebPlatform) {
      final index = _webPets.indexWhere((p) => p.id == pet.id);
      if (index != -1) {
        _webPets[index] = pet;
        return 1;
      }
      return 0;
    } else {
      Database db = await database;
      return await db.update(
        'pets',
        pet.toMap(),
        where: 'id = ?',
        whereArgs: [pet.id],
      );
    }
  }

  Future<int> updateUser(User user) async {
    if (_isWebPlatform) {
      final index = _webUsers.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _webUsers[index] = user;
        if (_currentUser?.id == user.id) {
          _currentUser = user;
        }
        return 1;
      }
      return 0;
    } else {
      Database db = await database;
      return await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    }
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        breed TEXT,
        age INTEGER,
        observations TEXT,
        genero TEXT,
        gostaCriancas INTEGER,
        conviveOutrosAnimais INTEGER,
        adaptaApartamentos INTEGER,
        gostaPasseios INTEGER,
        tranquiloVisitas INTEGER,
        latePouco INTEGER,
        sociavelEstranhos INTEGER,
        compativelCriancasPequenas INTEGER,
        gostaCarrosViagens INTEGER,
        disponivelParaAdocao INTEGER,
        imageUrl TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        imageUrl TEXT,
        bio TEXT,
        phone TEXT,
        address TEXT,
        isAdmin INTEGER,
        createdAt TEXT
      )
    ''');
  }

  Future<Database> _initDatabase() async {
    if (_isWebPlatform) {
      throw UnsupportedError('SQLite não é suportado na web');
    }

    String path = join(await getDatabasesPath(), 'pet_database.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDb,
      onUpgrade: _upgradeDb,
    );
  }

  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT UNIQUE,
          imageUrl TEXT,
          bio TEXT,
          phone TEXT,
          address TEXT,
          isAdmin INTEGER,
          createdAt TEXT
        )
      ''');
    }
  }
}
