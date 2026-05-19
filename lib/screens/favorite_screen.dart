import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../models/destination.dart';
import '../services/database_service.dart';
import 'destination_detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  final VoidCallback onBackToHome;
  final String userId;
  const FavoriteScreen({super.key, required this.onBackToHome, this.userId = 'user1'});

  @override
  State<FavoriteScreen> createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  List<Destination> _allDestinations = [];
  List<String> _favoriteIds = [];
  bool _isLoading = true;

  List<Destination> get favorites =>
      _allDestinations.where((d) => _favoriteIds.contains(d.id)).toList();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final db = DatabaseService();
    final dests = await db.getAllDestinations();
    final favIds = await db.getUserFavorites(widget.userId);
    if (mounted) {
      setState(() {
        _allDestinations = dests;
        _favoriteIds = favIds;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(String id) async {
    final db = DatabaseService();
    if (_favoriteIds.contains(id)) {
      await db.removeFavorite(widget.userId, id);
      setState(() => _favoriteIds.remove(id));
    } else {
      await db.addFavorite(widget.userId, id);
      setState(() => _favoriteIds.add(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 36),
                  Text('Favorite', style: AppTextStyles.heading.copyWith(color: AppColors.textPrimary)),
                  GestureDetector(
                    onTap: widget.onBackToHome,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.inputBg,
                      ),
                      child: const Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppSearchBar(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : favorites.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite_border, size: 64, color: AppColors.textHint),
                              const SizedBox(height: 12),
                              Text('No favorites yet', style: AppTextStyles.body),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: favorites.length,
                          itemBuilder: (context, index) {
                            final dest = favorites[index];
                            dest.isFavorite = true;
                            return DestinationCardSmall(
                              destination: dest,
                              onExplore: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DestinationDetailScreen(
                                      destination: dest,
                                      userId: widget.userId,
                                      onFavoriteChanged: (id, isFav) {
                                        if (!isFav) {
                                          setState(() => _favoriteIds.remove(id));
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                              onBookmark: () => _toggleFavorite(dest.id),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
