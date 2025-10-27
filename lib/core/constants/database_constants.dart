/// Database configuration constants
class DatabaseConstants {
  static const String databaseName = 'storekeeper.db';
  static const int databaseVersion = 1;

  // Table names
  static const String productsTable = 'products';

  // Column names for products table
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnQuantity = 'quantity';
  static const String columnPrice = 'price';
  static const String columnImagePath = 'image_path';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';
}
