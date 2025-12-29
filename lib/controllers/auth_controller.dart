import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  // CONTROLLERS 
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();


  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var currentUserEmail = ''.obs;


  static const String usersKey = 'users';
  static const String loginKey = 'isLoggedIn';
  static const String currentUserKey = 'currentUserEmail';


  @override
  void onInit() {
    super.onInit();
    restoreLogin();
  }

  
  Future<void> restoreLogin() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool(loginKey) ?? false;
    currentUserEmail.value = prefs.getString(currentUserKey) ?? '';

    if (isLoggedIn.value && currentUserEmail.isNotEmpty) {
      Get.offAllNamed('/companies');
    }
  }


  Future<void> signUp() async {
    if (nameCtrl.text.trim().isEmpty ||
        emailCtrl.text.trim().isEmpty ||
        passwordCtrl.text.isEmpty) {
      showError("All fields are required");
      return;
    }

    if (!GetUtils.isEmail(emailCtrl.text.trim())) {
      showError("Enter a valid email");
      return;
    }

    if (!GetUtils.isLengthGreaterThan(passwordCtrl.text, 5)) {
      showError("Password must be at least 6 characters");
      return;
    }

    isLoading(true);

    final prefs = await SharedPreferences.getInstance();
    List users = jsonDecode(prefs.getString(usersKey) ?? '[]');

    if (users.any((u) => u['email'] == emailCtrl.text.trim())) {
      showError("Email already exists");
      isLoading(false);
      return;
    }

    users.add({
      'name': nameCtrl.text.trim(),
      'email': emailCtrl.text.trim(),
      'password': passwordCtrl.text,
      'favorites': [],
      'feedbacks': [],
    });

    await prefs.setString(usersKey, jsonEncode(users));
    isLoading(false);

    Get.snackbar(
      "Success",
      "Account created successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    clearFields();
    Get.offAllNamed('/login');
  }

 
  Future<void> login() async {
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text;

    if (!GetUtils.isEmail(email)) {
      showError("Enter a valid email");
      return;
    }

    if (!GetUtils.isLengthGreaterThan(password, 5)) {
      showError("Password must be at least 6 characters");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    List users = jsonDecode(prefs.getString(usersKey) ?? '[]');

    final user = users.firstWhere(
          (u) => u['email'] == email && u['password'] == password,
      orElse: () => null,
    );

    if (user != null) {
      isLoggedIn.value = true;
      currentUserEmail.value = email;

      await prefs.setBool(loginKey, true);
      await prefs.setString(currentUserKey, email);

      clearFields();
      Get.offAllNamed('/companies');
    } else {
      showError("Invalid email or password");
    }
  }

 
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(loginKey, false);
    await prefs.remove(currentUserKey);

    isLoggedIn.value = false;
    currentUserEmail.value = '';

    Get.offAllNamed('/login');
  }

  
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final prefs = await SharedPreferences.getInstance();
    List users = jsonDecode(prefs.getString(usersKey) ?? '[]');

    return users.firstWhere(
          (u) => u['email'] == currentUserEmail.value,
      orElse: () => null,
    );
  }


  Future<void> updateCurrentUser(Map<String, dynamic> updatedUser) async {
    final prefs = await SharedPreferences.getInstance();
    List users = jsonDecode(prefs.getString(usersKey) ?? '[]');

    final index =
    users.indexWhere((u) => u['email'] == currentUserEmail.value);

    if (index != -1) {
      users[index] = updatedUser;
      await prefs.setString(usersKey, jsonEncode(users));
    }
  }

 
  void clearFields() {
    nameCtrl.clear();
    emailCtrl.clear();
    passwordCtrl.clear();
  }

  void showError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }
}
