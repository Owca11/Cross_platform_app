import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/feeling.dart';
import '../data/sample_data.dart';

class EmotionService {
  static const String _feelingsKey = 'custom_feelings';
  static const String _needsKey = 'custom_needs';
  static const String _thoughtsKey = 'custom_thoughts';

  // Get all feelings, merging custom with defaults
  static Future<List<Feeling>> getFeelings() async {
    final prefs = await SharedPreferences.getInstance();
    final customFeelingsJson = prefs.getStringList(_feelingsKey) ?? [];

    // Start with default feelings
    List<Feeling> feelings = List.from(sampleFeelings);

    // Add or override with custom feelings
    for (String json in customFeelingsJson) {
      final Map<String, dynamic> data = jsonDecode(json);
      final feeling = Feeling(
        name: data['name'],
        icon: IconData(
          data['iconCodePoint'],
          fontFamily: data['iconFontFamily'],
        ),
        prompt: data['prompt'],
      );
      // Replace if exists, else add
      final existingIndex = feelings.indexWhere((f) => f.name == feeling.name);
      if (existingIndex != -1) {
        feelings[existingIndex] = feeling;
      } else {
        feelings.add(feeling);
      }
    }

    return feelings;
  }

  // Get all needs, merging custom with defaults
  static Future<List<Need>> getNeeds() async {
    final prefs = await SharedPreferences.getInstance();
    final customNeedsJson = prefs.getStringList(_needsKey) ?? [];

    List<Need> needs = List.from(sampleNeeds);

    for (String json in customNeedsJson) {
      final Map<String, dynamic> data = jsonDecode(json);
      final need = Need(
        name: data['name'],
        icon: IconData(
          data['iconCodePoint'],
          fontFamily: data['iconFontFamily'],
        ),
        prompt: data['prompt'],
      );
      final existingIndex = needs.indexWhere((n) => n.name == need.name);
      if (existingIndex != -1) {
        needs[existingIndex] = need;
      } else {
        needs.add(need);
      }
    }

    return needs;
  }

  // Get all thoughts, merging custom with defaults
  static Future<List<Thought>> getThoughts() async {
    final prefs = await SharedPreferences.getInstance();
    final customThoughtsJson = prefs.getStringList(_thoughtsKey) ?? [];

    List<Thought> thoughts = List.from(sampleThoughts);

    for (String json in customThoughtsJson) {
      final Map<String, dynamic> data = jsonDecode(json);
      final thought = Thought(
        name: data['name'],
        icon: IconData(
          data['iconCodePoint'],
          fontFamily: data['iconFontFamily'],
        ),
        prompt: data['prompt'],
      );
      final existingIndex = thoughts.indexWhere((t) => t.name == thought.name);
      if (existingIndex != -1) {
        thoughts[existingIndex] = thought;
      } else {
        thoughts.add(thought);
      }
    }

    return thoughts;
  }

  // Save a custom feeling
  static Future<void> saveFeeling(Feeling feeling) async {
    final prefs = await SharedPreferences.getInstance();
    final customFeelings = prefs.getStringList(_feelingsKey) ?? [];

    final data = {
      'name': feeling.name,
      'iconCodePoint': feeling.icon.codePoint,
      'iconFontFamily': feeling.icon.fontFamily,
      'prompt': feeling.prompt,
    };

    // Remove existing if present
    customFeelings.removeWhere((json) {
      final Map<String, dynamic> existing = jsonDecode(json);
      return existing['name'] == feeling.name;
    });

    customFeelings.add(jsonEncode(data));
    await prefs.setStringList(_feelingsKey, customFeelings);
  }

  // Save a custom need
  static Future<void> saveNeed(Need need) async {
    final prefs = await SharedPreferences.getInstance();
    final customNeeds = prefs.getStringList(_needsKey) ?? [];

    final data = {
      'name': need.name,
      'iconCodePoint': need.icon.codePoint,
      'iconFontFamily': need.icon.fontFamily,
      'prompt': need.prompt,
    };

    customNeeds.removeWhere((json) {
      final Map<String, dynamic> existing = jsonDecode(json);
      return existing['name'] == need.name;
    });

    customNeeds.add(jsonEncode(data));
    await prefs.setStringList(_needsKey, customNeeds);
  }

