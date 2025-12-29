import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/models/store_share_element_type_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/store_share/store_share_summary_view.dart';
import 'package:aleedz/viewmodel/store_share_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StoreShareView extends ConsumerStatefulWidget {
  String checkInTime, storeName;
  int storeId;
  int visitId;

  StoreShareView({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.storeId,
    required this.visitId,
  }) : super(key: key);

  @override
  ConsumerState<StoreShareView> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<StoreShareView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchIssues();
    });
  }

  Future<void> loadUserAndFetchIssues() async {
    final notifier = ref.read(storeShareModelProvider.notifier);
    await notifier.loadShare();
  }

  Map<String, List<StoreShareElementTypeModel>> _groupByElementType(
    List<StoreShareElementTypeModel> list,
  ) {
    final Map<String, List<StoreShareElementTypeModel>> grouped = {};
    for (final item in list) {
      final key = (item.storeShareElementTypeName ?? '').trim();
      final safeKey = key.isEmpty ? 'Other' : key;
      grouped.putIfAbsent(safeKey, () => []).add(item);
    }
    return grouped;
  }

  Widget _buildElementTypeList(StoreShareViewModel viewModel) {
    final groupedData = _groupByElementType(viewModel.elementTypeList);
    final entries = groupedData.entries.toList();

    if (entries.isEmpty) {
      return const Center(
        child: Text(
          'No store share data found',
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      );
    }

    final List<Widget> children = [];
    for (final entry in entries) {
      children.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                entry.key,
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                'Quantity',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );

      for (var i = 0; i < entry.value.length; i++) {
        final item = entry.value[i];
        final lastUpdate =
            (item.lastUpdate ?? '').trim().isEmpty
                ? 'Last update: --'
                : item.lastUpdate!;
        final quantityText = item.quantity?.toString() ?? '0';

        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                NavigationService.navigateTo(
                  StoreShareSummaryView(
                    storeName: widget.storeName,
                    checkInTime: widget.checkInTime,
                    storeId: widget.storeId,
                    visitId: widget.visitId,
                    brandId: viewModel.selectedBrand?.brandId ?? 0,
                    elementTypeId: item.storeShareElementTypeId ?? 0,
                    elementId: item.storeShareElementId ?? 0,
                    elementTypeName: entry.key,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x19000000),
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 35,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF1D2B4A), Color(0xFF1D2B4A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18),
                            bottomLeft: Radius.circular(18),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.storeShareElementName ?? '',
                                      style: const TextStyle(
                                        color: Color(0xFF111827),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      lastUpdate,
                                      style: const TextStyle(
                                        color: Color(0xFF9CA3AF),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                quantityText,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 12),
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storeShareModelProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body:
            viewModel.loader
                ? Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1f2937), Color(0xFF0f172a)],
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
                              Text(
                                LabelService().getLabel(184),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(height: 40, width: 40),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.storeName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
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
                                Icon(
                                  Icons.check,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${LabelService().getLabel(14)} ${widget.checkInTime}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
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
                    Expanded(child: _buildElementTypeList(viewModel)),
                  ],
                ),
      ),
    );
  }
}
