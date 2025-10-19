import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
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
  late List<bool> _completedItems;
  late TextEditingController _itemController;
  late String _selectedCategory;
  late List<Map<String, dynamic>> _drawingData;
  late Color _drawingColor;
  late bool _isErasing;
  late Color _currentColor;
  late double _strokeWidth;

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
    _completedItems = List.from(widget.note?.completedItems ?? []);
    _itemController = TextEditingController();
    _selectedCategory = widget.note?.category ?? 'General';
    _drawingData = List.from(widget.note?.drawingData ?? []);
    _drawingColor = Colors.black; // Default drawing color
    _isErasing = false;
    _currentColor = _drawingColor;
    _strokeWidth = 3.0; // Default stroke width
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
      completedItems: _completedItems,
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
        _completedItems.add(false);
        _itemController.clear();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _completedItems.removeAt(index);
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

  void _pickDrawingColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pick drawing color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _drawingColor,
            onColorChanged: (color) {
              setState(() {
                _drawingColor = color;
                if (!_isErasing) {
                  _currentColor = _drawingColor;
                }
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
        height: MediaQuery.of(context).size.height,
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
                          initialValue: _selectedCategory,
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
                          initialValue: _selectedType,
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

                  // Drawing color picker (only for drawing type)
                  if (_selectedType == NoteType.drawing) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickDrawingColor,
                            icon: Icon(Icons.color_lens),
                            label: Text('Pick Drawing Color'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _drawingColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _isErasing = !_isErasing;
                                _currentColor = _isErasing
                                    ? Colors.white
                                    : _drawingColor;
                              });
                            },
                            icon: Icon(
                              _isErasing ? Icons.edit : Icons.cleaning_services,
                            ),
                            label: Text(_isErasing ? 'Draw' : 'Erase'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isErasing
                                  ? Colors.red.shade300
                                  : Colors.blue.shade300,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Stroke width slider
                    Text(
                      'Stroke Width: ${_strokeWidth.toStringAsFixed(1)}',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Slider(
                      value: _strokeWidth,
                      min: 1.0,
                      max: 10.0,
                      divisions: 9,
                      label: _strokeWidth.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() {
                          _strokeWidth = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                  ],

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
                      height: MediaQuery.of(context).size.height * 0.45,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: ClipRect(
                        child: RawGestureDetector(
                          gestures: {
                            PanGestureRecognizer:
                                GestureRecognizerFactoryWithHandlers<
                                  PanGestureRecognizer
                                >(() => PanGestureRecognizer(), (
                                  PanGestureRecognizer instance,
                                ) {
                                  instance
                                    ..onStart = (details) {
                                      setState(() {
                                        _drawingData.add({
                                          'points': [details.localPosition],
                                          'color': _currentColor.value,
                                          'strokeWidth': _strokeWidth,
                                        });
                                      });
                                    }
                                    ..onUpdate = (details) {
                                      setState(() {
                                        if (_drawingData.isNotEmpty) {
                                          // Clamp the position to the drawing area bounds
                                          final clampedPosition = Offset(
                                            details.localPosition.dx.clamp(
                                              0.0,
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width -
                                                  32,
                                            ),
                                            details.localPosition.dy.clamp(
                                              0.0,
                                              MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.45,
                                            ),
                                          );
                                          (_drawingData.last['points']
                                                  as List<Offset>)
                                              .add(clampedPosition);
                                        }
                                      });
                                    }
                                    ..onEnd = (details) {
                                      // Stroke ended, no need to add anything
                                    };
                                }),
                          },
                          child: CustomPaint(
                            painter: DrawingPainter(
                              _drawingData,
                              _drawingColor,
                            ),
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
                        leading: Checkbox(
                          value: _completedItems[entry.key],
                          onChanged: (value) {
                            setState(() {
                              _completedItems[entry.key] = value ?? false;
                            });
                          },
                        ),
                        title: Text(
                          entry.value,
                          style: TextStyle(
                            decoration: _completedItems[entry.key]
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
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
              child: ElevatedButton.icon(
                onPressed: _saveNote,
                icon: Icon(Icons.save),
                label: Text('Save Note'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade300,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
      final strokeWidth = stroke['strokeWidth'] as double? ?? 3.0;
      final paint = Paint()
        ..color = colorValue != null ? Color(colorValue) : defaultColor
        ..strokeWidth = strokeWidth
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
