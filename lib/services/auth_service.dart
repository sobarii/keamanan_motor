class AuthService {
  // akun single user
  static const String _email = 'user';
  static const String _password = '1234';

  static Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulasi loading
    return email == _email && password == _password;
  }
}
