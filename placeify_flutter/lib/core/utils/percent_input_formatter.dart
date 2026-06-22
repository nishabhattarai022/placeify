import 'package:flutter/services.dart';

/// Keeps percentage input within [min, max] while the user types.
class PercentInputFormatter extends TextInputFormatter {
  const PercentInputFormatter({
    this.min = 0,
    this.max = 100,
    this.decimals = 2,
  });

  final double min;
  final double max;
  final int decimals;

  static final RegExp _pattern = RegExp(r'^\d*\.?\d*$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    if (!_pattern.hasMatch(text)) return oldValue;

    final dotIndex = text.indexOf('.');
    if (dotIndex != -1) {
      if (text.indexOf('.', dotIndex + 1) != -1) return oldValue;
      final fraction = text.substring(dotIndex + 1);
      if (fraction.length > decimals) return oldValue;
    }

    if (text.endsWith('.')) {
      final whole = text.substring(0, text.length - 1);
      if (whole.isEmpty) return newValue;
      final parsedWhole = double.tryParse(whole);
      if (parsedWhole == null || parsedWhole < min || parsedWhole > max) {
        return oldValue;
      }
      return newValue;
    }

    final parsed = double.tryParse(text);
    if (parsed == null) return oldValue;
    if (parsed < min || parsed > max) return oldValue;

    return newValue;
  }
}
