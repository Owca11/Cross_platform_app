import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/sample_data.dart';
import '../services/favorites_service.dart';

class FeelingSelectionScreen extends StatefulWidget {
  const FeelingSelectionScreen({super.key});

  @override
  State<FeelingSelectionScreen> createState() => _FeelingSelectionScreenState();
}

class _FeelingSelectionScreenState extends State<FeelingSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Set<String> _favoriteFeelings = {};
  Set<String> _favoriteNeeds = {};
  Set<String> _favoriteThoughts = {};

  final List<String> _categories = [
    'All',
    'Favourite',
    'Feelings',
    'Needs',
    'Thoughts',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadFavorites();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    final feelings = await FavoritesService.getFavoriteFeelings();
    final needs = await FavoritesService.getFavoriteNeeds();
    final thoughts = await FavoritesService.getFavoriteThoughts();
    setState(() {
      _favoriteFeelings = feelings;
      _favoriteNeeds = needs;
      _favoriteThoughts = thoughts;
    });
  }

  Future<void> _toggleFavorite(String name) async {
    // Determine the category based on the item name
    if (sampleFeelings.any((item) => item.name == name)) {
      await FavoritesService.toggleFavoriteFeeling(name);
    } else if (sampleNeeds.any((item) => item.name == name)) {
      await FavoritesService.toggleFavoriteNeed(name);
    } else if (sampleThoughts.any((item) => item.name == name)) {
      await FavoritesService.toggleFavoriteThought(name);
    }
    await _loadFavorites();
  }

  bool _isFavorite(String name) {
    if (sampleFeelings.any((item) => item.name == name)) {
      return _favoriteFeelings.contains(name);
    } else if (sampleNeeds.any((item) => item.name == name)) {
      return _favoriteNeeds.contains(name);
    } else if (sampleThoughts.any((item) => item.name == name)) {
      return _favoriteThoughts.contains(name);
    }
    return false;
  }

  List<dynamic> _getFilteredItems(String category) {
    switch (category) {
      case 'All':
        final allItems = [...sampleFeelings, ...sampleNeeds, ...sampleThoughts];
        allItems.sort((a, b) {
          final aFav = _isFavorite((a as dynamic).name);
          final bFav = _isFavorite((b as dynamic).name);
          if (aFav && !bFav) return -1;
          if (!aFav && bFav) return 1;
          return 0;
        });
        return allItems;
      case 'Favourite':
        return [
          ...sampleFeelings.where(
            (item) => _favoriteFeelings.contains(item.name),
          ),
          ...sampleNeeds.where((item) => _favoriteNeeds.contains(item.name)),
          ...sampleThoughts.where(
            (item) => _favoriteThoughts.contains(item.name),
          ),
        ];
      case 'Feelings':
        final feelings = List.from(sampleFeelings);
        feelings.sort((a, b) {
          final aFav = _favoriteFeelings.contains(a.name);
          final bFav = _favoriteFeelings.contains(b.name);
          if (aFav && !bFav) return -1;
          if (!aFav && bFav) return 1;
          return 0;
        });
        return feelings;
      case 'Needs':
        final needs = List.from(sampleNeeds);
        needs.sort((a, b) {
          final aFav = _favoriteNeeds.contains(a.name);
          final bFav = _favoriteNeeds.contains(b.name);
          if (aFav && !bFav) return -1;
          if (!aFav && bFav) return 1;
          return 0;
        });
        return needs;
      case 'Thoughts':
        final thoughts = List.from(sampleThoughts);
        thoughts.sort((a, b) {
          final aFav = _favoriteThoughts.contains(a.name);
          final bFav = _favoriteThoughts.contains(b.name);
          if (aFav && !bFav) return -1;
          if (!aFav && bFav) return 1;
          return 0;
        });
        return thoughts;
      default:
        return sampleFeelings;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Express Yourself',
          style: GoogleFonts.quicksand(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade300, Colors.pink.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.quicksand(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          tabs: _categories.map((category) => Tab(text: category)).toList(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50, Colors.pink.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: _categories.map((category) {
            final filteredItems = _getFilteredItems(category);
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return GestureDetector(
                  onTap: () {
                    // Show bigger picture with text
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.shade100,
                                Colors.pink.shade100,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                item.icon,
                                size: 100,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                item.name,
                                style: GoogleFonts.quicksand(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade800,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                item.prompt,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                  fontSize: 18,
                                  color: Colors.purple.shade700,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  'OK',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.purple.shade50],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Icon(
                                    item.icon,
                                    size:
                                        MediaQuery.of(context).size.width *
                                        0.15,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text(
                                      item.name,
                                      style: GoogleFonts.quicksand(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple.shade800,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: Icon(
                                _isFavorite(item.name)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isFavorite(item.name)
                                    ? Colors.red
                                    : Colors.grey,
                                size: 24,
                              ),
                              onPressed: () => _toggleFavorite(item.name),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
