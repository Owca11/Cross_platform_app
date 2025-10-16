import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/feeling.dart';
import '../data/sample_data.dart';

class EmotionService {
  static const String _feelingsKey = 'custom_feelings';
  static const String _needsKey = 'custom_needs';
  static const String _thoughtsKey = 'custom_thoughts';

  // Get all feelings, initializing with defaults if not present
  static Future<List<Feeling>> getFeelings() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> customFeelingsJson = prefs.getStringList(_feelingsKey) ?? [];

    // Initialize with sample feelings if not present
    if (customFeelingsJson.isEmpty) {
      for (Feeling feeling in sampleFeelings) {
        final data = {
          'name': feeling.name,
          'iconCodePoint': feeling.icon.codePoint,
          'iconFontFamily': feeling.icon.fontFamily,
          'prompt': feeling.prompt,
          'colorValue': feeling.color.value,
        };
        customFeelingsJson.add(jsonEncode(data));
      }
      await prefs.setStringList(_feelingsKey, customFeelingsJson);
    }

    // Load all feelings from prefs
    List<Feeling> feelings = customFeelingsJson.map((json) {
      final Map<String, dynamic> data = jsonDecode(json);
      return Feeling(
        name: data['name'],
        icon: IconData(
          data['iconCodePoint'],
          fontFamily: data['iconFontFamily'],
        ),
        prompt: data['prompt'],
        color: Color(data['colorValue']),
      );
    }).toList();

    return feelings;
  }

  // Get all needs, initializing with defaults if not present
  static Future<List<Need>> getNeeds() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> customNeedsJson = prefs.getStringList(_needsKey) ?? [];

    // Initialize with sample needs if not present
    if (customNeedsJson.isEmpty) {
      for (Need need in sampleNeeds) {
        final data = {
          'name': need.name,
          'iconCodePoint': need.icon.codePoint,
          'iconFontFamily': need.icon.fontFamily,
          'prompt': need.prompt,
          'colorValue': need.color.value,
        };
        customNeedsJson.add(jsonEncode(data));
      }
      await prefs.setStringList(_needsKey, customNeedsJson);
    }

    // Load all needs from prefs
    List<Need> needs = customNeedsJson.map((json) {
      final Map<String, dynamic> data = jsonDecode(json);
      return Need(
        name: data['name'],
        icon: IconData(
          data['iconCodePoint'],
          fontFamily: data['iconFontFamily'],
        ),
        prompt: data['prompt'],
        color: Color(data['colorValue']),
      );
    }).toList();

    return needs;
  }

  // Get all thoughts, initializing with defaults if not present
  static Future<List<Thought>> getThoughts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> customThoughtsJson = prefs.getStringList(_thoughtsKey) ?? [];

    // Initialize with sample thoughts if not present
    if (customThoughtsJson.isEmpty) {
      for (Thought thought in sampleThoughts) {
        final data = {
          'name': thought.name,
          'iconCodePoint': thought.icon.codePoint,
          'iconFontFamily': thought.icon.fontFamily,
          'prompt': thought.prompt,
          'colorValue': thought.color.value,
        };
        customThoughtsJson.add(jsonEncode(data));
      }
      await prefs.setStringList(_thoughtsKey, customThoughtsJson);
    }

    // Load all thoughts from prefs
    List<Thought> thoughts = customThoughtsJson.map((json) {
      final Map<String, dynamic> data = jsonDecode(json);
      return Thought(
        name: data['name'],
        icon: IconData(
          data['iconCodePoint'],
          fontFamily: data['iconFontFamily'],
        ),
        prompt: data['prompt'],
        color: Color(data['colorValue']),
      );
    }).toList();

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
      'colorValue': feeling.color.value,
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
      'colorValue': need.color.value,
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
      'colorValue': thought.color.value,
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

  // Update a feeling (name, prompt, icon, color)
  static Future<void> updateFeeling(
    String oldName,
    String newName,
    String newPrompt,
    IconData newIcon,
    Color newColor,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final customFeelings = prefs.getStringList(_feelingsKey) ?? [];

    for (int i = 0; i < customFeelings.length; i++) {
      final Map<String, dynamic> data = jsonDecode(customFeelings[i]);
      if (data['name'] == oldName) {
        data['name'] = newName;
        data['prompt'] = newPrompt;
        data['iconCodePoint'] = newIcon.codePoint;
        data['iconFontFamily'] = newIcon.fontFamily;
        data['colorValue'] = newColor.value;
        customFeelings[i] = jsonEncode(data);
        break;
      }
    }

    await prefs.setStringList(_feelingsKey, customFeelings);
  }

  // Update a need (name, prompt, icon, color)
  static Future<void> updateNeed(
    String oldName,
    String newName,
    String newPrompt,
    IconData newIcon,
    Color newColor,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final customNeeds = prefs.getStringList(_needsKey) ?? [];

    for (int i = 0; i < customNeeds.length; i++) {
      final Map<String, dynamic> data = jsonDecode(customNeeds[i]);
      if (data['name'] == oldName) {
        data['name'] = newName;
        data['prompt'] = newPrompt;
        data['iconCodePoint'] = newIcon.codePoint;
        data['iconFontFamily'] = newIcon.fontFamily;
        data['colorValue'] = newColor.value;
        customNeeds[i] = jsonEncode(data);
        break;
      }
    }

    await prefs.setStringList(_needsKey, customNeeds);
  }

  // Update a thought (name, prompt, icon, color)
  static Future<void> updateThought(
    String oldName,
    String newName,
    String newPrompt,
    IconData newIcon,
    Color newColor,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final customThoughts = prefs.getStringList(_thoughtsKey) ?? [];

    for (int i = 0; i < customThoughts.length; i++) {
      final Map<String, dynamic> data = jsonDecode(customThoughts[i]);
      if (data['name'] == oldName) {
        data['name'] = newName;
        data['prompt'] = newPrompt;
        data['iconCodePoint'] = newIcon.codePoint;
        data['iconFontFamily'] = newIcon.fontFamily;
        data['colorValue'] = newColor.value;
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
