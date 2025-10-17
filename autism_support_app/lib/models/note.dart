import 'package:flutter/material.dart';

enum NoteType { text, shopping, reminder, drawing }

class Note {
  String id;
  String title;
  String content;
  NoteType type;
  Color color;
  List<String> items; // For shopping lists
  DateTime createdAt;
  DateTime? reminderDate; // For reminders
  String category; // New: category for organization
  List<List<Offset>> drawingData; // New: for drawing notes

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.color,
    this.items = const [],
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
      'createdAt': createdAt.toIso8601String(),
      'reminderDate': reminderDate?.toIso8601String(),
      'category': category,
      'drawingData': drawingData
          .map(
            (stroke) => stroke
                .map((offset) => {'dx': offset.dx, 'dy': offset.dy})
                .toList(),
          )
          .toList(),
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
      createdAt: DateTime.parse(json['createdAt']),
      reminderDate: json['reminderDate'] != null
          ? DateTime.parse(json['reminderDate'])
          : null,
      category: json['category'] ?? 'General',
      drawingData:
          (json['drawingData'] as List<dynamic>?)
              ?.map(
                (stroke) => (stroke as List<dynamic>)
                    .map((point) => Offset(point['dx'], point['dy']))
                    .toList(),
              )
              .toList() ??
          [],
    );
  }
}
