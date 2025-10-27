import 'package:equatable/equatable.dart';

/// Represents the state of image operations
abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no image selected
class ImageInitial extends ImageState {
  const ImageInitial();
}

/// Loading state - picking/processing image
class ImageLoading extends ImageState {
  const ImageLoading();
}

/// Success state - image selected
class ImageSelected extends ImageState {
  final String imagePath;

  const ImageSelected(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

/// Error state - image operation failed
class ImageError extends ImageState {
  final String message;

  const ImageError(this.message);

  @override
  List<Object> get props => [message];
}
