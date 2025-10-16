import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../data/sample_data.dart';
import '../services/favorites_service.dart';
import '../services/emotion_service.dart';
import '../models/feeling.dart';

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

  List<Feeling> _feelings = [];
  List<Need> _needs = [];
  List<Thought> _thoughts = [];

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
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final feelings = await EmotionService.getFeelings();
    final needs = await EmotionService.getNeeds();
    final thoughts = await EmotionService.getThoughts();
    final favoriteFeelings = await FavoritesService.getFavoriteFeelings();
    final favoriteNeeds = await FavoritesService.getFavoriteNeeds();
    final favoriteThoughts = await FavoritesService.getFavoriteThoughts();
    setState(() {
      _feelings = feelings;
      _needs = needs;
      _thoughts = thoughts;
      _favoriteFeelings = favoriteFeelings;
      _favoriteNeeds = favoriteNeeds;
      _favoriteThoughts = favoriteThoughts;
    });
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

  void _showEditDialog(BuildContext context, dynamic item) async {
    final TextEditingController nameController = TextEditingController(
      text: item.name,
    );
    final TextEditingController promptController = TextEditingController(
      text: item.prompt,
    );

    bool isCustom = false;
    if (item is Feeling) {
      isCustom = await EmotionService.isCustomFeeling(item.name);
    } else if (item is Need) {
      isCustom = await EmotionService.isCustomNeed(item.name);
    } else if (item is Thought) {
      isCustom = await EmotionService.isCustomThought(item.name);
    }

    IconData selectedIcon = item.icon;
    Color selectedColor = item.color;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                gradient: LinearGradient(
                  colors: [Colors.purple.shade100, Colors.pink.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Edit ${item.name}',
                    style: GoogleFonts.quicksand(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    readOnly: !isCustom,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: GoogleFonts.quicksand(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: GoogleFonts.quicksand(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: promptController,
                    decoration: InputDecoration(
                      labelText: 'Prompt',
                      labelStyle: GoogleFonts.quicksand(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: GoogleFonts.quicksand(),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Icon: ', style: GoogleFonts.quicksand()),
                      IconButton(
                        icon: Icon(selectedIcon, color: selectedColor),
                        onPressed: () async {
                          final icons = [
                            Icons.sentiment_satisfied,
                            Icons.sentiment_dissatisfied,
                            Icons.sentiment_neutral,
                            Icons.celebration,
                            Icons.bedtime,
                            Icons.error_outline,
                            Icons.warning,
                            Icons.spa,
                            Icons.blur_on,
                            Icons.person_off,
                            Icons.emoji_events,
                            Icons.local_drink,
                            Icons.restaurant,
                            Icons.hotel,
                            Icons.help,
                            Icons.favorite,
                            Icons.volume_off,
                            Icons.wc,
                            Icons.medical_services,
                            Icons.chair,
                            Icons.visibility,
                            Icons.space_bar,
                            Icons.chat,
                            Icons.help_outline,
                            Icons.lightbulb,
                            Icons.memory,
                            Icons.lightbulb_outline,
                            Icons.question_mark,
                            Icons.cancel,
                            Icons.check_circle,
                            Icons.cloud,
                            Icons.schedule,
                            Icons.star,
                            Icons.info,
                          ];
                          final selected = await showDialog<IconData>(
                            context: context,
                            builder: (context) => Dialog(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: MediaQuery.of(context).size.height * 0.6,
                                child: GridView.builder(
                                  padding: const EdgeInsets.all(16),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 6,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                  ),
                                  itemCount: icons.length,
                                  itemBuilder: (context, index) => IconButton(
                                    icon: Icon(icons[index], color: selectedColor),
                                    onPressed: () => Navigator.of(context).pop(icons[index]),
                                  ),
                                ),
                              ),
                            ),
                          );
                          if (selected != null) {
                            setState(() => selectedIcon = selected);
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      Text('Color: ', style: GoogleFonts.quicksand()),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Pick a color', style: GoogleFonts.quicksand()),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: selectedColor,
                                  onColorChanged: (color) => setState(() => selectedColor = color),
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  child: Text('Done', style: GoogleFonts.quicksand()),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: selectedColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final newName = nameController.text.trim();
                          final newPrompt = promptController.text.trim();
                          if (newName.isNotEmpty && newPrompt.isNotEmpty) {
                            if (item is Feeling) {
                              await EmotionService.updateFeeling(
                                item.name,
                                newName,
                                newPrompt,
                                selectedIcon,
                                selectedColor,
                              );
                            } else if (item is Need) {
                              await EmotionService.updateNeed(
                                item.name,
                                newName,
                                newPrompt,
                                selectedIcon,
                                selectedColor,
                              );
                            } else if (item is Thought) {
                              await EmotionService.updateThought(
                                item.name,
                                newName,
                                newPrompt,
                                selectedIcon,
                                selectedColor,
                              );
                            }
                            await _loadData();
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _toggleFavorite(String name) async {
    // Determine the category based on the item name
    if (_feelings.any((item) => item.name == name)) {
      await FavoritesService.toggleFavoriteFeeling(name);
    } else if (_needs.any((item) => item.name == name)) {
      await FavoritesService.toggleFavoriteNeed(name);
    } else if (_thoughts.any((item) => item.name == name)) {
      await FavoritesService.toggleFavoriteThought(name);
    }
    await _loadFavorites();
  }

  bool _isFavorite(String name) {
    if (_feelings.any((item) => item.name == name)) {
      return _favoriteFeelings.contains(name);
    } else if (_needs.any((item) => item.name == name)) {
      return _favoriteNeeds.contains(name);
    } else if (_thoughts.any((item) => item.name == name)) {
      return _favoriteThoughts.contains(name);
    }
    return false;
  }

  List<dynamic> _getFilteredItems(String category) {
    switch (category) {
      case 'All':
        final allItems = [..._feelings, ..._needs, ..._thoughts];
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
          ..._feelings.where((item) => _favoriteFeelings.contains(item.name)),
          ..._needs.where((item) => _favoriteNeeds.contains(item.name)),
          ..._thoughts.where((item) => _favoriteThoughts.contains(item.name)),
        ];
      case 'Feelings':
        final feelings = List.from(_feelings);
        feelings.sort((a, b) {
          final aFav = _favoriteFeelings.contains(a.name);
          final bFav = _favoriteFeelings.contains(b.name);
          if (aFav && !bFav) return -1;
          if (!aFav && bFav) return 1;
          return 0;
        });
        return feelings;
      case 'Needs':
        final needs = List.from(_needs);
        needs.sort((a, b) {
          final aFav = _favoriteNeeds.contains(a.name);
          final bFav = _favoriteNeeds.contains(b.name);
          if (aFav && !bFav) return -1;
          if (!aFav && bFav) return 1;
          return 0;
        });
        return needs;
      case 'Thoughts':
        final thoughts = List.from(_thoughts);
        thoughts.sort((a, b) {
          final aFav = _favoriteThoughts.contains(a.name);
          final bFav = _favoriteThoughts.contains(b.name);
          if (aFav && !bFav) return -1;
          if (!aFav && bFav) return 1;
          return 0;
        });
        return thoughts;
      default:
        return _feelings;
    }
  }

  void _showCreateDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController promptController = TextEditingController();
    IconData selectedIcon = Icons.sentiment_satisfied;
    Color selectedColor = Colors.blue;
    String selectedType = 'Feeling';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                gradient: LinearGradient(
                  colors: [Colors.purple.shade100, Colors.pink.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Create New Item',
                    style: GoogleFonts.quicksand(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    items: ['Feeling', 'Need', 'Thought']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type, style: GoogleFonts.quicksand()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedType = value);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Type',
                      labelStyle: GoogleFonts.quicksand(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: GoogleFonts.quicksand(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: GoogleFonts.quicksand(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: promptController,
                    decoration: InputDecoration(
                      labelText: 'Prompt',
                      labelStyle: GoogleFonts.quicksand(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: GoogleFonts.quicksand(),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Icon: ', style: GoogleFonts.quicksand()),
                      IconButton(
                        icon: Icon(selectedIcon, color: selectedColor),
                        onPressed: () async {
                          final icons = [
                            Icons.sentiment_satisfied,
                            Icons.sentiment_dissatisfied,
                            Icons.sentiment_neutral,
                            Icons.celebration,
                            Icons.bedtime,
                            Icons.error_outline,
                            Icons.warning,
                            Icons.spa,
                            Icons.blur_on,
                            Icons.person_off,
                            Icons.emoji_events,
                            Icons.local_drink,
                            Icons.restaurant,
                            Icons.hotel,
                            Icons.help,
                            Icons.favorite,
                            Icons.volume_off,
                            Icons.wc,
                            Icons.medical_services,
                            Icons.chair,
                            Icons.visibility,
                            Icons.space_bar,
                            Icons.chat,
                            Icons.help_outline,
                            Icons.lightbulb,
                            Icons.memory,
                            Icons.lightbulb_outline,
                            Icons.question_mark,
                            Icons.cancel,
                            Icons.check_circle,
                            Icons.cloud,
                            Icons.schedule,
                            Icons.star,
                            Icons.info,
                          ];
                          final selected = await showDialog<IconData>(
                            context: context,
                            builder: (context) => Dialog(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: MediaQuery.of(context).size.height * 0.6,
                                child: GridView.builder(
                                  padding: const EdgeInsets.all(16),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 6,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                  ),
                                  itemCount: icons.length,
                                  itemBuilder: (context, index) => IconButton(
                                    icon: Icon(icons[index], color: selectedColor),
                                    onPressed: () => Navigator.of(context).pop(icons[index]),
                                  ),
                                ),
                              ),
                            ),
                          );
                          if (selected != null) {
                            setState(() => selectedIcon = selected);
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      Text('Color: ', style: GoogleFonts.quicksand()),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Pick a color', style: GoogleFonts.quicksand()),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: selectedColor,
                                  onColorChanged: (color) => setState(() => selectedColor = color),
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  child: Text('Done', style: GoogleFonts.quicksand()),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: selectedColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final name = nameController.text.trim();
                          final prompt = promptController.text.trim();
                          if (name.isNotEmpty && prompt.isNotEmpty) {
                            if (selectedType == 'Feeling') {
                              await EmotionService.saveFeeling(
                                Feeling(
                                  name: name,
                                  icon: selectedIcon,
                                  prompt: prompt,
                                  color: selectedColor,
                                ),
                              );
                            } else if (selectedType == 'Need') {
                              await EmotionService.saveNeed(
                                Need(
                                  name: name,
                                  icon: selectedIcon,
                                  prompt: prompt,
                                  color: selectedColor,
                                ),
                              );
                            } else if (selectedType == 'Thought') {
                              await EmotionService.saveThought(
                                Thought(
                                  name: name,
                                  icon: selectedIcon,
                                  prompt: prompt,
                                  color: selectedColor,
                                ),
                              );
                            }
                            await _loadData();
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: Text(
                          'Create',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
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
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(context).size.width > 600
                    ? 220
                    : 200,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.0,
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
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.45,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purple,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15.0,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
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
                                    ElevatedButton(
                                      onPressed: () =>
                                          _showEditDialog(context, item),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15.0,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                      ),
                                      child: Text(
                                        'Edit',
                                        style: GoogleFonts.quicksand(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                                        MediaQuery.of(context).size.width > 600
                                        ? MediaQuery.of(context).size.width *
                                              0.1
                                        : MediaQuery.of(context).size.width *
                                              0.15,
                                    color: item.color,
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
                                        fontSize:
                                            MediaQuery.of(context).size.width >
                                                600
                                            ? 16
                                            : 20,
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
