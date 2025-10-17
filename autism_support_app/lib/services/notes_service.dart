import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NotesService {
  static const String _notesKey = 'notes';

  Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_notesKey) ?? [];
    return notesJson.map((json) => Note.fromJson(jsonDecode(json))).toList();
  }

  Future<void> saveNote(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getNotes();
    final existingIndex = notes.indexWhere((n) => n.id == note.id);
    if (existingIndex >= 0) {
      notes[existingIndex] = note;
    } else {
      notes.add(note);
    }
    final notesJson = notes.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList(_notesKey, notesJson);
  }

  Future<void> deleteNote(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getNotes();
    notes.removeWhere((n) => n.id == id);
    final notesJson = notes.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList(_notesKey, notesJson);
  }

  Future<Note?> getNoteById(String id) async {
    final notes = await getNotes();
    return notes.firstWhere((n) => n.id == id);
  }
}
