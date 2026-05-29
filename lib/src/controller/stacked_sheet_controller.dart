import 'package:flutter/foundation.dart';
import 'package:stacked_sheets/src/model/stacked_sheet_model.dart';

/// A controller that manages the state of the stacked bottom sheets.
///
/// Use this controller to [push], [pop], or [clear] sheets from the stack.
/// It extends [ChangeNotifier], so it can be listened to for updates.
class StackedSheetController extends ChangeNotifier {
  final List<StackedSheet> _sheets = [];

  /// An unmodifiable list of current [StackedSheet]s in the stack.
  List<StackedSheet> get sheets => List.unmodifiable(_sheets);

  /// Returns `true` if there are any sheets currently in the stack.
  bool get hasSheets => _sheets.isNotEmpty;

  /// Adds a new [sheet] to the top of the stack.
  ///
  /// This will trigger a notification to listeners and cause the UI to update.
  void push(StackedSheet sheet) {
    _sheets.add(sheet);
    notifyListeners();
  }

  /// Removes the topmost sheet from the stack.
  ///
  /// If the stack is empty, this does nothing.
  void pop() {
    if (_sheets.isNotEmpty) {
      _sheets.removeLast();
      notifyListeners();
    }
  }

  /// Removes all sheets from the stack.
  void clear() {
    if (_sheets.isNotEmpty) {
      _sheets.clear();
      notifyListeners();
    }
  }
}
