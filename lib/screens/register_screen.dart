import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../services/database_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  final _db = DatabaseService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Semua field wajib diisi');
      return;
    }

    if (password != confirm) {
      setState(() => _errorMessage = 'Password tidak cocok');
      return;
    }

    if (password.length < 6) {
      setState(() => _errorMessage = 'Password minimal 6 karakter');
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      final success = await _db.registerUser(email, password, name);
      if (success) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        setState(() { _errorMessage = 'Email sudah terdaftar'; _isLoading = false; });
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
              const SizedBox(height: 40),
              Text('Daftar Akun', style: AppTextStyles.heading),
              const SizedBox(height: 8),
              Text('Bergabung dan jelajahi wisata Tegal', style: AppTextStyles.body),
              const SizedBox(height: 40),
              AppTextField(hint: 'Nama Lengkap', controller: _nameController),
              const SizedBox(height: 14),
              AppTextField(hint: 'Email', controller: _emailController, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 14),
              AppTextField(hint: 'Password', controller: _passwordController, obscureText: true),
              const SizedBox(height: 14),
              AppTextField(hint: 'Konfirmasi Password', controller: _confirmController, obscureText: true),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 13), textAlign: TextAlign.center),
              ],
              const SizedBox(height: 32),
              _isLoading ? const CircularProgressIndicator() : PrimaryButton(label: 'Daftar', onTap: _register),
              const SizedBox(height: 14),
              OutlineButton(label: 'Sudah punya akun? Masuk', onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}
