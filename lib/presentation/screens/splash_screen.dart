import 'package:flutter/material.dart';
import '../../core/storage/token_storage.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth/login_screen.dart';
import 'product/product_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    try {
      final token = await TokenStorage.getToken();

      if (token == null || token.isEmpty) {
        _navigateToLogin();
        return;
      }

      await _authRepository.getMe();

      if (!mounted) return;
      _navigateToProductList();
    } catch (e) {
      await TokenStorage.clearToken();
      if (!mounted) return;
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _navigateToProductList() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ProductListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Image.asset(
          'assets/logo_phone.png',
          width: 300,
          height: 300,
          fit: BoxFit.contain,
        ),
            const SizedBox(height: 24),
            const SizedBox(height: 32),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ],
        ),
      ),
    );
  }
}