import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/notifiers/upload_image_controller.dart';

class VisitClubWidget extends ConsumerStatefulWidget {
  const VisitClubWidget({super.key});

  @override
  ConsumerState<VisitClubWidget> createState() => _VisitClubWidgetState();
}

class _VisitClubWidgetState extends ConsumerState<VisitClubWidget> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _scrollController = ScrollController();
  final _descFocusNode = FocusNode();
  bool _isLoading = false;

  // Image selection variables
  bool _hasSelectedImage = false;
  String? _selectedImagePath;
  Uint8List? _selectedImageBytes;
  PlatformFile? _selectedPlatformFile;

  @override
  void initState() {
    super.initState();
    // Listen to focus changes to scroll appropriately
    _descFocusNode.addListener(() {
      if (_descFocusNode.hasFocus) {
        // Delay to ensure keyboard is visible and then scroll to show the text field
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && _scrollController.hasClients) {
            _scrollController.animateTo(
              50, // Small scroll to ensure text field is visible above keyboard
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _descController.dispose();
    _scrollController.dispose();
    _descFocusNode.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    if (_isLoading) return;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        allowCompression: true,
        withData: kIsWeb, // Only load bytes on web
      );

      if (result != null && result.files.isNotEmpty) {
        final pickedFile = result.files.first;

        // Validate file size (5MB limit)
        if (pickedFile.size > 5 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Image size must be less than 5MB'),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        }

        setState(() {
          _hasSelectedImage = true;
          _selectedImagePath = pickedFile.path;
          _selectedPlatformFile = pickedFile;
        });

        // For web platform, get bytes for preview
        if (kIsWeb && pickedFile.bytes != null) {
          _selectedImageBytes = pickedFile.bytes;
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to select image: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _removeSelectedImage() {
    setState(() {
      _hasSelectedImage = false;
      _selectedImagePath = null;
      _selectedImageBytes = null;
      _selectedPlatformFile = null;
    });
  }

  Widget _buildImagePreview() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildPreviewImage(),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: _isLoading ? null : _removeSelectedImage,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
          // Add a subtle overlay to indicate it's interactive
          if (!_isLoading)
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Tap X to remove',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPreviewImage() {
    if (kIsWeb && _selectedImageBytes != null) {
      return Image.memory(
        _selectedImageBytes!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (_selectedImagePath != null) {
      return Image.file(
        File(_selectedImagePath!),
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildImageSelector() {
    return InkWell(
      onTap: _isLoading ? null : _selectImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: _hasSelectedImage ? Colors.green : Colors.grey[300]!,
            width: _hasSelectedImage ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: _hasSelectedImage
              ? Colors.green.withAlpha(10)
              : (_isLoading ? Colors.grey[50] : Colors.white),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _hasSelectedImage
                    ? Colors.green.withAlpha(20)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _hasSelectedImage ? Icons.check_circle : Icons.image,
                color: _hasSelectedImage ? Colors.green : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _hasSelectedImage
                            ? 'Meetup image selected'
                            : 'Add meetup image',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _hasSelectedImage
                              ? Colors.green
                              : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _hasSelectedImage
                        ? 'Tap to change image'
                        : 'Tap to select an image (required)',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            if (_hasSelectedImage && !_isLoading)
              IconButton(
                onPressed: _removeSelectedImage,
                icon: const Icon(Icons.close, color: Colors.grey),
                iconSize: 20,
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitVisit() async {
    if (!_formKey.currentState!.validate()) return;

    // Check if image is selected (now required)
    if (!_hasSelectedImage || _selectedPlatformFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image for your meetup'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      String? downloadUrl;

      // Upload image (now required)
      downloadUrl = await ref
          .read(uploadImageControllerProvider.notifier)
          .uploadImage(_selectedPlatformFile!, "MEETUPS");

      // Return the data to the parent widget
      if (mounted) {
        Navigator.of(context).pop({
          'desc': _descController.text.trim(),
          'imageFile': _selectedPlatformFile,
          'downloadUrl': downloadUrl,
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit meetup: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descController,
      focusNode: _descFocusNode,
      maxLines: 3,
      enabled: !_isLoading,
      decoration: InputDecoration(
        labelText: 'Meetup Description',
        hintText: 'Describe the meetup, what did you learn/do/see?',
        prefixIcon: const Icon(Icons.description),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: _isLoading ? Colors.grey[50] : Colors.white,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a meetup description';
        }
        if (value.trim().length < 3) {
          return 'Description must be at least 3 characters';
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: _isLoading ? Colors.grey[300]! : Colors.grey[400]!,
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitVisit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: _isLoading ? 0 : 2,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Record Meetup',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7, // Fixed height
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  MediaQuery.of(context).viewInsets.bottom > 0
                      ? 20
                      : 4, // Minimal padding when keyboard is hidden
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    const Text(
                      'Record a Meetup',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Tell us about the meetup to this club. You can add a description and an image.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Description Field
                          _buildDescriptionField(),
                          const SizedBox(height: 16),

                          // Image Selector
                          _buildImageSelector(),
                          const SizedBox(height: 16),

                          // Image Preview
                          if (_hasSelectedImage) _buildImagePreview(),

                          const SizedBox(height: 24),

                          // Action Buttons
                          _buildActionButtons(context),

                          // Extra padding at bottom when keyboard is visible
                          SizedBox(
                              height: MediaQuery.of(context).viewInsets.bottom >
                                      0
                                  ? 40
                                  : 8), // Very minimal padding when keyboard is hidden
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
