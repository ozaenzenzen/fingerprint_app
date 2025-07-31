import 'package:flutter/services.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

enum CaseFormat { pascalCase, camelCase }

class CaseTextFormatter extends TextInputFormatter {
  final CaseFormat format;

  CaseTextFormatter({this.format = CaseFormat.pascalCase});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Get the input text
    String input = newValue.text;

    // Split into words based on spaces, underscores, or camelCase boundaries
    List<String> words = _splitIntoWords(input);

    // Transform words based on the specified format
    List<String> transformedWords = words.map((word) {
      if (word.isEmpty) return word;
      // Capitalize the first letter
      String firstLetter = word[0].toUpperCase();
      // Handle the rest of the word based on format
      String rest = word.length > 1 ? word.substring(1) : '';
      if (format == CaseFormat.camelCase) {
        // Make the rest lowercase for camelCase
        rest = rest.toLowerCase();
      }
      return '$firstLetter$rest';
    }).toList();

    // Join words without spaces or delimiters
    String transformedText = transformedWords.join('');

    // Calculate the new cursor position
    int newSelectionOffset = transformedText.length;
    if (newValue.selection.isValid) {
      // Adjust cursor position based on the transformation
      int originalOffset = newValue.selection.end;
      String beforeCursor = newValue.text.substring(0, originalOffset);
      List<String> wordsBeforeCursor = _splitIntoWords(beforeCursor);
      String transformedBeforeCursor =
          wordsBeforeCursor.map((word) => word.isEmpty ? word : '${word[0].toUpperCase()}${format == CaseFormat.camelCase ? word.substring(1).toLowerCase() : word.substring(1)}').join('');
      newSelectionOffset = transformedBeforeCursor.length;
    }

    return TextEditingValue(
      text: transformedText,
      selection: TextSelection.collapsed(offset: newSelectionOffset),
    );
  }

  // Splits text into words based on spaces, underscores, or camelCase boundaries
  List<String> _splitIntoWords(String text) {
    if (text.isEmpty) return [];
    // Split by spaces or underscores, then further split camelCase
    List<String> words = text.split(RegExp(r'\s+|_+')).expand((word) => _splitCamelCase(word)).where((word) => word.isNotEmpty).toList();
    return words;
  }

  // Splits a camelCase string into individual words (e.g., "thisString" -> ["this", "String"])
  List<String> _splitCamelCase(String text) {
    List<String> words = [];
    String currentWord = '';
    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (i > 0 && char.toUpperCase() == char && RegExp(r'[A-Za-z]').hasMatch(char)) {
        if (currentWord.isNotEmpty) {
          words.add(currentWord);
          currentWord = char;
        } else {
          currentWord += char;
        }
      } else {
        currentWord += char;
      }
    }
    if (currentWord.isNotEmpty) {
      words.add(currentWord);
    }
    return words;
  }
}
