import 'dart:io';

import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LeaveRequestView extends StatefulWidget {
  const LeaveRequestView({super.key});

  @override
  State<LeaveRequestView> createState() => _LeaveRequestViewState();
}

class _LeaveRequestViewState extends State<LeaveRequestView> {
  final ImagePicker _imagePicker = ImagePicker();
  final List<_LeaveBalance> _balances = [
    _LeaveBalance(type: 'Sick', eligible: 10, taken: 2),
    _LeaveBalance(type: 'Casual', eligible: 15, taken: 10),
    _LeaveBalance(type: 'Annual', eligible: 12, taken: 4),
  ];

  final List<_LeaveLog> _logs = [
    _LeaveLog(
      type: 'Sick',
      from: DateTime(2026, 1, 10),
      to: DateTime(2026, 1, 10),
      status: 'Pending',
    ),
    _LeaveLog(
      type: 'Sick',
      from: DateTime(2026, 1, 5),
      to: DateTime(2026, 1, 6),
      status: 'Approved',
    ),
    _LeaveLog(
      type: 'Casual',
      from: DateTime(2026, 1, 5),
      to: DateTime(2026, 1, 6),
      status: 'Rejected',
    ),
  ];

  void _openLeaveSheet() {
    String? selectedType;
    DateTime? fromDate;
    DateTime? toDate;
    File? attachment;
    final remarksController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            _LeaveBalance? selectedBalance;
            if (selectedType != null) {
              selectedBalance =
                  _balances
                      .where((b) => b.type == selectedType)
                      .cast<_LeaveBalance?>()
                      .firstOrNull();
            }

            Future<void> pickDate({required bool isFrom}) async {
              final initial =
                  isFrom
                      ? fromDate ?? DateTime.now()
                      : toDate ?? DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: initial,
                firstDate: DateTime(DateTime.now().year - 1),
                lastDate: DateTime(DateTime.now().year + 2),
              );
              if (picked == null) return;
              setModalState(() {
                if (isFrom) {
                  fromDate = picked;
                } else {
                  toDate = picked;
                }
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Leave Request',
                            style: TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(ctx).pop(),
                            child: Container(
                              height: 36,
                              width: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF2F3F5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 18,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(color: Colors.grey.shade300, height: 1),
                      const SizedBox(height: 16),
                      _fieldLabel('Leave Type'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        decoration: _sheetInputDecoration('Select leave type'),
                        items:
                            _balances
                                .map(
                                  (type) => DropdownMenuItem<String>(
                                    value: type.type,
                                    child: Text(type.type),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setModalState(() {
                            selectedType = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      if (selectedBalance != null)
                        _leaveBalanceCard(selectedBalance),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _dateBox(
                              label: 'From Date',
                              value: _formatDate(fromDate),
                              onTap: () => pickDate(isFrom: true),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _dateBox(
                              label: 'To Date',
                              value: _formatDate(toDate),
                              onTap: () => pickDate(isFrom: false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _fieldLabel('Remarks'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: remarksController,
                        maxLines: 3,
                        decoration: _sheetInputDecoration('Remarks'),
                      ),
                      const SizedBox(height: 12),
                      _fieldLabel('Attachment'),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final picked = await _imagePicker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (picked == null) return;
                          setModalState(() {
                            attachment = File(picked.path);
                          });
                        },
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            children: [
                              const Icon(Icons.attach_file),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  attachment == null
                                      ? 'Upload Photo'
                                      : attachment!.path.split('/').last,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (selectedType == null ||
                                fromDate == null ||
                                toDate == null) {
                              AppSnackBar.showError(
                                context,
                                'Please select leave type and dates.',
                              );
                              return;
                            }
                            setState(() {
                              _logs.insert(
                                0,
                                _LeaveLog(
                                  type: selectedType!,
                                  from: fromDate!,
                                  to: toDate!,
                                  status: 'Pending',
                                ),
                              );
                            });
                            Navigator.of(ctx).pop();
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(ctx).padding.bottom + 12),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle('Leave Request'),
                          const SizedBox(height: 8),
                          _leaveBalanceTable(),
                          const SizedBox(height: 16),
                          _sectionTitle('Leave log'),
                          const SizedBox(height: 8),
                          _leaveLogTable(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: GestureDetector(
                      onTap: _openLeaveSheet,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Request new leave',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
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

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF0B1120)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Leave Request',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _leaveBalanceTable() {
    return Column(
      children: [
        _tableHeader(const ['Leave Type', 'Eligible', 'Taken', 'Balance']),
        ..._balances.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return _tableRow([
            item.type,
            item.eligible.toString(),
            item.taken.toString(),
            item.balance.toString(),
          ], shaded: index.isEven);
        }),
      ],
    );
  }

  Widget _leaveLogTable() {
    return Column(
      children: [
        _tableHeader(const ['Leave Type', 'Date From - To', 'Status']),
        ..._logs.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return _tableRow(
            [
              item.type,
              '${_formatDate(item.from)} - ${_formatDate(item.to)}',
              item.status,
            ],
            shaded: index.isEven,
            statusColor: _statusColor(item.status),
          );
        }),
      ],
    );
  }

  Widget _tableHeader(List<String> labels) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.secondary),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children:
            labels
                .map(
                  (label) => Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _tableRow(
    List<String> values, {
    bool shaded = false,
    Color? statusColor,
  }) {
    return Container(
      color: shaded ? Colors.grey.shade200 : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              values[0],
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(values[1], style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            child: Text(
              values[2],
              style: TextStyle(fontSize: 12, color: statusColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _leaveBalanceCard(_LeaveBalance balance) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F5C77),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Eligible: ${balance.eligible}  Taken: ${balance.taken}  Balance: ${balance.balance}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _dateBox({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _sheetInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF7F8FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF111827),
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--';
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d-$m-$y';
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}

class _LeaveBalance {
  _LeaveBalance({
    required this.type,
    required this.eligible,
    required this.taken,
  });

  final String type;
  final int eligible;
  final int taken;

  int get balance => eligible - taken;
}

class _LeaveLog {
  _LeaveLog({
    required this.type,
    required this.from,
    required this.to,
    required this.status,
  });

  final String type;
  final DateTime from;
  final DateTime to;
  final String status;
}

extension on Iterable<_LeaveBalance?> {
  _LeaveBalance? firstOrNull() {
    for (final item in this) {
      if (item != null) return item;
    }
    return null;
  }
}
