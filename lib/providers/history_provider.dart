import 'package:flutter/foundation.dart';
import '../models/history_item.dart';
import '../models/method_result.dart';

/// Gestiona el historial en memoria de cálculos realizados.
/// Máximo 50 entradas — se elimina la más antigua al superar el límite.
class HistoryProvider extends ChangeNotifier {
  final List<HistoryItem> _items = [];

  List<HistoryItem> get items => List.unmodifiable(_items.reversed.toList());
  int get count => _items.length;
  bool get isEmpty => _items.isEmpty;

  void addResult(MethodResult result) {
    if (_items.length >= 50) _items.removeAt(0);
    _items.add(HistoryItem(result: result, timestamp: DateTime.now()));
    notifyListeners();
  }

  void remove(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
