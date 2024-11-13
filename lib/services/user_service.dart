// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'hive_service.dart';

class UserService {
  static final UserService _instance = UserService._internal(); // Singleton
  final HiveService _hiveService = HiveService();
  
  ValueNotifier<String> usernameNotifier = ValueNotifier<String>('');

  factory UserService() {
    return _instance;
  }

  UserService._internal() {
    initializeUsername();  
  }

  Future<void> initializeUsername() async {
    final user = getUser();
    usernameNotifier.value = user?.username ?? '';  
  }

  Future<void> addUser(User user) async {
    final userBox = _hiveService.getUserBox();
    await userBox.clear();
    await userBox.put(user.username, user);

    usernameNotifier.value = user.username;  
  }

  User? getUser() {
    final userBox = _hiveService.getUserBox();
    return userBox.isNotEmpty ? userBox.getAt(0) : null;
  }

Future<void> updateUser(String newUsername) async {
  final userBox = _hiveService.getUserBox();
  final currentUser = getUser();

  if (currentUser != null) {
    print('Updating username to: $newUsername');

    final updatedUser = User(username: newUsername);

    await userBox.clear();
    await userBox.put(newUsername, updatedUser);

    usernameNotifier.value = newUsername;
    print('usernameNotifier updated: ${usernameNotifier.value}');

    usernameNotifier.notifyListeners();
  }
}

  Future<void> deleteUser() async {
    // Clear the user box
    await _hiveService.getUserBox().clear();

    await _hiveService.getMoviesBox().clear();

    await _hiveService.getShowsBox().clear();

    await _hiveService.getWatchlistBox().clear();
  }

  bool isUserExists() {
    final userBox = _hiveService.getUserBox();
    return userBox.isNotEmpty;
  }
}
