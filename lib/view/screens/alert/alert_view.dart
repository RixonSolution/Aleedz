import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/viewmodel/alert_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertView extends ConsumerStatefulWidget {
  const AlertView({super.key});

  @override
  ConsumerState<AlertView> createState() => _AlertViewState();
}

class _AlertViewState extends ConsumerState<AlertView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(alertProvider).init());
  }

  Future<void> _pickDate({
    required DateTime initialDate,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate != null) {
      onSelected(pickedDate);
    }
  }

  Widget _dateChip({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today, size: 16, color: AppColors.greyText),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.blackColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.secondary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.secondary : Colors.grey.shade200,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.blackColor,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(alertProvider);

    const alertTypes = [
      {'label': 'Issue', 'type': 2},
      {'label': 'Deployment', 'type': 3},
      {'label': 'Activity', 'type': 1},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _dateChip(
                    label: viewModel.formattedStartDate,
                    onTap:
                        () => _pickDate(
                          initialDate: viewModel.startDate,
                          onSelected: (date) {
                            ref.read(alertProvider).setStartDate(date);
                          },
                        ),
                  ),
                  const SizedBox(width: 10),
                  _dateChip(
                    label: viewModel.formattedEndDate,
                    onTap:
                        () => _pickDate(
                          initialDate: viewModel.endDate,
                          onSelected: (date) {
                            ref.read(alertProvider).setEndDate(date);
                          },
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    alertTypes.map((tab) {
                      final type = tab['type'] as int;
                      return _tabChip(
                        label: tab['label'] as String,
                        selected: viewModel.selectedAlertType == type,
                        onTap: () => ref.read(alertProvider).setAlertType(type),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 12),
              Expanded(
                child:
                    viewModel.loader
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.secondary,
                          ),
                        )
                        : viewModel.alerts.isEmpty
                        ? const Center(
                          child: Text(
                            'No alerts found for this range.',
                            style: TextStyle(
                              color: AppColors.greyText,
                              fontSize: 14,
                            ),
                          ),
                        )
                        : ListView.separated(
                          itemCount: viewModel.alerts.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final alert = viewModel.alerts[index];
                            final dateLabel =
                                alert.activityDateTime ?? '-';
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          alert.activityTypeName ?? 'Activity',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        dateLabel,
                                        style: const TextStyle(
                                          color: AppColors.greyText,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    alert.storeName ?? '-',
                                    style: const TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    alert.activityDescription ?? '-',
                                    style: const TextStyle(
                                      color: AppColors.greyText,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        alert.teamMemberName ?? '-',
                                        style: const TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        alert.channelName ?? '-',
                                        style: const TextStyle(
                                          color: AppColors.greyText,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Qty: ${alert.quantity ?? '-'}',
                                        style: const TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
