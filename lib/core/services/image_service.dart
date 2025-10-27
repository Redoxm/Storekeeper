import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../errors/exceptions.dart';

/// Service for handling image operations
/// Manages camera/gallery access and image storage
class ImageService {
  final ImagePicker _picker = ImagePicker();

  /// Check and request camera permission
  Future<bool> _checkCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.camera.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      // User has permanently denied permission
      // We need to guide them to app settings
      return false;
    }

    return false;
  }

  /// Check and request storage permission (for gallery)
  Future<bool> _checkStoragePermission() async {
    // For Android 13+ (API 33+), we don't need storage permission for gallery
    if (Platform.isAndroid) {
      final androidInfo = await _getAndroidVersion();
      if (androidInfo >= 33) {
        return true; // No permission needed for Android 13+
      }
    }

    final status = await Permission.storage.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.storage.request();
      return result.isGranted;
    }

    return false;
  }

  /// Get Android SDK version
  Future<int> _getAndroidVersion() async {
    if (!Platform.isAndroid) return 0;

    try {
      // This is a simplified check
      // In production, you might use device_info_plus package
      return 33; // Assume modern Android for now
    } catch (e) {
      return 0;
    }
  }

  /// Pick image from camera
  Future<String?> pickImageFromCamera() async {
    try {
      // Check camera permission
      final hasPermission = await _checkCameraPermission();
      if (!hasPermission) {
        throw CacheException(
          'Camera permission denied. Please enable it in settings.',
        );
      }

      // Pick image from camera
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) {
        return null; // User cancelled
      }

      // Save image to app directory
      final savedPath = await _saveImage(image);
      return savedPath;
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Failed to capture image: ${e.toString()}');
    }
  }

  /// Pick image from gallery
  Future<String?> pickImageFromGallery() async {
    try {
      // Check storage permission
      final hasPermission = await _checkStoragePermission();
      if (!hasPermission) {
        throw CacheException(
          'Storage permission denied. Please enable it in settings.',
        );
      }

      // Pick image from gallery
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) {
        return null; // User cancelled
      }

      // Save image to app directory
      final savedPath = await _saveImage(image);
      return savedPath;
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Failed to pick image: ${e.toString()}');
    }
  }

  /// Save image to app's document directory
  Future<String> _saveImage(XFile image) async {
    try {
      // Get app's document directory
      final directory = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${directory.path}/product_images');

      // Create directory if it doesn't exist
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(image.path);
      final fileName = 'product_$timestamp$extension';
      final savedPath = '${imagesDir.path}/$fileName';

      // Copy image to app directory
      final File imageFile = File(image.path);
      await imageFile.copy(savedPath);

      return savedPath;
    } catch (e) {
      throw CacheException('Failed to save image: ${e.toString()}');
    }
  }

  /// Delete image file
  Future<bool> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      throw CacheException('Failed to delete image: ${e.toString()}');
    }
  }

  /// Check if image file exists
  Future<bool> imageExists(String imagePath) async {
    try {
      final file = File(imagePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Get image file
  File? getImageFile(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }
    return File(imagePath);
  }

  /// Open app settings (for permission management)
  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
