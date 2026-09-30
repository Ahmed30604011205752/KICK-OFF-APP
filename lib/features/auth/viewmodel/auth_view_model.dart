import 'package:flutter/foundation.dart';

import '../model/user_account.dart';

class AuthViewModel extends ChangeNotifier {
  bool isCreatingAccount = false;
  AccountRole selectedRole = AccountRole.player;
  String? errorMessage;

  void toggleMode() {
    isCreatingAccount = !isCreatingAccount;
    selectedRole = AccountRole.player;
    errorMessage = null;
    notifyListeners();
  }

  void selectRole(AccountRole role) {
    selectedRole = role;
    notifyListeners();
  }

  UserAccount? submit({
    required String name,
    required String email,
    required String password,
  }) {
    final normalizedEmail = email.trim();
    if (isCreatingAccount && name.trim().isEmpty) {
      errorMessage = 'Enter your full name to continue.';
    } else if (!normalizedEmail.contains('@') ||
        !normalizedEmail.contains('.')) {
      errorMessage = 'Enter a valid email address.';
    } else if (password.length < 6) {
      errorMessage = 'Password must be at least 6 characters.';
    } else {
      errorMessage = null;
      notifyListeners();
      return UserAccount(
        name: isCreatingAccount ? name.trim() : _nameFromEmail(normalizedEmail),
        email: normalizedEmail,
        role: selectedRole,
      );
    }
    notifyListeners();
    return null;
  }

  String _nameFromEmail(String email) {
    final name = email.split('@').first.replaceAll(RegExp(r'[._-]'), ' ');
    return name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}
