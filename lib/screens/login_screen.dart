import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../services/database_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  final _db = DatabaseService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Email dan password wajib diisi');
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      final user = await _db.loginUser(email, password);
      if (user != null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home', arguments: user.id);
        }
      } else {
        setState(() { _errorMessage = 'Email atau password salah'; _isLoading = false; });
      }
    } catch (e) {
      setState(() { _errorMessage = 'Error: $e'; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Text('Menegal', style: AppTextStyles.heading.copyWith(fontSize: 32)),
              const SizedBox(height: 4),
              const Text('Jelajah Wisata Tegal', style: AppTextStyles.body),
              const SizedBox(height: 40),
              const Text('Masuk ke akun', style: AppTextStyles.subheading),
              const SizedBox(height: 24),
              AppTextField(hint: 'Email', controller: _emailController, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 14),
              AppTextField(hint: 'Password', controller: _passwordController, obscureText: true),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13), textAlign: TextAlign.center),
              ],
              const SizedBox(height: 32),
              _isLoading ? const CircularProgressIndicator() : PrimaryButton(label: 'Masuk', onTap: _signIn),
              const SizedBox(height: 14),
              OutlineButton(label: 'Buat Akun', onTap: () => Navigator.pushNamed(context, '/register')),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Akun Demo:', style: AppTextStyles.label.copyWith(color: AppColors.primary)),
                    const SizedBox(height: 6),
                    Text('demo@menegal.id / demo1234', style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
