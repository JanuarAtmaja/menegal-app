import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../services/database_service.dart';
import '../models/destination.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({super.key, this.userId = 'user1'});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  String _selectedGender = 'Male';
  int _age = 20;
  bool _isLoading = true;
  bool _isSaving = false;
  final _db = DatabaseService();
  late AppUser _user;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final user = await _db.getUserById(widget.userId);
    if (user != null && mounted) {
      setState(() {
        _user = user;
        _nameController.text = user.name;
        _selectedGender = user.gender;
        _age = user.age;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    _user.name = _nameController.text.trim();
    _user.gender = _selectedGender;
    _user.age = _age;
    await _db.updateUser(_user);
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil berhasil disimpan!')));
    }
  }

  Future<void> _logout() async {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 36),
                    Column(
                      children: [
                        Text('Profil', style: AppTextStyles.heading),
                        Text(_user.name, style: AppTextStyles.subheading.copyWith(fontSize: 16)),
                      ],
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.inputBg),
                      child: Icon(Icons.person, size: 20, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(hint: 'Nama', controller: _nameController),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _radioGender('Male'),
                        const SizedBox(width: 20),
                        _radioGender('Female'),
                        const Spacer(),
                        _ageCounter(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Email: ${_user.email}', style: AppTextStyles.caption),
                    const SizedBox(height: 8),
                    Text('Poin: ${_user.totalPoints}', style: AppTextStyles.label),
                    const SizedBox(height: 24),
                    _isSaving ? Center(child: CircularProgressIndicator()) : PrimaryButton(label: 'Simpan', onTap: _saveProfile),
                    const SizedBox(height: 12),
                    PrimaryButton(label: 'Keluar', color: Colors.red, onTap: _logout),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _radioGender(String gender) {
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
              color: _selectedGender == gender ? AppColors.primary : Colors.transparent,
            ),
            child: _selectedGender == gender ? Icon(Icons.check, color: Colors.white, size: 12) : null,
          ),
          SizedBox(width: 6),
          Text(gender, style: AppTextStyles.label),
        ],
      ),
    );
  }

  Widget _ageCounter() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => setState(() => _age = (_age - 1).clamp(0, 120)),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(6)),
            child: Icon(Icons.remove, size: 16),
          ),
        ),
        SizedBox(width: 8),
        Container(
          width: 48,
          height: 36,
          decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center,
          child: Text('$_age', style: AppTextStyles.label),
        ),
        SizedBox(width: 8),
        GestureDetector(
          onTap: () => setState(() => _age = (_age + 1).clamp(0, 120)),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(6)),
            child: Icon(Icons.add, size: 16),
          ),
        ),
      ],
    );
  }
}
