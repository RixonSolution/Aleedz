import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplayAuditCheck extends ConsumerStatefulWidget {
  const DisplayAuditCheck({Key? key}) : super(key: key);

  @override
  ConsumerState<DisplayAuditCheck> createState() => _DisplayAuditCheckState();
}

class _DisplayAuditCheckState extends ConsumerState<DisplayAuditCheck> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(backgroundColor: Colors.white));
  }
}
