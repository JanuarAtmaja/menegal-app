import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../models/destination.dart';
import '../services/database_service.dart';
import 'destination_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({super.key, this.userId = 'user1'});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
      backgroundColor: AppColors.background,
      // Drawer ditambahkan di sini
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Januar Atmaja"),
              accountEmail: Text("januarvino79@gmail.com"),
              currentAccountPicture: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person)),
            ),
            ListTile(leading: const Icon(Icons.home), title: const Text("Home"), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.logout), title: const Text("Logout"), onTap: () => Navigator.pushReplacementNamed(context, '/login')),
          ],
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  // Menggunakan Builder agar Scaffold.of(context) merujuk ke HomeScreen
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      child: Icon(Icons.menu, color: AppColors.textPrimary, size: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: AppSearchBar()),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: destinations.length,
                itemBuilder: (context, index) {
                  final dest = destinations[index];
                  return DestinationCardLarge(
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