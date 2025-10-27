import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/services/image_service.dart';
import '../../../../core/errors/exceptions.dart';
import 'image_state.dart';

/// Provider for ImageService
final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService();
});

/// StateNotifier for managing image state
class ImageNotifier extends StateNotifier<ImageState> {
  final ImageService imageService;

  ImageNotifier({required this.imageService}) : super(const ImageInitial());

  /// Pick image from camera
  Future<void> pickFromCamera() async {
    state = const ImageLoading();

    try {
      final imagePath = await imageService.pickImageFromCamera();

      if (imagePath == null) {
        // User cancelled
        state = const ImageInitial();
        return;
      }

      state = ImageSelected(imagePath);
    } on CacheException catch (e) {
      state = ImageError(e.message);
    } catch (e) {
      state = ImageError('Failed to capture image: ${e.toString()}');
    }
  }

  /// Pick image from gallery
  Future<void> pickFromGallery() async {
    state = const ImageLoading();

    try {
      final imagePath = await imageService.pickImageFromGallery();

      if (imagePath == null) {
        // User cancelled
        state = const ImageInitial();
        return;
      }

      state = ImageSelected(imagePath);
    } on CacheException catch (e) {
      state = ImageError(e.message);
    } catch (e) {
      state = ImageError('Failed to pick image: ${e.toString()}');
    }
  }

  /// Clear selected image
  void clearImage() {
    state = const ImageInitial();
  }

  /// Set existing image (for edit mode)
  void setImage(String imagePath) {
    state = ImageSelected(imagePath);
  }

  /// Delete image file
  Future<void> deleteImageFile(String imagePath) async {
    try {
      await imageService.deleteImage(imagePath);
    } catch (e) {
      // Silently fail - don't block UI
      // In production, you might want to log this
    }
  }
}

/// Provider for ImageNotifier
final imageNotifierProvider = StateNotifierProvider<ImageNotifier, ImageState>((
  ref,
) {
  return ImageNotifier(imageService: ref.watch(imageServiceProvider));
});
