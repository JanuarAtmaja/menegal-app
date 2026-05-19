import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../models/destination.dart';
import '../services/database_service.dart';
import 'destination_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  final VoidCallback onBackToHome;
  final String userId;
  const ExploreScreen({super.key, this.userId = 'user1', required this.onBackToHome});

  @override
  State<ExploreScreen> createState() => ExploreScreenState();
}

class ExploreScreenState extends State<ExploreScreen> {
  List<Destination> destinations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final db = DatabaseService();
    final dests = await db.getAllDestinations();
    final favIds = await db.getUserFavorites(widget.userId);
    for (final d in dests) {
      d.isFavorite = favIds.contains(d.id);
    }
    if (mounted) {
      setState(() {
        destinations = dests;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(String id) async {
    final db = DatabaseService();
    final dest = destinations.firstWhere((d) => d.id == id);
    if (dest.isFavorite) {
      await db.removeFavorite(widget.userId, id);
    } else {
      await db.addFavorite(widget.userId, id);
    }
    setState(() => dest.isFavorite = !dest.isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 36),
                  Text('Explore', style: AppTextStyles.heading.copyWith(color: AppColors.textPrimary)),
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
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AppSearchBar(),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: destinations.length,
                itemBuilder: (context, index) {
                  final dest = destinations[index];
                  return DestinationCardSmall(
                    destination: dest,
                    onExplore: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DestinationDetailScreen(
                            destination: dest,
                            userId: widget.userId,
                            onFavoriteChanged: (id, isFav) {
                              setState(() => dest.isFavorite = isFav);
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

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1;

    const step = 30.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}