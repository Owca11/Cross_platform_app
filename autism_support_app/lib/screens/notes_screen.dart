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

class _NotesScreenState extends State<NotesScreen> {
  final NotesService _notesService = NotesService();
  List<Note> _notes = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

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
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    final notes = await _notesService.getNotes();
    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  List<Note> get _filteredNotes {
    if (_selectedCategory == 'All') return _notes;
    return _notes.where((note) => note.category == _selectedCategory).toList();
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
            fontSize: 20,
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
        actions: [],
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
            Column(
              children: [
                // Category filter
                Container(
                  padding: EdgeInsets.all(16),
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Filter by Category',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _filteredNotes.isEmpty
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
                          itemCount: _filteredNotes.length,
                          itemBuilder: (context, index) {
                            final note = _filteredNotes[index];
                            return Card(
                              margin: EdgeInsets.only(bottom: 12),
                              color: Colors.pink.shade50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.purple.shade700,
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
                                          ...note.items.map(
                                            (item) => Padding(
                                              padding: EdgeInsets.only(
                                                bottom: 4,
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .check_box_outline_blank,
                                                    size: 16,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    item,
                                                    style:
                                                        GoogleFonts.quicksand(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
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
                                            child: CustomPaint(
                                              painter: DrawingPainter(
                                                note.drawingData,
                                              ),
                                              size: Size.infinite,
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
                            );
                          },
                        ),
                ),
              ],
            ),
            // Add note button in bottom right corner
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: _addNote,
                backgroundColor: Colors.purple.shade300,
                child: Icon(Icons.add, color: Colors.white),
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
  final List<List<Offset>> strokes;

  DrawingPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    for (final stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        if (stroke[i] != null && stroke[i + 1] != null) {
          canvas.drawLine(stroke[i], stroke[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
