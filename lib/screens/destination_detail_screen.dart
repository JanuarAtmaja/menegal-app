import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../models/destination.dart';
import '../services/database_service.dart';
import 'trivia_screen.dart';

class DestinationDetailScreen extends StatefulWidget {
  final Destination destination;
  final String userId;
  final Function(String destinationId, bool isFavorite)? onFavoriteChanged;

  const DestinationDetailScreen({
    super.key,
    required this.destination,
    this.userId = 'user1',
    this.onFavoriteChanged,
  });

  @override
  State<DestinationDetailScreen> createState() => _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.destination.isFavorite;
  }

  Future<void> _toggleBookmark() async {
    final db = DatabaseService();
    if (_isBookmarked) {
      await db.removeFavorite(widget.userId, widget.destination.id);
    } else {
      await db.addFavorite(widget.userId, widget.destination.id);
    }
    setState(() => _isBookmarked = !_isBookmarked);
    widget.onFavoriteChanged?.call(widget.destination.id, _isBookmarked);
  }

  Future<void> _openWebsite() async {
    final url = widget.destination.websiteUrl;
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('URL belum tersedia')));
      return;
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak bisa membuka URL')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dest = widget.destination;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.chevron_left, size: 28, color: AppColors.textPrimary),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(dest.name, style: AppTextStyles.subheading.copyWith(fontSize: 18)),
                        Text(dest.address, style: AppTextStyles.caption, textAlign: TextAlign.center),
                        Text('${dest.distanceKm.toInt()} km', style: AppTextStyles.distance),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _toggleBookmark,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.inputBg),
                      child: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: AppColors.primary, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Hero Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 220,
                  width: double.infinity,
                  color: AppColors.primaryLight,
                  child: Image.asset(dest.imageUrl, fit: BoxFit.cover),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dest.description, style: AppTextStyles.body.copyWith(color: AppColors.textPrimary, height: 1.7)),
                    const SizedBox(height: 20),

                    // Maps
                    Text('Lokasi', style: AppTextStyles.subheading.copyWith(fontSize: 15)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 180,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(dest.latitude, dest.longitude),
                            zoom: 14,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId(dest.id),
                              position: LatLng(dest.latitude, dest.longitude),
                              infoWindow: InfoWindow(title: dest.name),
                            ),
                          },
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                          liteModeEnabled: true,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Tombol aksi bawah
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Row(
                children: [
                  // Tombol Trivia
                  Expanded(
                    child: GestureDetector(
                      onTap: dest.trivia.isEmpty
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => TriviaScreen(destination: dest, userId: widget.userId)),
                              );
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: dest.trivia.isEmpty ? AppColors.inputBg : AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.quiz_outlined, color: AppColors.primary, size: 18),
                            const SizedBox(width: 6),
                            Text('Trivia', style: AppTextStyles.button.copyWith(color: AppColors.primary, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Tombol Kunjungi
                  Expanded(
                    child: GestureDetector(
                      onTap: _openWebsite,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.open_in_new, color: Colors.white, size: 18),
                            const SizedBox(width: 6),
                            Text('Kunjungi', style: AppTextStyles.button.copyWith(fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
