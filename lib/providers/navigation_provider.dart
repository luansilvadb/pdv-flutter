import 'package:flutter/foundation.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 1; // Start with Menu selected
  bool _isCollapsed = false;

  int get selectedIndex => _selectedIndex;
  bool get isCollapsed => _isCollapsed;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void toggleCollapsed() {
    _isCollapsed = !_isCollapsed;
    notifyListeners();
  }

  void setCollapsed(bool collapsed) {
    _isCollapsed = collapsed;
    notifyListeners();
  }
}
