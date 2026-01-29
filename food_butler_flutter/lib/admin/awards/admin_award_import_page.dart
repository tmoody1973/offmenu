import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'import_preview_section.dart';

/// Admin page for importing award data from CSV files.
///
/// Supports:
/// - Drag-and-drop file upload
/// - File type selection (Michelin or James Beard)
/// - Upload progress indicator
/// - Validation error display
class AdminAwardImportPage extends StatefulWidget {
  const AdminAwardImportPage({super.key});

  @override
  State<AdminAwardImportPage> createState() => _AdminAwardImportPageState();
}

class _AdminAwardImportPageState extends State<AdminAwardImportPage> {
  String? _selectedAwardType;
  String? _fileName;
  String? _fileContent;
  bool _isLoading = false;
  String? _errorMessage;
  List<ImportPreviewItem>? _previewItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Awards'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildAwardTypeSelector(),
            const SizedBox(height: 24),
            _buildFileUploadZone(),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              _buildErrorMessage(),
            ],
            if (_previewItems != null) ...[
              const SizedBox(height: 24),
              ImportPreviewSection(
                items: _previewItems!,
                awardType: _selectedAwardType!,
                onConfirm: _handleConfirmImport,
                onCancel: _handleCancelImport,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Import Award Data',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Upload a CSV file containing Michelin Guide or James Beard Foundation award data.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
      ],
    );
  }

  Widget _buildAwardTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Award Type',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: [
            _buildAwardTypeChip(
              label: 'Michelin Guide',
              value: 'michelin',
              icon: Icons.star_rounded,
              color: Colors.amber,
            ),
            _buildAwardTypeChip(
              label: 'James Beard Foundation',
              value: 'james_beard',
              icon: Icons.workspace_premium,
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAwardTypeChip({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedAwardType == value;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: isSelected ? Colors.white : color),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        setState(() {
          _selectedAwardType = selected ? value : null;
          _previewItems = null;
          _errorMessage = null;
        });
      },
      selectedColor: color,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildFileUploadZone() {
    return GestureDetector(
      onTap: _selectedAwardType != null ? _pickFile : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: _selectedAwardType != null
              ? Colors.blue.shade50
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedAwardType != null
                ? Colors.blue.shade200
                : Colors.grey.shade300,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            if (_isLoading)
              const CircularProgressIndicator()
            else ...[
              Icon(
                _fileName != null ? Icons.check_circle : Icons.cloud_upload,
                size: 48,
                color: _fileName != null
                    ? Colors.green
                    : (_selectedAwardType != null
                        ? Colors.blue.shade400
                        : Colors.grey.shade400),
              ),
              const SizedBox(height: 16),
              Text(
                _fileName ?? 'Click to upload CSV file',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _selectedAwardType != null
                      ? Colors.blue.shade700
                      : Colors.grey.shade500,
                ),
              ),
              if (_selectedAwardType == null) ...[
                const SizedBox(height: 8),
                Text(
                  'Please select an award type first',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'json'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _fileName = file.name;
          _isLoading = true;
          _errorMessage = null;
        });

        // Read file content
        if (file.bytes != null) {
          _fileContent = String.fromCharCodes(file.bytes!);
          await _previewImport();
        } else {
          setState(() {
            _errorMessage = 'Unable to read file content';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error picking file: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _previewImport() async {
    if (_fileContent == null || _selectedAwardType == null) return;

    // Simulate API call for preview
    // In real implementation, this would call the backend preview endpoint
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isLoading = false;
      // Mock preview items for demonstration
      _previewItems = _parseMockPreview();
    });
  }

  List<ImportPreviewItem> _parseMockPreview() {
    // This is a mock implementation
    // In real implementation, the backend would return preview results
    return [
      ImportPreviewItem(
        recordName: 'Alinea',
        recordCity: 'Chicago',
        recordYear: 2024,
        matchedRestaurantName: 'Alinea',
        confidence: 0.98,
        status: 'auto_match',
      ),
      ImportPreviewItem(
        recordName: 'The French Laundry',
        recordCity: 'Yountville',
        recordYear: 2024,
        matchedRestaurantName: 'French Laundry',
        confidence: 0.85,
        status: 'pending_review',
      ),
      ImportPreviewItem(
        recordName: 'Unknown Restaurant',
        recordCity: 'Unknown City',
        recordYear: 2024,
        matchedRestaurantName: null,
        confidence: null,
        status: 'no_match',
      ),
    ];
  }

  Future<void> _handleConfirmImport() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate import API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _previewItems = null;
      _fileName = null;
      _fileContent = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Awards imported successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _handleCancelImport() {
    setState(() {
      _previewItems = null;
      _fileName = null;
      _fileContent = null;
      _errorMessage = null;
    });
  }
}
