import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../utils/mock_data.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  ProductCategory _selectedCategory = ProductCategory.burger;
  String _searchQuery = '';

  List<Product> get products => _products;
  ProductCategory get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<Product> get filteredProducts {
    var filtered =
        _products
            .where((product) => product.category == _selectedCategory.key)
            .toList();

    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (product) =>
                    product.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    product.description.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();
    }

    return filtered;
  }

  ProductProvider() {
    _loadProducts();
  }

  void _loadProducts() {
    _products = MockData.products;
    notifyListeners();
  }

  void setSelectedCategory(ProductCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  int getProductCountForCategory(ProductCategory category) {
    return _products
        .where((product) => product.category == category.key)
        .length;
  }
}
