import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/database_service.dart';
import '../models/destination.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => LeaderboardScreenState();
}

class LeaderboardScreenState extends State<LeaderboardScreen> {
  final _db = DatabaseService();
  List<AppUser> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (mounted) setState(() => _isLoading = true);
    final users = await _db.getLeaderboard();
    if (mounted) setState(() { _users = users; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Leaderboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? Center(child: Text('Tidak ada data', style: AppTextStyles.body))
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    if (_users.length >= 3) _buildPodium(_users.take(3).toList()),
                    const SizedBox(height: 20),
                    Text('Semua Peringkat', style: AppTextStyles.subheading.copyWith(fontSize: 15)),
                    const SizedBox(height: 12),
                    ...List.generate(_users.length, (index) {
                      final user = _users[index];
                      final rank = index + 1;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(color: _rankColor(rank), shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: rank <= 3
                                  ? Text(_rankEmoji(rank), style: const TextStyle(fontSize: 18))
                                  : Text('$rank', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.name, style: AppTextStyles.label),
                                  Text(user.email, style: AppTextStyles.caption),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text('${user.totalPoints}', style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
    );
  }

  Widget _buildPodium(List<AppUser> topThree) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF2A7F7F), Color(0xFF3A9F9F)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text('🏆 Top 3 Penjelajah', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _podiumItem(topThree[1], 2, height: 70),
              _podiumItem(topThree[0], 1, height: 90),
              _podiumItem(topThree[2], 3, height: 55),
            ],
          ),
        ],
      ),
    );
  }

  Widget _podiumItem(AppUser user, int rank, {required double height}) {
    return Column(
      children: [
        Text(_rankEmoji(rank), style: TextStyle(fontSize: 24)),
        SizedBox(height: 4),
        Text(user.name.split(' ').first, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        SizedBox(height: 2),
        Text('${user.totalPoints} poin', style: TextStyle(color: Colors.white70, fontSize: 11)),
        SizedBox(height: 6),
        Container(
          width: 60,
          height: height,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
          alignment: Alignment.center,
          child: Text('#$rank', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
        ),
      ],
    );
  }

  Color _rankColor(int rank) {
    switch (rank) {
      case 1: return Colors.amber;
      case 2: return Colors.blueGrey.shade400;
      case 3: return Colors.brown.shade400;
      default: return AppColors.primary;
    }
  }

  String _rankEmoji(int rank) {
    switch (rank) {
      case 1: return '🥇';
      case 2: return '🥈';
      case 3: return '🥉';
      default: return '';
    }
  }
}
