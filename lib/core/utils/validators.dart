/// Input validation utilities
class Validators {
  /// Validates product name
  static String? validateProductName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Product name is required';
    }
    if (value.trim().length < 2) {
      return 'Product name must be at least 2 characters';
    }
    if (value.trim().length > 100) {
      return 'Product name must not exceed 100 characters';
    }
    return null;
  }

  /// Validates quantity
  static String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required';
    }

    final quantity = int.tryParse(value.trim());
    if (quantity == null) {
      return 'Quantity must be a valid number';
    }

    if (quantity < 0) {
      return 'Quantity cannot be negative';
    }

    if (quantity > 1000000) {
      return 'Quantity is too large';
    }

    return null;
  }

  /// Validates price
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }

    final price = double.tryParse(value.trim());
    if (price == null) {
      return 'Price must be a valid number';
    }

    if (price < 0) {
      return 'Price cannot be negative';
    }

    if (price > 10000000) {
      return 'Price is too large';
    }

    return null;
  }
}