  // Save a custom thought
  static Future<void> saveThought(Thought thought) async {
    final prefs = await SharedPreferences.getInstance();
    final customThoughts = prefs.getStringList(_thoughtsKey) ?? [];

    final data = {
      'name': thought.name,
      'iconCodePoint': thought.icon.codePoint,
      'iconFontFamily': thought.icon.fontFamily,
      'prompt': thought.prompt,
    };

    customThoughts.removeWhere((json) {
      final Map<String, dynamic> existing = jsonDecode(json);
      return existing['name'] == thought.name;
    });

    customThoughts.add(jsonEncode(data));
    await prefs.setStringList(_thoughtsKey, customThoughts);
  }

  // Delete a custom feeling (only if it's custom, not default)
  static Future<void> deleteFeeling(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final customFeelings = prefs.getStringList(_feelingsKey) ?? [];

    customFeelings.removeWhere((json) {
      final Map<String, dynamic> existing = jsonDecode(json);
      return existing['name'] == name;
    });

    await prefs.setStringList(_feelingsKey, customFeelings);
  }

  // Delete a custom need
  static Future<void> deleteNeed(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final customNeeds = prefs.getStringList(_needsKey) ?? [];

    customNeeds.removeWhere((json) {
      final Map<String, dynamic> existing = jsonDecode(json);
      return existing['name'] == name;
    });

    await prefs.setStringList(_needsKey, customNeeds);
  }

  // Delete a custom thought
  static Future<void> deleteThought(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final customThoughts = prefs.getStringList(_thoughtsKey) ?? [];

    customThoughts.removeWhere((json) {
      final Map<String, dynamic> existing = jsonDecode(json);
      return existing['name'] == name;
    });

    await prefs.setStringList(_thoughtsKey, customThoughts);
  }

  // Update a feeling (name and prompt)
  static Future<void> updateFeeling(
    String oldName,
    String newName,
    String newPrompt,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final customFeelings = prefs.getStringList(_feelingsKey) ?? [];

    for (int i = 0; i < customFeelings.length; i++) {
      final Map<String, dynamic> data = jsonDecode(customFeelings[i]);
      if (data['name'] == oldName) {
        data['name'] = newName;
        data['prompt'] = newPrompt;
        customFeelings[i] = jsonEncode(data);
        break;
      }
    }

    await prefs.setStringList(_feelingsKey, customFeelings);
  }

  // Update a need (name and prompt)
  static Future<void> updateNeed(
    String oldName,
    String newName,
    String newPrompt,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final customNeeds = prefs.getStringList(_needsKey) ?? [];

    for (int i = 0; i < customNeeds.length; i++) {
      final Map<String, dynamic> data = jsonDecode(customNeeds[i]);
      if (data['name'] == oldName) {
        data['name'] = newName;
        data['prompt'] = newPrompt;
        customNeeds[i] = jsonEncode(data);
        break;
      }
    }

    await prefs.setStringList(_needsKey, customNeeds);
  }

  // Update a thought (name and prompt)
  static Future<void> updateThought(
    String oldName,
    String newName,
    String newPrompt,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final customThoughts = prefs.getStringList(_thoughtsKey) ?? [];

    for (int i = 0; i < customThoughts.length; i++) {
      final Map<String, dynamic> data = jsonDecode(customThoughts[i]);
      if (data['name'] == oldName) {
        data['name'] = newName;
        data['prompt'] = newPrompt;
        customThoughts[i] = jsonEncode(data);
        break;
      }
    }

    await prefs.setStringList(_thoughtsKey, customThoughts);
  }

  // Check if a feeling is custom
  static Future<bool> isCustomFeeling(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final customFeelings = prefs.getStringList(_feelingsKey) ?? [];
    return customFeelings.any((json) {
      final Map<String, dynamic> data = jsonDecode(json);
      return data['name'] == name;
    });
  }

  // Check if a need is custom
  static Future<bool> isCustomNeed(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final customNeeds = prefs.getStringList(_needsKey) ?? [];
    return customNeeds.any((json) {
      final Map<String, dynamic> data = jsonDecode(json);
      return data['name'] == name;
    });
  }

  // Check if a thought is custom
  static Future<bool> isCustomThought(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final customThoughts = prefs.getStringList(_thoughtsKey) ?? [];
    return customThoughts.any((json) {
      final Map<String, dynamic> data = jsonDecode(json);
      return data['name'] == name;
    });
  }
}
