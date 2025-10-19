import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/note.dart';
import '../services/notes_service.dart';
import 'note_detail_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with SingleTickerProviderStateMixin {
  final NotesService _notesService = NotesService();
  List<Note> _notes = [];
  bool _isLoading = true;
  late TabController _tabController;

  final List<String> _categories = [
    'All',
    'General',
    'Personal',
    'Work',
    'Ideas',
    'Reminders',
    'Shopping',
    'Health',
    'Travel',
    'Education',
    'Entertainment',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadNotes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    final notes = await _notesService.getNotes();
    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  List<Note> _getFilteredNotes(String category) {
    if (category == 'All') return _notes;
    return _notes.where((note) => note.category == category).toList();
  }

  void _addNote() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoteDetailScreen(
          onSave: (note) async {
            await _notesService.saveNote(note);
            _loadNotes();
          },
        ),
      ),
    );
  }

  void _editNote(Note note) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoteDetailScreen(
          note: note,
          onSave: (updatedNote) async {
            await _notesService.saveNote(updatedNote);
            _loadNotes();
          },
        ),
      ),
    );
  }

  Future<void> _deleteNote(Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Note'),
        content: Text('Are you sure you want to delete "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _notesService.deleteNote(note.id);
      _loadNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Notes',
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
        child: Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: _categories.map((category) {
                final filteredNotes = _getFilteredNotes(category);
                return _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : filteredNotes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '🌸 No notes yet 🌸',
                              style: GoogleFonts.quicksand(
                                fontSize: 24,
                                color: Colors.purple.shade300,
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _addNote,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade300,
                                foregroundColor: Colors.white,
                              ),
                              child: Text('Create Your First Note'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: filteredNotes.length,
                        itemBuilder: (context, index) {
                          final note = filteredNotes[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 4,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.7),
                                    Colors.purple.shade50,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: ExpansionTile(
                                title: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: note.color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        note.title,
                                        style: GoogleFonts.quicksand(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.purple.shade800,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      _getTypeIcon(note.type),
                                      color: note.color,
                                      size: 20,
                                    ),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (note.type == NoteType.shopping &&
                                            note.items.isNotEmpty)
                                          ...note.items.asMap().entries.map((
                                            entry,
                                          ) {
                                            final index = entry.key;
                                            final item = entry.value;
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                bottom: 4,
                                              ),
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                    value: note
                                                        .completedItems[index],
                                                    onChanged: (value) async {
                                                      setState(() {
                                                        note.completedItems[index] =
                                                            value ?? false;
                                                      });
                                                      await _notesService
                                                          .saveNote(note);
                                                    },
                                                    activeColor:
                                                        Colors.purple.shade300,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      item,
                                                      style: GoogleFonts.quicksand(
                                                        decoration:
                                                            note.completedItems[index]
                                                            ? TextDecoration
                                                                  .lineThrough
                                                            : null,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        if (note.content.isNotEmpty)
                                          Text(
                                            note.content,
                                            style: GoogleFonts.quicksand(
                                              fontSize: 14,
                                            ),
                                          ),
                                        if (note.type == NoteType.drawing &&
                                            note.drawingData.isNotEmpty)
                                          Container(
                                            height: 150,
                                            margin: EdgeInsets.only(top: 8),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Drawing Note - Tap to Edit',
                                                style: GoogleFonts.quicksand(
                                                  fontSize: 16,
                                                  color: Colors.purple.shade300,
                                                ),
                                              ),
                                            ),
                                          ),
                                        SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton.icon(
                                              onPressed: () => _editNote(note),
                                              icon: Icon(Icons.edit, size: 16),
                                              label: Text('Edit'),
                                            ),
                                            TextButton.icon(
                                              onPressed: () =>
                                                  _deleteNote(note),
                                              icon: Icon(
                                                Icons.delete,
                                                size: 16,
                                              ),
                                              label: Text('Delete'),
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              }).toList(),
            ),
            // Add note button in bottom right corner
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: _addNote,
                backgroundColor: Colors.pink.shade300,
                child: Text('🌸', style: TextStyle(fontSize: 24)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(NoteType type) {
    switch (type) {
      case NoteType.text:
        return Icons.text_fields;
      case NoteType.shopping:
        return Icons.shopping_cart;
      case NoteType.reminder:
        return Icons.alarm;
      case NoteType.drawing:
        return Icons.brush;
    }
  }
}

class DrawingPainter extends CustomPainter {
  final List<Map<String, dynamic>> strokes;
  final Color defaultColor;

  DrawingPainter(this.strokes, this.defaultColor);

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final points = stroke['points'] as List<Offset>;
      final colorValue = stroke['color'] as int?;
      final paint = Paint()
        ..color = colorValue != null ? Color(colorValue) : defaultColor
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < points.length - 1; i++) {
        if (points[i + 1] != null) {
          canvas.drawLine(points[i], points[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
