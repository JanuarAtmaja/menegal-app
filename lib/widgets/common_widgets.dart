import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/destination.dart';

// ─── Custom Input Field ─────────────────────────────────────────────────────

class AppTextField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const AppTextField({
    super.key,
    required this.hint,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.inputDecoration,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: AppTextStyles.label,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.label.copyWith(color: AppColors.textHint),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}

// ─── Primary Button ──────────────────────────────────────────────────────────

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color ?? AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(label, style: AppTextStyles.button),
      ),
    );
  }
}

// ─── Secondary Button ────────────────────────────────────────────────────────

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const SecondaryButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: AppDecorations.secondaryButtonDecoration,
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.button.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}

// ─── Outline Button ──────────────────────────────────────────────────────────

class OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const OutlineButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: AppDecorations.outlineButtonDecoration,
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.button.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}

// ─── Search Bar ──────────────────────────────────────────────────────────────

class AppSearchBar extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const AppSearchBar({
    super.key,
    this.hint = 'Search destination...',
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.textHint, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTextStyles.label,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.label.copyWith(color: AppColors.textHint),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Destination Card (Home - large) ─────────────────────────────────────────

class DestinationCardLarge extends StatelessWidget {
  final Destination destination;
  final VoidCallback onExplore;
  final VoidCallback onBookmark;

  const DestinationCardLarge({
    super.key,
    required this.destination,
    required this.onExplore,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppDecorations.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              height: 200,
              width: double.infinity,
              color: AppColors.primaryLight,
              child: Image.asset(destination.imageUrl, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(destination.name, style: AppTextStyles.subheading),
                    ),
                    Icon(Icons.info_outline, color: AppColors.textSecondary, size: 20),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${destination.address.substring(0, destination.address.length > 30 ? 30 : destination.address.length)}...',
                  style: AppTextStyles.caption,
                ),
                Text('${destination.distanceKm.toInt()} km', style: AppTextStyles.distance),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: onBookmark,
                      child: Icon(
                        destination.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: onExplore,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text('Explore', style: AppTextStyles.button.copyWith(fontSize: 14)),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Destination Card (List - small) ─────────────────────────────────────────

class DestinationCardSmall extends StatelessWidget {
  final Destination destination;
  final VoidCallback onExplore;
  final VoidCallback onBookmark;

  const DestinationCardSmall({
    super.key,
    required this.destination,
    required this.onExplore,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: AppDecorations.cardDecoration,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: AppColors.primaryLight,
              child: Image.asset(
                destination.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(destination.name, style: AppTextStyles.subheading.copyWith(fontSize: 15)),
                const SizedBox(height: 2),
                Text(
                  '${destination.address.substring(0, destination.address.length > 28 ? 28 : destination.address.length)}...',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${destination.distanceKm.toInt()} km', style: AppTextStyles.distance),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: onBookmark,
                          child: Icon(
                            destination.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: onExplore,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Navigation Bar ────────────────────────────────────────────────────

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Home'},
      {'icon': Icons.explore_outlined, 'activeIcon': Icons.explore, 'label': 'Explore'},
      {'icon': Icons.favorite_border, 'activeIcon': Icons.favorite, 'label': 'Favorite'},
      {'icon': Icons.person_outline, 'activeIcon': Icons.person, 'label': 'Profil'},
      {'icon': Icons.leaderboard_outlined, 'activeIcon': Icons.leaderboard, 'label': 'Ranking'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isActive = currentIndex == index;
              return GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isActive
                          ? items[index]['activeIcon'] as IconData
                          : items[index]['icon'] as IconData,
                      color: isActive ? AppColors.primary : AppColors.textSecondary,
                      size: 24,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      items[index]['label'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}