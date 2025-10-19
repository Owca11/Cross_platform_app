import 'package:flutter/material.dart';

enum NoteType { text, shopping, reminder, drawing }

class Note {
  String id;
  String title;
  String content;
  NoteType type;
  Color color;
  List<String> items; // For shopping lists
  List<bool> completedItems; // For shopping lists, tracks completion status
  DateTime createdAt;
  DateTime? reminderDate; // For reminders
  String category; // New: category for organization
  List<Map<String, dynamic>>
  drawingData; // New: for drawing notes, each map has 'points' and 'color'

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.color,
    this.items = const [],
    this.completedItems = const [],
    DateTime? createdAt,
    this.reminderDate,
    this.category = 'General', // Default category
    this.drawingData = const [],
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type.index,
      'color': color.value,
      'items': items,
      'completedItems': completedItems,
      'createdAt': createdAt.toIso8601String(),
      'reminderDate': reminderDate?.toIso8601String(),
      'category': category,
      'drawingData': drawingData.map((stroke) {
        return {
          'points': (stroke['points'] as List<Offset>)
              .map((offset) => {'dx': offset.dx, 'dy': offset.dy})
              .toList(),
          'color': stroke['color'],
          'strokeWidth': stroke['strokeWidth'] ?? 3.0,
        };
      }).toList(),
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      type: NoteType.values[json['type']],
      color: Color(json['color']),
      items: List<String>.from(json['items'] ?? []),
      completedItems: List<bool>.from(json['completedItems'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      reminderDate: json['reminderDate'] != null
          ? DateTime.parse(json['reminderDate'])
          : null,
      category: json['category'] ?? 'General',
      drawingData:
          (json['drawingData'] as List<dynamic>?)?.map((stroke) {
            if (stroke is List) {
              // old format: List<Offset>
              return {
                'points': (stroke).map((point) => point as Offset).toList(),
                'color': null,
              };
            } else if (stroke is Map<String, dynamic>) {
              // new format
              return {
                'points': (stroke['points'] as List<dynamic>)
                    .map(
                      (point) => Offset(
                        (point['dx'] as num).toDouble(),
                        (point['dy'] as num).toDouble(),
                      ),
                    )
                    .toList(),
                'color': stroke['color'],
                'strokeWidth': stroke['strokeWidth'] ?? 3.0,
              };
            } else {
              return {'points': <Offset>[], 'color': null};
            }
          }).toList() ??
          [],
    );
  }
}
