import 'dart:io';

import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ShelfShareDetailView extends StatefulWidget {
  final String storeName;
  final String checkInTime;
  final String address;
  final int storeId;
  final int visitId;
  final String categoryName;

  const ShelfShareDetailView({
    super.key,
    required this.storeName,
    required this.checkInTime,
    required this.address,
    required this.storeId,
    required this.visitId,
    required this.categoryName,
  });

  @override
  State<ShelfShareDetailView> createState() => _ShelfShareDetailViewState();
}

class _ShelfShareDetailViewState extends State<ShelfShareDetailView> {
  final ImagePicker _imagePicker = ImagePicker();
  final Map<String, bool> _slotEnabled = {};
  final Map<String, File> _slotImages = {};

  static const List<_ShelfShareBrandConfig> _brands = [
    _ShelfShareBrandConfig('Logitech', 1, 0),
    _ShelfShareBrandConfig('Targus', 2, 0),
    _ShelfShareBrandConfig('JBL', 1, 0),
  ];

  static const List<String> _slots = ['Wall', 'Common', 'Shelf', 'Window'];

  String _slotKey(int brandIndex, String slot) => '$brandIndex-$slot';

  Future<void> _pickImage(String key) async {
    if (_slotEnabled[key] != true) return;

    final source = await showDialog<ImageSource?>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          content: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF111827), Color(0xFF0B1120)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Choose Image',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(dialogContext),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.camera_alt, color: Colors.white),
                  title: const Text(
                    'Camera',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pop(dialogContext, ImageSource.camera),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.photo_library, color: Colors.white),
                  title: const Text(
                    'Gallery',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () =>
                      Navigator.pop(dialogContext, ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null) return;
    final picked = await _imagePicker.pickImage(source: source);
    if (picked == null) return;
    if (!mounted) return;

    setState(() {
      _slotImages[key] = File(picked.path);
    });
  }

  Widget _buildPreviewButton(String key) {
    final image = _slotImages[key];
    final enabled = _slotEnabled[key] == true;

    return InkWell(
      onTap: enabled ? () => _pickImage(key) : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: enabled ? Colors.white : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled ? Colors.grey.shade400 : Colors.grey.shade300,
          ),
        ),
        child:
            image != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(image, fit: BoxFit.cover),
                )
                : Icon(
                  enabled ? Icons.image_outlined : Icons.image_not_supported,
                  color: enabled ? Colors.grey.shade800 : Colors.grey.shade500,
                  size: 26,
                ),
      ),
    );
  }

  Widget _buildSlotRow(int brandIndex, String slot) {
    final key = _slotKey(brandIndex, slot);
    final enabled = _slotEnabled[key] == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Checkbox(
              value: enabled,
              activeColor: AppColors.primary,
              onChanged: (checked) {
                setState(() {
                  _slotEnabled[key] = checked ?? false;
                  if (checked != true) {
                    _slotImages.remove(key);
                  }
                });
              },
            ),
          ),
          Expanded(
            child: Text(
              slot,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _buildPreviewButton(key),
        ],
      ),
    );
  }

  Widget _buildBrandCard(_ShelfShareBrandConfig brand, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F1F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black87, width: 0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${index + 1}. ${brand.name}',
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const SizedBox(
                  width: 78,
                  child: Text(
                    'Facing',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const SizedBox(
                  width: 78,
                  child: Text(
                    'Stock',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Spacer(),
                SizedBox(
                  width: 78,
                  child: TextFormField(
                    initialValue: brand.facing == 0 ? '' : '${brand.facing}',
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 78,
                  child: TextFormField(
                    initialValue: brand.stock == 0 ? '' : '${brand.stock}',
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            for (final slot in _slots) _buildSlotRow(index, slot),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 160,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    AppSnackBar.showSuccess(
                      context,
                      'Static preview only',
                    );
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF111827), Color(0xFF0B1120)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => NavigationService.goBack(),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Shelf Share',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.storeName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.categoryName,
                    style: const TextStyle(
                      color: Color(0xFFCBD5F5),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${LabelService().getLabel(14)} ${widget.checkInTime}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6EDEE),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.orange, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'All Brands (Select Brand)',
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (var index = 0; index < _brands.length; index++)
                        _buildBrandCard(_brands[index], index),
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

class _ShelfShareBrandConfig {
  final String name;
  final int facing;
  final int stock;

  const _ShelfShareBrandConfig(this.name, this.facing, this.stock);
}
