flutterimport 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/note.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note? note;
  final Function(Note) onSave;

  const NoteDetailScreen({super.key, this.note, required this.onSave});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late NoteType _selectedType;
  late Color _selectedColor;
  late List<String> _items;
  late TextEditingController _itemController;
  late String _selectedCategory;
  late List<List<Offset>> _drawingData;

  final List<String> _categories = [
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
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    _selectedType = widget.note?.type ?? NoteType.text;
    _selectedColor = widget.note?.color ?? Colors.purple.shade300;
    _items = List.from(widget.note?.items ?? []);
    _itemController = TextEditingController();
    _selectedCategory = widget.note?.category ?? 'General';
    _drawingData = List.from(widget.note?.drawingData ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _itemController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a title')));
      return;
    }

    final note = Note(
      id: widget.note?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      type: _selectedType,
      color: _selectedColor,
      items: _items,
      category: _selectedCategory,
      drawingData: _drawingData,
    );

    widget.onSave(note);
    Navigator.of(context).pop();
  }

  void _addItem() {
    if (_itemController.text.trim().isNotEmpty) {
      setState(() {
        _items.add(_itemController.text.trim());
        _itemController.clear();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _selectedColor,
            onColorChanged: (color) {
              setState(() {
                _selectedColor = color;
              });
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  void _addFlower() {
    final flowers = ['🌸', '🌷', '🌹', '🌺', '🌻', '🌼', '💐', '🌹'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add a flower'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: flowers
              .map(
                (flower) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _contentController.text += flower;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(flower, style: TextStyle(fontSize: 24)),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note == null ? 'New Note' : 'Edit Note',
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
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                    ),
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Category and Type
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Category',
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
                      SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<NoteType>(
                          value: _selectedType,
                          decoration: InputDecoration(
                            labelText: 'Type',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                          ),
                          items: NoteType.values.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type.name.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Color picker
                  ElevatedButton.icon(
                    onPressed: _pickColor,
                    icon: Icon(Icons.color_lens),
                    label: Text('Pick Color'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Content based on type
                  if (_selectedType == NoteType.drawing) ...[
                    Text(
                      'Drawing',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: ClipRect(
                        child: GestureDetector(
                          onPanStart: (details) {
                            setState(() {
                              _drawingData.add([details.localPosition]);
                            });
                          },
                          onPanUpdate: (details) {
                            setState(() {
                              if (_drawingData.isNotEmpty) {
                                _drawingData.last.add(details.localPosition);
                              }
                            });
                          },
                          onPanEnd: (details) {
                            // Stroke ended, no need to add anything
                          },
                          child: CustomPaint(
                            painter: DrawingPainter(_drawingData),
                            size: Size.infinite,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _drawingData.clear();
                        });
                      },
                      child: Text('Clear Drawing'),
                    ),
                  ] else if (_selectedType == NoteType.shopping) ...[
                    Text(
                      'Shopping List',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _itemController,
                            decoration: InputDecoration(
                              labelText: 'Add item',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                            ),
                            onSubmitted: (_) => _addItem(),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _addItem,
                          child: Icon(Icons.add),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    ..._items.asMap().entries.map(
                      (entry) => ListTile(
                        title: Text(entry.value),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeItem(entry.key),
                        ),
                      ),
                    ),
                  ] else ...[
                    TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: 'Content',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                      maxLines: 10,
                      style: GoogleFonts.quicksand(),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _addFlower,
                      icon: Icon(Icons.local_florist),
                      label: Text('Add Flower'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade300,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Save button in bottom right corner
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: _saveNote,
                backgroundColor: Colors.pink.shade300,
                child: Text('🌸', style: TextStyle(fontSize: 24)),
              ),
            ),
          ],
        ),
      ),
    );
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
