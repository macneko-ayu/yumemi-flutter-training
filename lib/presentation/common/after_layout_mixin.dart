import 'package:flutter/material.dart';

mixin AfterLayoutMixin<T extends StatefulWidget> on State<T> {
  Future<void> executeAfterLayout(VoidCallback action) async {
    await WidgetsBinding.instance.endOfFrame.then((_) {
      if (!mounted) {
        return;
      }
      Future.delayed(
        const Duration(milliseconds: 500),
        action,
      );
    });
  }
}
