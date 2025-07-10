import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';
import 'package:rotaract/_core/notifiers/upload_image_controller.dart';

class NewEventSheet extends ConsumerStatefulWidget {
  const NewEventSheet({super.key});

  @override
  ConsumerState<NewEventSheet> createState() => _NewEventSheetState();
}

class _NewEventSheetState extends ConsumerState<NewEventSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  // Image selection variables
  bool _hasSelectedImage = false;
  String? _selectedImagePath;
  Uint8List? _selectedImageBytes;
  PlatformFile? _selectedPlatformFile;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _startDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );

          // If end date is before start date, reset it
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        });
      }
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime initialDate = _endDate ?? _startDate ?? DateTime.now();
    final DateTime firstDate = _startDate ?? DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: _endDate != null
            ? TimeOfDay.fromDateTime(_endDate!)
            : TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _endDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _selectImage() async {
    if (_isLoading) return;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final pickedFile = result.files.first;

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
          SnackBar(content: Text('Failed to select image: $e')),
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

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${TimeOfDay.fromDateTime(dateTime).format(context)}';
  }

  Widget _buildImagePreview() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: _hasSelectedImage ? Colors.green : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(12),
          color: _hasSelectedImage ? Colors.green.withAlphaa(0.05) : null,
        ),
        child: Row(
          children: [
            Icon(
              Icons.image,
              color: _hasSelectedImage ? Colors.green : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _hasSelectedImage
                    ? 'Event image selected'
                    : 'Select event image (optional)',
                style: TextStyle(
                  fontSize: 16,
                  color: _hasSelectedImage ? Colors.green : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createClubEvent() async {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a start date')),
        );
        return;
      }

      if (_endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an end date')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        String? downloadUrl;

        // Upload image if selected
        if (_hasSelectedImage && _selectedPlatformFile != null) {
          // TODO: Replace with your actual image upload logic
          // Example: downloadUrl = await uploadImageToStorage(_selectedPlatformFile!);

          // Simulate image upload
          await Future.delayed(const Duration(seconds: 2));
          // Replace with actual upload URL
          downloadUrl = await ref
              .read(uploadImageControllerProvider.notifier)
              .uploadImage(_selectedPlatformFile!, "EVENTS");
        }

        // Return the data to the parent widget
        if (mounted) {
          Navigator.of(context).pop({
            'title': _titleController.text.trim(),
            'startDate': _startDate,
            'endDate': _endDate,
            'location': _locationController.text.trim(),
            'imageFile':
                _selectedPlatformFile, // Include the selected image file
            'downloadUrl': downloadUrl,
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create event: $e')),
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Create Club Event',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'Create a new event for your club members',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Form - Changed from Expanded to Flexible with shrinkWrap
            Flexible(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Event Title Field
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Event Title',
                          hintText: 'Enter event title',
                          prefixIcon: const Icon(Icons.event),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter an event title';
                          }
                          if (value.trim().length < 3) {
                            return 'Event title must be at least 3 characters';
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 16),

                      // Start Date Field
                      InkWell(
                        onTap: _selectStartDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: Colors.grey[600]),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _startDate != null
                                      ? 'Start: ${_formatDateTime(_startDate!)}'
                                      : 'Select start date & time',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _startDate != null
                                        ? Colors.black
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // End Date Field
                      InkWell(
                        onTap: _selectEndDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today_outlined,
                                  color: Colors.grey[600]),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _endDate != null
                                      ? 'End: ${_formatDateTime(_endDate!)}'
                                      : 'Select end date & time',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _endDate != null
                                        ? Colors.black
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Location Field
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Location',
                          hintText: 'Enter event location',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a location';
                          }
                          if (value.trim().length < 3) {
                            return 'Location must be at least 3 characters';
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 16),

                      // Image Selector
                      _buildImageSelector(),
                      const SizedBox(height: 16),

                      // Image Preview
                      if (_hasSelectedImage) _buildImagePreview(),

                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _createClubEvent,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
                                  : const Text('Create Event'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
