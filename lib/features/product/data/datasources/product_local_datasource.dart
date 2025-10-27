import 'package:sqflite/sqflite.dart' hide DatabaseException;
import 'package:path/path.dart';
import '../../../../core/constants/database_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/product_model.dart';

/// Abstract class defining local data operations
abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(String id);
  Future<ProductModel> addProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<bool> deleteProduct(String id);
  Future<List<ProductModel>> searchProducts(String query);
}

/// Implementation of ProductLocalDataSource using SQLite
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  Database? _database;

  /// Get database instance (singleton pattern)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    try {
      // Get database path
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, DatabaseConstants.databaseName);

      // Open database
      return await openDatabase(
        path,
        version: DatabaseConstants.databaseVersion,
        onCreate: _createDatabase,
        onUpgrade: _upgradeDatabase,
      );
    } catch (e) {
      throw DatabaseException('Failed to initialize database: ${e.toString()}');
    }
  }

  /// Create database tables
  Future<void> _createDatabase(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE ${DatabaseConstants.productsTable} (
          ${DatabaseConstants.columnId} TEXT PRIMARY KEY,
          ${DatabaseConstants.columnName} TEXT NOT NULL,
          ${DatabaseConstants.columnQuantity} INTEGER NOT NULL,
          ${DatabaseConstants.columnPrice} REAL NOT NULL,
          ${DatabaseConstants.columnImagePath} TEXT,
          ${DatabaseConstants.columnCreatedAt} TEXT NOT NULL,
          ${DatabaseConstants.columnUpdatedAt} TEXT NOT NULL
        )
      ''');
    } catch (e) {
      throw DatabaseException(
        'Failed to create database tables: ${e.toString()}',
      );
    }
  }

  /// Handle database upgrades (for future versions)
  Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Handle database migrations here when we update the schema
    // For now, we don't have any migrations
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseConstants.productsTable,
        orderBy: '${DatabaseConstants.columnUpdatedAt} DESC',
      );

      return maps.map((map) => ProductModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get all products: ${e.toString()}');
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseConstants.productsTable,
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) {
        throw DatabaseException('Product with ID $id not found');
      }

      return ProductModel.fromMap(maps.first);
    } catch (e) {
      throw DatabaseException('Failed to get product by ID: ${e.toString()}');
    }
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    try {
      final db = await database;

      // Check if product with same ID already exists
      final existing = await db.query(
        DatabaseConstants.productsTable,
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [product.id],
      );

      if (existing.isNotEmpty) {
        throw DatabaseException('Product with ID ${product.id} already exists');
      }

      // Insert product
      await db.insert(
        DatabaseConstants.productsTable,
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );

      return product;
    } catch (e) {
      throw DatabaseException('Failed to add product: ${e.toString()}');
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      final db = await database;

      // Check if product exists
      final existing = await db.query(
        DatabaseConstants.productsTable,
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [product.id],
      );

      if (existing.isEmpty) {
        throw DatabaseException('Product with ID ${product.id} not found');
      }

      // Update product
      await db.update(
        DatabaseConstants.productsTable,
        product.toMap(),
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [product.id],
      );

      return product;
    } catch (e) {
      throw DatabaseException('Failed to update product: ${e.toString()}');
    }
  }

  @override
  Future<bool> deleteProduct(String id) async {
    try {
      final db = await database;

      final count = await db.delete(
        DatabaseConstants.productsTable,
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [id],
      );

      if (count == 0) {
        throw DatabaseException('Product with ID $id not found');
      }

      return true;
    } catch (e) {
      throw DatabaseException('Failed to delete product: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseConstants.productsTable,
        where: '${DatabaseConstants.columnName} LIKE ?',
        whereArgs: ['%$query%'],
        orderBy: '${DatabaseConstants.columnName} ASC',
      );

      return maps.map((map) => ProductModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to search products: ${e.toString()}');
    }
  }

  /// Close database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
