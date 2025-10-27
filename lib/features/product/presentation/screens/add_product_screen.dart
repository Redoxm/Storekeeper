import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_provider.dart';
import '../providers/image_provider.dart';
import '../providers/image_state.dart';
import '../providers/product_state.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                ref.read(imageNotifierProvider.notifier).pickFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                ref.read(imageNotifierProvider.notifier).pickFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final imageState = ref.read(imageNotifierProvider);
    String? imagePath;

    if (imageState is ImageSelected) {
      imagePath = imageState.imagePath;
    }

    await ref
        .read(productNotifierProvider.notifier)
        .addNewProduct(
          name: _nameController.text.trim(),
          quantity: int.parse(_quantityController.text.trim()),
          price: double.parse(_priceController.text.trim()),
          imagePath: imagePath,
        );

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageState = ref.watch(imageNotifierProvider);
    ref.watch(productNotifierProvider);

    // Listen to product state changes
    ref.listen<ProductState>(productNotifierProvider, (previous, next) {
      if (next is ProductOperationSuccess) {
        // Clear image state
        ref.read(imageNotifierProvider.notifier).clearImage();
        // Navigate back
        Navigator.pop(context);
      } else if (next is ProductError) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.red),
        );
      }
    });

    // Listen to image state changes
    ref.listen<ImageState>(imageNotifierProvider, (previous, next) {
      if (next is ImageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image section
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: _buildImageSection(imageState),
              ),
              const SizedBox(height: 24),

              // Product name
              FadeInLeft(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 100),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    hintText: 'Enter product name',
                    prefixIcon: const Icon(Icons.shopping_bag),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter product name';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Quantity - Add FadeInRight animation
              FadeInRight(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 200),
                child: TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    hintText: 'Enter quantity',
                    prefixIcon: const Icon(Icons.inventory),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter quantity';
                    }
                    final quantity = int.tryParse(value.trim());
                    if (quantity == null || quantity < 0) {
                      return 'Please enter a valid quantity';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Price - Add FadeInLeft animation
              FadeInLeft(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 300),
                child: TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    hintText: 'Enter price',
                    prefixIcon: const Icon(Icons.payment),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter price';
                    }
                    final price = double.tryParse(value.trim());
                    if (price == null || price < 0) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Submit button - Add FadeInUp animation
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 400),
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Add Product',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(ImageState imageState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Image (Optional)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: imageState is ImageLoading ? null : _showImageSourceDialog,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: imageState is ImageInitial
                    ? Colors
                          .blue
                          .shade200 // Blue border when no image
                    : Colors.grey.shade300, // Grey border when image selected
                width: 2,
              ),
            ),
            child: _buildImageContent(imageState),
          ),
        ),
        if (imageState is ImageSelected) ...[
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: () {
                ref.read(imageNotifierProvider.notifier).clearImage();
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text(
                'Remove Image',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

Widget _buildImageContent(ImageState imageState) {
  if (imageState is ImageLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  if (imageState is ImageSelected) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(File(imageState.imagePath), fit: BoxFit.cover),
    );
  }

  // Initial state
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.add_photo_alternate, size: 64, color: Colors.grey.shade400),
      const SizedBox(height: 8),
      Text(
        'Tap to add image',
        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
      ),
    ],
  );
}
