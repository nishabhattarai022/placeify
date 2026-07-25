import 'package:flutter/material.dart';

/// Copy and layout metadata for category showcase screens.
abstract final class CategoryShowcaseConfig {
  static String title(String categoryId) {
    return switch (categoryId) {
      'chairs' => 'CHAIRS',
      'sofas' => 'SOFAS',
      'desks' => 'DESKS',
      'beds' => 'BEDS',
      'tables' => 'TABLES',
      'storage' => 'STORAGE',
      'lighting' => 'LIGHTING',
      'outdoor' => 'OUTDOOR',
      'lights' => 'LIGHTS',
      'decor' => 'DECOR',
      _ => categoryId.toUpperCase(),
    };
  }

  static String subtitle(String categoryId) {
    return switch (categoryId) {
      'chairs' =>
          'Repurposed Materials, Unique Style,\nSustainable Comfort.',
      _ =>
          'Curated pieces for modern living.\nThoughtful design, lasting quality.',
    };
  }
}
