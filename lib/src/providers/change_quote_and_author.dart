import 'package:flutter/material.dart';

class ChangeQuoteAndAuthor with ChangeNotifier {
  String _quoteAuthor;
  String _quoteContent;

  get quoteAuthor {
    return _quoteAuthor;
  }

  get quoteContent {
    return _quoteContent;
  }

  set setQuoteAuthor(String author) {
    this._quoteAuthor = author;

    notifyListeners();
  }

  set setQuoteContent(String content) {
    this._quoteContent = content;

    notifyListeners();
  }
}
